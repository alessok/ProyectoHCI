import 'package:flutter/foundation.dart';
import '../../models/professor.dart';
import '../repositories/professor_repository.dart';

/// Provider para gestión del estado de profesores
/// Implementa el patrón Provider para separar lógica de UI
/// Incluye optimizaciones de performance y cache
class ProfessorProvider extends ChangeNotifier {
  final ProfessorRepository _repository;
  
  List<Professor> _professors = [];
  List<Professor> _favoriteProfessors = [];
  List<Professor> _topProfessors = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String? _errorMessage;

  // Cache para mejorar performance
  final Map<String, List<Professor>> _categoryCache = {};
  final Map<String, List<Professor>> _searchCache = {};
  DateTime? _lastCacheUpdate;
  static const int cacheExpirationMinutes = 5;

  ProfessorProvider(this._repository);

  // Getters
  List<Professor> get professors => List.unmodifiable(_professors);
  List<Professor> get favoriteProfessors => List.unmodifiable(_favoriteProfessors);
  List<Professor> get topProfessors => List.unmodifiable(_topProfessors);
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Verifica si el cache es válido
  bool _isCacheValid() {
    if (_lastCacheUpdate == null) return false;
    final now = DateTime.now();
    final difference = now.difference(_lastCacheUpdate!);
    return difference.inMinutes < cacheExpirationMinutes;
  }

  /// Invalida el cache cuando sea necesario
  void invalidateCache() {
    _categoryCache.clear();
    _searchCache.clear();
    _lastCacheUpdate = null;
  }

  /// Carga profesores por categoría con cache
  Future<void> loadProfessorsByCategory(String category) async {
    // Verificar cache primero
    if (_isCacheValid() && _categoryCache.containsKey(category)) {
      _professors = _categoryCache[category]!;
      _selectedCategory = category;
      
      if (category == 'All') {
        _favoriteProfessors = _professors.take(5).toList();
        _topProfessors = _professors.take(3).toList();
      } else {
        _favoriteProfessors = _professors.take(5).toList();
        _topProfessors = _professors.take(3).toList();
      }
      
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      _selectedCategory = category;
      
      if (category == 'All') {
        _professors = await _repository.getAllProfessors();
        _favoriteProfessors = await _repository.getFavoriteProfessors(limit: 5);
        _topProfessors = await _repository.getTopProfessors(limit: 3);
      } else {
        _professors = await _repository.getProfessorsByDepartment(category);
        _favoriteProfessors = _professors.take(5).toList();
        _topProfessors = _professors.take(3).toList();
      }
      
      // Actualizar cache
      _categoryCache[category] = List.from(_professors);
      _lastCacheUpdate = DateTime.now();
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar profesores: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Busca profesores por query con cache y debounce
  Future<List<Professor>> searchProfessors(String query) async {
    // Cache para búsquedas
    if (_searchCache.containsKey(query)) {
      return _searchCache[query]!;
    }

    try {
      final results = await _repository.searchProfessors(query);
      
      // Cache del resultado si no está vacío
      if (results.isNotEmpty) {
        _searchCache[query] = results;
      }
      
      return results;
    } catch (e) {
      _errorMessage = 'Error en búsqueda: $e';
      return [];
    }
  }

  /// Cambia la categoría seleccionada con optimización
  void changeCategory(String category) {
    if (_selectedCategory != category) {
      loadProfessorsByCategory(category);
    }
  }

  /// Obtiene un profesor por ID con cache
  Future<Professor?> getProfessorById(String id) async {
    // Buscar primero en las listas cargadas (cache local)
    Professor? professor;
    
    // Buscar en profesores actuales
    try {
      professor = _professors.firstWhere((p) => p.id == id);
      return professor;
    } catch (e) {
      // No encontrado en cache local
    }
    
    // Buscar en favoritos
    try {
      professor = _favoriteProfessors.firstWhere((p) => p.id == id);
      return professor;
    } catch (e) {
      // No encontrado en favoritos
    }
    
    // Buscar en top profesores
    try {
      professor = _topProfessors.firstWhere((p) => p.id == id);
      return professor;
    } catch (e) {
      // No encontrado en top profesores
    }
    
    // Última opción: consultar al repositorio
    return await _repository.getProfessorById(id);
  }

  /// Precargar datos para mejorar UX
  Future<void> preloadData() async {
    if (!_isCacheValid()) {
      await loadProfessorsByCategory('All');
      
      // Precargar categorías más comunes
      final commonCategories = ['Ing. Sistemas', 'Ing. Industrial', 'Ing. Civil'];
      
      for (final category in commonCategories) {
        try {
          final professors = await _repository.getProfessorsByDepartment(category);
          _categoryCache[category] = professors;
        } catch (e) {
          // Ignorar errores en precarga
        }
      }
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> isFavoriteProfessor(String professorId) async {
    return await _repository.isFavoriteProfessor(professorId);
  }

  Future<void> toggleFavoriteProfessor(String professorId) async {
    await _repository.toggleFavoriteProfessor(professorId);
  }

  @override
  void dispose() {
    _categoryCache.clear();
    _searchCache.clear();
    super.dispose();
  }
}
