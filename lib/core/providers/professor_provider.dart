import 'package:flutter/foundation.dart';
import '../../models/professor.dart';
import '../repositories/professor_repository.dart';

/// Provider para gestión del estado de profesores
/// Implementa el patrón Provider para separar lógica de UI
class ProfessorProvider extends ChangeNotifier {
  final ProfessorRepository _repository;
  
  List<Professor> _professors = [];
  List<Professor> _favoriteProfessors = [];
  List<Professor> _topProfessors = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String? _errorMessage;

  ProfessorProvider(this._repository);

  // Getters
  List<Professor> get professors => _professors;
  List<Professor> get favoriteProfessors => _favoriteProfessors;
  List<Professor> get topProfessors => _topProfessors;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Carga profesores por categoría
  Future<void> loadProfessorsByCategory(String category) async {
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
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar profesores: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Busca profesores por query
  Future<List<Professor>> searchProfessors(String query) async {
    try {
      return await _repository.searchProfessors(query);
    } catch (e) {
      _errorMessage = 'Error en búsqueda: $e';
      return [];
    }
  }

  /// Cambia la categoría seleccionada
  void changeCategory(String category) {
    if (_selectedCategory != category) {
      loadProfessorsByCategory(category);
    }
  }

  /// Obtiene un profesor por ID
  Future<Professor?> getProfessorById(String id) async {
    return await _repository.getProfessorById(id);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
