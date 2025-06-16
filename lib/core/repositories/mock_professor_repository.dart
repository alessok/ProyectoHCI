import '../../models/professor.dart';
import '../../services/mock_data_service.dart';
import 'professor_repository.dart';

/// Implementación del repositorio usando MockDataService
/// Esta clase adapta el MockDataService a la interfaz del repositorio
class MockProfessorRepository implements ProfessorRepository {
  
  @override
  Future<List<Professor>> getAllProfessors() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 200));
    return MockDataService.getAllProfessors();
  }

  @override
  Future<List<Professor>> getProfessorsByDepartment(String department) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockDataService.getProfessorsByDepartment(department);
  }

  @override
  Future<List<Professor>> getFavoriteProfessors({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockDataService.getFavoriteProfessors(limit: limit);
  }

  @override
  Future<List<Professor>> getTopProfessors({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockDataService.getTopProfessors(limit: limit);
  }

  @override
  Future<List<Professor>> searchProfessors(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockDataService.searchProfessors(query);
  }

  @override
  Future<Professor?> getProfessorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return MockDataService.getProfessorById(id);
  }

  @override
  Future<List<String>> getAllDepartments() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockDataService.getAllDepartments();
  }

  @override
  Future<bool> isFavoriteProfessor(String professorId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockDataService.isFavoriteProfessor(professorId);
  }

  @override
  Future<void> toggleFavoriteProfessor(String professorId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // TODO: Implementar lógica para toggle favoritos
    // Por ahora solo simulamos el delay
  }
}
