import '../../models/professor.dart';
import '../../services/hybrid_data_service.dart';
import 'professor_repository.dart';

/// Repositorio híbrido que combina datos mock existentes con Firebase
/// Mantiene los datos reales de la universidad pero usa Firebase para funcionalidades dinámicas
class HybridProfessorRepository implements ProfessorRepository {
  
  @override
  Future<List<Professor>> getAllProfessors() async {
    return await HybridDataService.getAllProfessors();
  }

  @override
  Future<List<Professor>> getProfessorsByDepartment(String department) async {
    return await HybridDataService.getProfessorsByDepartment(department);
  }

  @override
  Future<List<Professor>> getFavoriteProfessors({int limit = 5}) async {
    return await HybridDataService.getFavoriteProfessors(limit: limit);
  }

  @override
  Future<List<Professor>> getTopProfessors({int limit = 5}) async {
    return await HybridDataService.getTopProfessors(limit: limit);
  }

  @override
  Future<List<Professor>> searchProfessors(String query) async {
    if (query.trim().isEmpty) return [];
    return await HybridDataService.searchProfessors(query.trim());
  }

  @override
  Future<Professor?> getProfessorById(String id) async {
    return await HybridDataService.getProfessorById(id);
  }

  @override
  Future<List<String>> getAllDepartments() async {
    return await HybridDataService.getAllDepartments();
  }

  @override
  Future<bool> isFavoriteProfessor(String professorId) async {
    return await HybridDataService.isFavoriteProfessor(professorId);
  }

  @override
  Future<void> toggleFavoriteProfessor(String professorId) async {
    await HybridDataService.toggleFavoriteProfessor(professorId);
  }
} 