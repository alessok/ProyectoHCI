import 'package:flutter/foundation.dart';

/// Niveles de logging
enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

/// Servicio centralizado de logging
class LoggerService {
  static const String _appName = 'ProfessorRankingApp';
  
  /// Log de debug (solo en desarrollo)
  static void debug(String message, {String? tag, Object? data}) {
    if (kDebugMode) {
      _log(LogLevel.debug, message, tag: tag, data: data);
    }
  }
  
  /// Log de información
  static void info(String message, {String? tag, Object? data}) {
    _log(LogLevel.info, message, tag: tag, data: data);
  }
  
  /// Log de advertencia
  static void warning(String message, {String? tag, Object? data, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, tag: tag, data: data, stackTrace: stackTrace);
  }
  
  /// Log de error
  static void error(String message, {String? tag, Object? data, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, data: data, stackTrace: stackTrace);
  }
  
  /// Log crítico
  static void critical(String message, {String? tag, Object? data, StackTrace? stackTrace}) {
    _log(LogLevel.critical, message, tag: tag, data: data, stackTrace: stackTrace);
  }
  
  /// Método interno para logging
  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? data,
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase();
    final tagStr = tag != null ? '[$tag]' : '';
    final dataStr = data != null ? ' | Data: $data' : '';
    final stackStr = stackTrace != null ? '\nStackTrace: $stackTrace' : '';
    
    final logMessage = '[$_appName] $timestamp $levelStr $tagStr: $message$dataStr$stackStr';
    
    switch (level) {
      case LogLevel.debug:
        debugPrint(logMessage);
        break;
      case LogLevel.info:
        debugPrint(logMessage);
        break;
      case LogLevel.warning:
        debugPrint('⚠️  $logMessage');
        break;
      case LogLevel.error:
        debugPrint('❌ $logMessage');
        break;
      case LogLevel.critical:
        debugPrint('🚨 $logMessage');
        break;
    }
    
    // En producción, aquí podrías enviar logs a servicios externos
    // como Firebase Crashlytics, Sentry, etc.
    _sendToExternalService(level, message, tag, data, stackTrace);
  }
  
  /// Enviar logs a servicios externos (para producción)
  static void _sendToExternalService(
    LogLevel level,
    String message,
    String? tag,
    Object? data,
    StackTrace? stackTrace,
  ) {
    // TODO: Implementar envío a Firebase Crashlytics, Sentry, etc.
    if (level == LogLevel.error || level == LogLevel.critical) {
      // Enviar errores críticos a servicios de monitoreo
    }
  }
  
  /// Log de performance
  static void performance(String operation, Duration duration, {String? tag}) {
    final durationMs = duration.inMilliseconds;
    final level = durationMs > 1000 ? LogLevel.warning : LogLevel.info;
    _log(
      level,
      'Performance: $operation took $durationMs ms',
      tag: tag ?? 'PERFORMANCE',
    );
  }
  
  /// Log de operaciones de Firebase
  static void firebase(String operation, {String? collection, String? documentId, Object? data}) {
    _log(
      LogLevel.info,
      'Firebase: $operation',
      tag: 'FIREBASE',
      data: {
        'operation': operation,
        'collection': collection,
        'documentId': documentId,
        'data': data,
      },
    );
  }
  
  /// Log de autenticación
  static void auth(String operation, {String? userId, String? email, Object? data}) {
    _log(
      LogLevel.info,
      'Auth: $operation',
      tag: 'AUTH',
      data: {
        'operation': operation,
        'userId': userId,
        'email': email,
        'data': data,
      },
    );
  }
  
  /// Log de operaciones de usuario
  static void user(String operation, {String? userId, String? action, Object? data}) {
    _log(
      LogLevel.info,
      'User: $operation',
      tag: 'USER',
      data: {
        'operation': operation,
        'userId': userId,
        'action': action,
        'data': data,
      },
    );
  }
} 