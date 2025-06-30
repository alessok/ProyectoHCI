import '../../models/professor.dart';
import '../../services/firebase_service.dart';
import 'professor_repository.dart';

/// Implementación del repositorio usando Firebase
/// Esta clase usa FirebaseService para todas las operaciones
class FirebaseProfessorRepository implements ProfessorRepository {
  
  @override
  Future<List<Professor>> getAllProfessors() async {
    return await FirebaseService.getAllProfessors();
  }

  @override
  Future<List<Professor>> getProfessorsByDepartment(String department) async {
    return await FirebaseService.getProfessorsByDepartment(department);
  }

  @override
  Future<List<Professor>> getFavoriteProfessors({int limit = 5}) async {
    // Obtener profesores favoritos del usuario actual
    final currentUser = FirebaseService.getCurrentUser();
    if (currentUser == null) return [];
    
    final favoriteIds = await FirebaseService.getUserFavorites(currentUser.uid);
    if (favoriteIds.isEmpty) return [];
    
    // Obtener los profesores favoritos
    final allProfessors = await getAllProfessors();
    final favoriteProfessors = allProfessors
        .where((professor) => favoriteIds.contains(professor.id))
        .toList();
    
    // Ordenar por rating y limitar
    favoriteProfessors.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return favoriteProfessors.take(limit).toList();
  }

  @override
  Future<List<Professor>> getTopProfessors({int limit = 5}) async {
    return await FirebaseService.getTopProfessors(limit: limit);
  }

  @override
  Future<List<Professor>> searchProfessors(String query) async {
    if (query.trim().isEmpty) return [];
    return await FirebaseService.searchProfessors(query.trim());
  }

  @override
  Future<Professor?> getProfessorById(String id) async {
    return await FirebaseService.getProfessorById(id);
  }

  @override
  Future<List<String>> getAllDepartments() async {
    return await FirebaseService.getAllDepartments();
  }

  @override
  Future<bool> isFavoriteProfessor(String professorId) async {
    final currentUser = FirebaseService.getCurrentUser();
    if (currentUser == null) return false;
    
    return await FirebaseService.isFavorite(currentUser.uid, professorId);
  }

  @override
  Future<void> toggleFavoriteProfessor(String professorId) async {
    final currentUser = FirebaseService.getCurrentUser();
    if (currentUser == null) {
      throw Exception('Usuario no autenticado');
    }
    
    await FirebaseService.toggleFavorite(currentUser.uid, professorId);
  }
} 