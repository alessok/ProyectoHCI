import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/professor.dart';
import '../models/review.dart';
import 'mock_data_service.dart';
import 'firebase_service.dart';
import 'auth_service.dart';
import 'logger_service.dart';

/// Servicio híbrido que combina datos mock existentes con Firebase
/// Mantiene los datos reales de la universidad pero usa Firebase para autenticación y reseñas
class HybridDataService {
  
  // ==================== PROFESORES (Datos Mock) ====================
  
  /// Obtener todos los profesores (desde datos mock)
  static Future<List<Professor>> getAllProfessors() async {
    // Usar datos mock existentes
    return MockDataService.getAllProfessors();
  }
  
  /// Obtener profesor por ID (desde datos mock)
  static Future<Professor?> getProfessorById(String id) async {
    return MockDataService.getProfessorById(id);
  }
  
  /// Buscar profesores (desde datos mock)
  static Future<List<Professor>> searchProfessors(String query) async {
    return MockDataService.searchProfessors(query);
  }
  
  /// Obtener profesores por departamento (desde datos mock)
  static Future<List<Professor>> getProfessorsByDepartment(String department) async {
    return MockDataService.getProfessorsByDepartment(department);
  }
  
  /// Obtener top profesores (desde datos mock)
  static Future<List<Professor>> getTopProfessors({int limit = 5}) async {
    return MockDataService.getTopProfessors(limit: limit);
  }
  
  /// Obtener todos los departamentos (desde datos mock)
  static Future<List<String>> getAllDepartments() async {
    return MockDataService.getAllDepartments();
  }
  
  // ==================== RESEÑAS (Híbrido: Mock + Firebase) ====================
  
  /// Obtener reseñas de un profesor (combinar mock + Firebase)
  static Future<List<Review>> getProfessorReviews(String professorId) async {
    final allReviews = <Review>[];
    
    // 1. Obtener reseñas mock
    final mockReviewsData = MockDataService.getReviewsForProfessor(professorId);
    for (final reviewData in mockReviewsData) {
      allReviews.add(Review(
        id: reviewData['id'],
        userId: reviewData['userId'],
        userName: reviewData['userName'],
        userEmail: reviewData['userEmail'] ?? '',
        professorId: professorId,
        rating: (reviewData['rating'] ?? 0).toDouble(),
        comment: reviewData['comment'],
        course: reviewData['course'] ?? '',
        semester: reviewData['semester'] ?? '',
        createdAt: reviewData['createdAt'] ?? DateTime.now(),
        updatedAt: reviewData['updatedAt'] ?? DateTime.now(),
      ));
    }
    
    // 2. Obtener reseñas de Firebase (si hay usuario autenticado)
    if (AuthService.isLoggedIn) {
      try {
        final firebaseReviews = await FirebaseService.getProfessorReviews(professorId);
        allReviews.addAll(firebaseReviews);
      } catch (e) {
        // Si hay error con Firebase, continuar solo con datos mock
        LoggerService.warning('Error obteniendo reseñas de Firebase: $e');
      }
    }
    
    // 3. Ordenar por fecha (más recientes primero)
    allReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return allReviews;
  }
  
