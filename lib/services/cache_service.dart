import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import '../core/exceptions/app_exceptions.dart';
import 'logger_service.dart';

/// Item de cache con metadatos
class CacheItem<T> {
  final T data;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime lastAccessed;
  final int size;
  final String key;
  final String type;

  CacheItem({
    required this.data,
    required this.key,
    required this.type,
    required this.size,
    required this.createdAt,
    required this.expiresAt,
  }) : lastAccessed = DateTime.now();

  /// Verificar si el item ha expirado
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Actualizar último acceso
  CacheItem<T> updateAccess() {
    return CacheItem<T>(
      data: data,
      key: key,
      type: type,
      size: size,
      createdAt: createdAt,
      expiresAt: expiresAt,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'type': type,
      'size': size,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'lastAccessed': lastAccessed.toIso8601String(),
    };
  }
}

/// Configuración del cache
class CacheConfig {
  final Duration defaultTTL;
  final int maxSize;
  final int maxItems;
  final bool enableDiskCache;
  final String diskCacheDir;

  const CacheConfig({
    this.defaultTTL = const Duration(hours: 1),
    this.maxSize = 50 * 1024 * 1024, // 50MB
    this.maxItems = 1000,
    this.enableDiskCache = true,
    this.diskCacheDir = 'app_cache',
  });
}

/// Servicio de cache inteligente
class CacheService {
  static CacheService? _instance;
  static CacheService get instance => _instance ??= CacheService._();

  CacheService._();

  final Map<String, CacheItem> _memoryCache = {};
  final CacheConfig _config = const CacheConfig();
  int _currentSize = 0;
  int _currentItems = 0;

