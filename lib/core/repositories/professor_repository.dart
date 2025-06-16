import '../../models/professor.dart';

/// Interfaz abstracta para el repositorio de profesores
/// Define los métodos que debe implementar cualquier fuente de datos
abstract class ProfessorRepository {
  /// Obtiene todos los profesores
  Future<List<Professor>> getAllProfessors();
  
  /// Obtiene profesores por departamento
  Future<List<Professor>> getProfessorsByDepartment(String department);
  
  /// Obtiene profesores favoritos (mejor calificados)
  Future<List<Professor>> getFavoriteProfessors({int limit = 5});
  
  /// Obtiene top profesores (más reseñas)
  Future<List<Professor>> getTopProfessors({int limit = 5});
  
  /// Busca profesores por query
  Future<List<Professor>> searchProfessors(String query);
  
  /// Obtiene un profesor por ID
  Future<Professor?> getProfessorById(String id);
  
  /// Obtiene todos los departamentos
  Future<List<String>> getAllDepartments();
  
  /// Verifica si un profesor está en favoritos
  Future<bool> isFavoriteProfessor(String professorId);
  
  /// Agrega/quita profesor de favoritos
  Future<void> toggleFavoriteProfessor(String professorId);
}