  /// Crear nueva reseña (solo en Firebase)
  static Future<void> createReview({
    required String professorId,
    required double rating,
    required String comment,
    required String course,
    String? semester,
  }) async {
    // Verificar que el usuario esté autenticado
    if (!AuthService.isLoggedIn) {
      throw Exception('Debes iniciar sesión para crear una reseña');
    }
    
    // Verificar que no haya calificado antes
    final hasReviewed = await hasUserReviewedProfessor(professorId);
    if (hasReviewed) {
      throw Exception('Ya has calificado a este profesor');
    }
    
    // Crear la reseña en Firebase
    await FirebaseService.createReview(Review(
      id: '', // Se generará automáticamente
      userId: AuthService.userId!,
      userName: (await AuthService.getUserData())?.name ?? 'Usuario',
      userEmail: AuthService.currentUser?.email ?? '',
      professorId: professorId,
      rating: rating,
      comment: comment.trim(),
      course: course,
      semester: semester ?? '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
  }
  
  /// Verificar si el usuario ya calificó al profesor
  static Future<bool> hasUserReviewedProfessor(String professorId) async {
    if (!AuthService.isLoggedIn) return false;
    
    // Verificar en reseñas mock (por email)
    final currentUser = AuthService.currentUser;
    if (currentUser != null) {
      final mockReviewsData = MockDataService.getReviewsForProfessor(professorId);
      final hasMockReview = mockReviewsData.any((review) => 
        review['userName'] == currentUser.email?.split('@').first
      );
      if (hasMockReview) return true;
    }
    
    // Verificar en Firebase
    try {
      return await FirebaseService.hasUserReviewedProfessor(
        AuthService.userId!, 
        professorId
      );
    } catch (e) {
      return false;
    }
  }
  
  /// Obtener reseñas del usuario actual
  static Future<List<Review>> getUserReviews() async {
    if (!AuthService.isLoggedIn) return [];
    
    try {
      return await FirebaseService.getUserReviews(AuthService.userId!);
    } catch (e) {
      return [];
    }
  }
  
  // ==================== FAVORITOS (Firebase) ====================
  
  /// Obtener profesores favoritos del usuario
  static Future<List<Professor>> getFavoriteProfessors({int limit = 5}) async {
    if (!AuthService.isLoggedIn) {
      // Si no hay usuario autenticado, usar favoritos mock
      return MockDataService.getFavoriteProfessors(limit: limit);
    }
    
    try {
      final favoriteIds = await FirebaseService.getUserFavorites(AuthService.userId!);
      if (favoriteIds.isEmpty) return [];
      
      final allProfessors = await getAllProfessors();
      final favoriteProfessors = allProfessors
          .where((professor) => favoriteIds.contains(professor.id))
          .toList();
      
      // Ordenar por rating y limitar
      favoriteProfessors.sort((a, b) => b.averageRating.compareTo(a.averageRating));
      return favoriteProfessors.take(limit).toList();
    } catch (e) {
      // Si hay error, usar favoritos mock
      return MockDataService.getFavoriteProfessors(limit: limit);
    }
  }
  
  /// Verificar si un profesor está en favoritos
  static Future<bool> isFavoriteProfessor(String professorId) async {
    if (!AuthService.isLoggedIn) {
      // Si no hay usuario autenticado, usar favoritos mock
      return MockDataService.isFavoriteProfessor(professorId);
    }
    
    try {
      return await FirebaseService.isFavorite(AuthService.userId!, professorId);
    } catch (e) {
      return MockDataService.isFavoriteProfessor(professorId);
    }
  }
  
  /// Agregar/quitar profesor de favoritos
  static Future<void> toggleFavoriteProfessor(String professorId) async {
    if (!AuthService.isLoggedIn) {
      throw Exception('Debes iniciar sesión para gestionar favoritos');
    }
    
    await FirebaseService.toggleFavorite(AuthService.userId!, professorId);
  }
  
  // ==================== ESTADÍSTICAS (Híbrido) ====================
  
  /// Obtener estadísticas de reseñas de un profesor
  static Future<Map<String, dynamic>> getProfessorReviewStats(String professorId) async {
    final reviews = await getProfessorReviews(professorId);
    
    if (reviews.isEmpty) {
      return {
        'averageRating': 0.0,
        'totalReviews': 0,
        'ratingDistribution': {
          '5': 0,
          '4': 0,
          '3': 0,
          '2': 0,
          '1': 0,
        },
      };
    }
    
    final totalRating = reviews.fold(0.0, (total, review) => total + review.rating);
    final averageRating = totalRating / reviews.length;
    
    // Calcular distribución de ratings
    final ratingDistribution = <String, int>{
      '5': 0,
      '4': 0,
      '3': 0,
      '2': 0,
      '1': 0,
    };
    
    for (final review in reviews) {
      ratingDistribution[review.ratingAsInt.toString()] = 
          (ratingDistribution[review.ratingAsInt.toString()] ?? 0) + 1;
    }
    
    return {
      'averageRating': averageRating,
      'totalReviews': reviews.length,
      'ratingDistribution': ratingDistribution,
    };
  }
  
  /// Obtener distribución de ratings (combinar mock + Firebase)
  static Future<Map<int, int>> getRatingDistribution(String professorId) async {
    // Usar distribución mock como base
    final mockDistribution = MockDataService.getRatingDistribution(professorId);
    
    // Si hay usuario autenticado, agregar reseñas de Firebase
    if (AuthService.isLoggedIn) {
      try {
        final firebaseReviews = await FirebaseService.getProfessorReviews(professorId);
        for (final review in firebaseReviews) {
          mockDistribution[review.ratingAsInt] = (mockDistribution[review.ratingAsInt] ?? 0) + 1;
        }
      } catch (e) {
        // Si hay error, continuar solo con datos mock
      }
    }
    
    return mockDistribution;
  }
  
  // ==================== MIGRACIÓN DE DATOS ====================
  
  /// Migrar datos mock a Firebase (para uso futuro)
  static Future<void> migrateMockDataToFirebase() async {
    try {
      // Migrar profesores
      final professors = MockDataService.getAllProfessors();
      for (final professor in professors) {
        // Agregar searchKeywords para búsqueda
        final searchKeywords = _generateSearchKeywords(professor);
        final professorWithKeywords = professor.copyWith(
          searchKeywords: searchKeywords,
        );
        
        // Crear en Firebase (solo si no existe)
        final existing = await FirebaseFirestore.instance
            .collection('professors')
            .doc(professor.id)
            .get();
        if (!existing.exists) {
          await FirebaseFirestore.instance
              .collection('professors')
              .doc(professor.id)
              .set(professorWithKeywords.toFirestore());
        }
      }
      
      // Migrar departamentos
      final departments = MockDataService.getAllDepartments()
          .where((dept) => dept != 'All')
          .toList();
      
      for (final department in departments) {
        await FirebaseFirestore.instance
            .collection('departments')
            .add({
          'name': department,
          'createdAt': DateTime.now(),
        });
      }
      
      LoggerService.info('Migración de datos completada exitosamente');
    } catch (e) {
      LoggerService.error('Error en migración: $e');
    }
  }
  
  /// Generar keywords de búsqueda para un profesor
  static List<String> _generateSearchKeywords(Professor professor) {
    final keywords = <String>[];
    
    // Agregar nombre en diferentes formatos
    final nameParts = professor.name.toLowerCase().split(' ');
    keywords.addAll(nameParts);
    keywords.add(professor.name.toLowerCase());
    
    // Agregar departamento
    keywords.add(professor.department.toLowerCase());
    
    // Agregar cursos
    for (final course in professor.courses) {
      final courseParts = course.toLowerCase().split(' ');
      keywords.addAll(courseParts);
      keywords.add(course.toLowerCase());
    }
    
    // Agregar bio si existe
    if (professor.bio != null) {
      final bioParts = professor.bio!.toLowerCase().split(' ');
      keywords.addAll(bioParts.take(10)); // Solo las primeras 10 palabras
    }
    
    return keywords.toSet().toList(); // Eliminar duplicados
  }
} 