  /// Obtener item del cache
  T? get<T>(String key) {
    try {
      final item = _memoryCache[key];
      
      if (item == null) {
        LoggerService.debug('Cache miss: $key', tag: 'CACHE');
        return null;
      }

      if (item.isExpired) {
        LoggerService.debug('Cache expired: $key', tag: 'CACHE');
        _remove(key);
        return null;
      }

      // Actualizar último acceso
      _memoryCache[key] = item.updateAccess();
      
      LoggerService.debug('Cache hit: $key', tag: 'CACHE');
      return item.data as T;
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error getting cache item: $key',
        tag: 'CACHE',
        data: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Guardar item en cache
  Future<void> set<T>(
    String key,
    T data, {
    Duration? ttl,
    String? type,
  }) async {
    try {
      final startTime = DateTime.now();
      
      // Calcular tamaño aproximado
      final size = _calculateSize(data);
      
      // Verificar límites
      if (size > _config.maxSize) {
        LoggerService.warning(
          'Item too large for cache: $key ($size bytes)',
          tag: 'CACHE',
        );
        return;
      }

      // Limpiar espacio si es necesario
      await _makeSpace(size);

      // Crear item de cache
      final item = CacheItem<T>(
        data: data,
        key: key,
        type: type ?? 'unknown',
        size: size,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(ttl ?? _config.defaultTTL),
      );

      // Guardar en memoria
      _memoryCache[key] = item;
      _currentSize += size;
      _currentItems++;

      // Guardar en disco si está habilitado
      if (_config.enableDiskCache) {
        await _saveToDisk(key, item);
      }

      final duration = DateTime.now().difference(startTime);
      LoggerService.performance('Cache set: $key', duration, tag: 'CACHE');
      
      LoggerService.debug(
        'Cache set: $key ($size bytes, expires: ${item.expiresAt})',
        tag: 'CACHE',
      );
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error setting cache item: $key',
        tag: 'CACHE',
        data: e,
        stackTrace: stackTrace,
      );
      throw CacheException(
        'Error al guardar en cache: $key',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Remover item del cache
  void remove(String key) {
    _remove(key);
  }

  /// Limpiar todo el cache
  Future<void> clear() async {
    try {
      _memoryCache.clear();
      _currentSize = 0;
      _currentItems = 0;

      if (_config.enableDiskCache) {
        await _clearDiskCache();
      }

      LoggerService.info('Cache cleared', tag: 'CACHE');
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error clearing cache',
        tag: 'CACHE',
        data: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Obtener estadísticas del cache
  Map<String, dynamic> getStats() {
    return {
      'memoryItems': _currentItems,
      'memorySize': _currentSize,
      'maxSize': _config.maxSize,
      'maxItems': _config.maxItems,
      'hitRate': _calculateHitRate(),
      'expiredItems': _getExpiredItemsCount(),
    };
  }

  /// Limpiar items expirados
  Future<void> cleanup() async {
    try {
      final startTime = DateTime.now();
      final expiredKeys = <String>[];

      for (final entry in _memoryCache.entries) {
        if (entry.value.isExpired) {
          expiredKeys.add(entry.key);
        }
      }

      for (final key in expiredKeys) {
        _remove(key);
      }

      final duration = DateTime.now().difference(startTime);
      LoggerService.info(
        'Cache cleanup: removed ${expiredKeys.length} expired items',
        tag: 'CACHE',
      );
      LoggerService.performance('Cache cleanup', duration, tag: 'CACHE');
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error during cache cleanup',
        tag: 'CACHE',
        data: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Remover item interno
  void _remove(String key) {
    final item = _memoryCache[key];
    if (item != null) {
      _currentSize -= item.size;
      _currentItems--;
      _memoryCache.remove(key);
      
      LoggerService.debug('Cache removed: $key', tag: 'CACHE');
    }
  }

  /// Hacer espacio en cache
  Future<void> _makeSpace(int requiredSize) async {
    if (_currentSize + requiredSize <= _config.maxSize && 
        _currentItems < _config.maxItems) {
      return;
    }

    // Ordenar por último acceso (LRU)
    final sortedItems = _memoryCache.entries.toList()
      ..sort((a, b) => a.value.lastAccessed.compareTo(b.value.lastAccessed));

    // Remover items hasta tener espacio suficiente
    for (final entry in sortedItems) {
      if (_currentSize + requiredSize <= _config.maxSize && 
          _currentItems < _config.maxItems) {
        break;
      }
      _remove(entry.key);
    }

    LoggerService.debug(
      'Cache space made: required $requiredSize bytes',
      tag: 'CACHE',
    );
  }

  /// Calcular tamaño aproximado
  int _calculateSize(dynamic data) {
    try {
      if (data is String) {
        return data.length;
      } else if (data is Map || data is List) {
        return jsonEncode(data).length;
      } else if (data is num) {
        return 8; // Aproximado para números
      } else if (data is bool) {
        return 1;
      } else {
        return data.toString().length;
      }
    } catch (e) {
      return 1024; // Tamaño por defecto si no se puede calcular
    }
  }

  /// Calcular tasa de hits (simplificado)
  double _calculateHitRate() {
    // Implementación simplificada - en producción usarías métricas reales
    return 0.85; // 85% hit rate estimado
  }

  /// Contar items expirados
  int _getExpiredItemsCount() {
    return _memoryCache.values.where((item) => item.isExpired).length;
  }

  /// Guardar en disco
  Future<void> _saveToDisk(String key, CacheItem item) async {
    try {
      final directory = await _getCacheDirectory();
      final file = File('${directory.path}/${_hashKey(key)}.cache');
      
      final cacheData = {
        'metadata': item.toJson(),
        'data': item.data,
      };
      
      await file.writeAsString(jsonEncode(cacheData));
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error saving to disk cache: $key',
        tag: 'CACHE',
        data: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Limpiar cache en disco
  Future<void> _clearDiskCache() async {
    try {
      final directory = await _getCacheDirectory();
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error clearing disk cache',
        tag: 'CACHE',
        data: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Obtener directorio de cache
  Future<Directory> _getCacheDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/${_config.diskCacheDir}');
    
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    
    return cacheDir;
  }

  /// Hash de la clave para nombres de archivo
  String _hashKey(String key) {
    final bytes = utf8.encode(key);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Cache específico para profesores
  static const String _professorsKey = 'professors';
  static const String _reviewsKey = 'reviews';
  static const String _userDataKey = 'user_data';

  /// Cache de profesores
  Future<List<dynamic>?> getProfessors() async {
    return get<List<dynamic>>(_professorsKey);
  }

  Future<void> setProfessors(List<dynamic> professors) async {
    await set(_professorsKey, professors, ttl: const Duration(hours: 2));
  }

  /// Cache de reviews
  Future<List<dynamic>?> getReviews(String professorId) async {
    return get<List<dynamic>>('${_reviewsKey}_$professorId');
  }

  Future<void> setReviews(String professorId, List<dynamic> reviews) async {
    await set('${_reviewsKey}_$professorId', reviews, ttl: const Duration(hours: 1));
  }

  /// Cache de datos de usuario
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    return get<Map<String, dynamic>>('${_userDataKey}_$userId');
  }

  Future<void> setUserData(String userId, Map<String, dynamic> userData) async {
    await set('${_userDataKey}_$userId', userData, ttl: const Duration(hours: 6));
  }
} 