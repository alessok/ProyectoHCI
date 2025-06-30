import '../models/review.dart';
import 'mock_data_service.dart';
import 'session_service.dart';

/// Servicio para manejar las reseñas de profesores
class ReviewService {
  
  /// Obtener reseñas de un profesor
  static List<Review> getProfessorReviews(String professorId) {
    return MockDataService.getReviewsForProfessor(professorId)
        .map((reviewData) => Review(
              id: reviewData['id'],
              userId: reviewData['userId'],
              userName: reviewData['userName'],
              userEmail: reviewData['userEmail'] ?? '',
              professorId: professorId,
              rating: (reviewData['rating'] ?? 0).toDouble(),
              comment: reviewData['comment'],
              course: reviewData['course'] ?? '',
              semester: reviewData['semester'] ?? '',
              createdAt: reviewData['createdAt'] as DateTime,
              updatedAt: reviewData['updatedAt'] as DateTime,
            ))
        .toList();
  }
  
  /// Crear una nueva reseña
  static void createReview({
    required String professorId,
    required double rating,
    required String comment,
    String? course,
    String? semester,
  }) {
    final currentUser = SessionService.getCurrentUser();
    
    MockDataService.addReviewToProfessor(
      professorId: professorId,
      userId: currentUser.id,
      userName: currentUser.name,
      rating: rating,
      comment: comment,
      course: course ?? 'Curso no especificado',
      semester: semester,
    );
  }
  
  /// Verificar si el usuario ya calificó al profesor
  static bool hasUserReviewedProfessor(String professorId) {
    final currentUser = SessionService.getCurrentUser();
    final reviews = getProfessorReviews(professorId);
    
    return reviews.any((review) => review.userId == currentUser.id);
  }
  
  /// Obtener reseñas del usuario actual
  static List<Review> getUserReviews() {
    final currentUser = SessionService.getCurrentUser();
    final allProfessors = MockDataService.getAllProfessors();
    final userReviews = <Review>[];
    
    for (final professor in allProfessors) {
      final reviews = getProfessorReviews(professor.id);
      userReviews.addAll(
        reviews.where((review) => review.userId == currentUser.id)
      );
    }
    // Ordenar por fecha y proteger contra nulls
    userReviews.sort((a, b) {
      final aDate = a.createdAt;
      final bDate = b.createdAt;
      return bDate.compareTo(aDate);
    });
    return userReviews;
  }
  
  /// Obtener reseñas por rating
  static List<Review> getReviewsByRating(double rating) {
    // Esta funcionalidad requeriría un índice compuesto en Firestore
    // Por ahora, obtenemos todas las reseñas y las filtramos
    final allProfessors = MockDataService.getAllProfessors();
    final allReviews = <Review>[];
    
    for (final professor in allProfessors) {
      final reviews = getProfessorReviews(professor.id);
      allReviews.addAll(reviews);
    }
    
    return allReviews.where((review) => review.rating == rating).toList();
  }
  
  /// Obtener reseñas recientes
  static List<Review> getRecentReviews({int limit = 10}) {
    final allProfessors = MockDataService.getAllProfessors();
    final allReviews = <Review>[];
    
    for (final professor in allProfessors) {
      final reviews = getProfessorReviews(professor.id);
      allReviews.addAll(reviews);
    }
    
    // Ordenar por fecha y limitar, protegiendo contra nulls
    allReviews.sort((a, b) {
      final aDate = a.createdAt;
      final bDate = b.createdAt;
      return bDate.compareTo(aDate);
    });
    return allReviews.take(limit).toList();
  }
  
  /// Obtener estadísticas de reseñas de un profesor
  static Map<String, dynamic> getProfessorReviewStats(String professorId) {
    final reviews = getProfessorReviews(professorId);
    
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
    
    final totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
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
      final ratingKey = review.rating.round().toString();
      ratingDistribution[ratingKey] = (ratingDistribution[ratingKey] ?? 0) + 1;
    }
    
    return {
      'averageRating': averageRating,
      'totalReviews': reviews.length,
      'ratingDistribution': ratingDistribution,
    };
  }
  
  /// Validar datos de reseña
  static String? validateReviewData({
    required double rating,
    required String comment,
  }) {
    if (rating < 1.0 || rating > 5.0) {
      return 'La calificación debe estar entre 1 y 5';
    }
    
    if (comment.trim().isEmpty) {
      return 'El comentario no puede estar vacío';
    }
    
    if (comment.trim().length < 10) {
      return 'El comentario debe tener al menos 10 caracteres';
    }
    
    if (comment.trim().length > 500) {
      return 'El comentario no puede exceder 500 caracteres';
    }
    
    return null;
  }
} 