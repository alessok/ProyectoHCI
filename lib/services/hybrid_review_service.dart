import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/review.dart';
import 'notification_service.dart';

/// Servicio híbrido para manejar reviews con Firebase
class HybridReviewService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  /// Crear una nueva review
  static Future<void> createReview({
    required String professorId,
    required double rating,
    required String comment,
    required String course,
    String? semester,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }
      
      // Crear el documento de review
      final reviewData = {
        'id': '', // Se generará automáticamente
        'professorId': professorId,
        'userId': user.uid,
        'userName': user.displayName ?? 'Usuario',
        'userEmail': user.email ?? '',
        'rating': rating,
        'comment': comment,
        'course': course,
        'semester': semester ?? 'No especificado',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'likes': 0,
        'dislikes': 0,
      };
      
      // Agregar a Firestore
      final docRef = await _firestore.collection('reviews').add(reviewData);
      
      // Actualizar el ID del documento
      await docRef.update({'id': docRef.id});
      
      NotificationService.showSuccess('Review creada exitosamente');
    } catch (e) {
      NotificationService.showError('Error al crear review: $e');
      throw Exception('Error al crear review: $e');
    }
  }
  
  /// Obtener reviews de un profesor
  static Future<List<Review>> getProfessorReviews(String professorId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('professorId', isEqualTo: professorId)
          .orderBy('createdAt', descending: true)
          .get();
      final reviews = snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
      // Ordenar por fecha y proteger contra nulls
      reviews.sort((a, b) {
        final aDate = a.createdAt;
        final bDate = b.createdAt;
        return bDate.compareTo(aDate);
      });
      return reviews;
    } catch (e) {
      NotificationService.showError('Error al cargar reviews: $e');
      return [];
    }
  }
  
  /// Obtener reviews del usuario actual
  static Future<List<Review>> getUserReviews() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return [];
      }
      final snapshot = await _firestore
          .collection('reviews')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();
      final reviews = snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
      // Ordenar por fecha y proteger contra nulls
      reviews.sort((a, b) {
        final aDate = a.createdAt;
        final bDate = b.createdAt;
        return bDate.compareTo(aDate);
      });
      return reviews;
    } catch (e) {
      NotificationService.showError('Error al cargar tus reviews: $e');
      return [];
    }
  }
  
  /// Actualizar una review
  static Future<void> updateReview({
    required String reviewId,
    required double rating,
    required String comment,
    required String course,
    String? semester,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }
      
      // Verificar que la review pertenece al usuario
      final doc = await _firestore.collection('reviews').doc(reviewId).get();
      if (!doc.exists) {
        throw Exception('Review no encontrada');
      }
      
      if (doc.data()!['userId'] != user.uid) {
        throw Exception('No tienes permisos para editar esta review');
      }
      
      // Actualizar la review
      await _firestore.collection('reviews').doc(reviewId).update({
        'rating': rating,
        'comment': comment,
        'course': course,
        'semester': semester ?? 'No especificado',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      NotificationService.showSuccess('Review actualizada exitosamente');
    } catch (e) {
      NotificationService.showError('Error al actualizar review: $e');
      throw Exception('Error al actualizar review: $e');
    }
  }
  
  /// Eliminar una review
  static Future<void> deleteReview(String reviewId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }
      
      // Verificar que la review pertenece al usuario
      final doc = await _firestore.collection('reviews').doc(reviewId).get();
      if (!doc.exists) {
        throw Exception('Review no encontrada');
      }
      
      if (doc.data()!['userId'] != user.uid) {
        throw Exception('No tienes permisos para eliminar esta review');
      }
      
      // Eliminar la review
      await _firestore.collection('reviews').doc(reviewId).delete();
      
      NotificationService.showSuccess('Review eliminada exitosamente');
    } catch (e) {
      NotificationService.showError('Error al eliminar review: $e');
      throw Exception('Error al eliminar review: $e');
    }
  }
  
  /// Obtener estadísticas de reviews de un profesor
  static Future<Map<String, dynamic>> getProfessorStats(String professorId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('professorId', isEqualTo: professorId)
          .get();
      
      if (snapshot.docs.isEmpty) {
        return {
          'totalReviews': 0,
          'averageRating': 0.0,
          'ratingDistribution': {},
        };
      }
      
      final reviews = snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
      final totalReviews = reviews.length;
      final averageRating = reviews.map((r) => r.rating).reduce((a, b) => a + b) / totalReviews;
      
      // Calcular distribución de ratings
      final ratingDistribution = <int, int>{};
      for (int i = 1; i <= 5; i++) {
        ratingDistribution[i] = reviews.where((r) => r.rating == i.toDouble()).length;
      }
      
      return {
        'totalReviews': totalReviews,
        'averageRating': averageRating,
        'ratingDistribution': ratingDistribution,
      };
    } catch (e) {
      NotificationService.showError('Error al cargar estadísticas: $e');
      return {
        'totalReviews': 0,
        'averageRating': 0.0,
        'ratingDistribution': {},
      };
    }
  }
  
  /// Verificar si el usuario ya ha hecho review a un profesor
  static Future<bool> hasUserReviewedProfessor(String professorId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return false;
      }
      
      final snapshot = await _firestore
          .collection('reviews')
          .where('professorId', isEqualTo: professorId)
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();
      
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  /// Obtener la review del usuario para un profesor específico
  static Future<Review?> getUserReviewForProfessor(String professorId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return null;
      }
      
      final snapshot = await _firestore
          .collection('reviews')
          .where('professorId', isEqualTo: professorId)
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        return Review.fromFirestore(snapshot.docs.first);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
} 