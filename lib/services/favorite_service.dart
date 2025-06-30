import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/professor.dart';
import 'notification_service.dart';

/// Servicio para manejar favoritos de profesores con Firebase
class FavoriteService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  /// Agregar profesor a favoritos
  static Future<void> addToFavorites(String professorId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }
      
      // Verificar si ya está en favoritos
      final existingDoc = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .where('professorId', isEqualTo: professorId)
          .limit(1)
          .get();
      
      if (existingDoc.docs.isNotEmpty) {
        NotificationService.showInfo('Este profesor ya está en tus favoritos');
        return;
      }
      
      // Agregar a favoritos
      await _firestore.collection('favorites').add({
        'userId': user.uid,
        'professorId': professorId,
        'addedAt': FieldValue.serverTimestamp(),
      });
      
      NotificationService.showSuccess('Profesor agregado a favoritos');
    } catch (e) {
      NotificationService.showError('Error al agregar a favoritos: $e');
      throw Exception('Error al agregar a favoritos: $e');
    }
  }
  
  /// Remover profesor de favoritos
  static Future<void> removeFromFavorites(String professorId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }
      
      // Buscar y eliminar el documento de favorito
      final doc = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .where('professorId', isEqualTo: professorId)
          .limit(1)
          .get();
      
      if (doc.docs.isNotEmpty) {
        await doc.docs.first.reference.delete();
        NotificationService.showSuccess('Profesor removido de favoritos');
      }
    } catch (e) {
      NotificationService.showError('Error al remover de favoritos: $e');
      throw Exception('Error al remover de favoritos: $e');
    }
  }
  
  /// Verificar si un profesor está en favoritos
  static Future<bool> isFavorite(String professorId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return false;
      }
      
      final doc = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .where('professorId', isEqualTo: professorId)
          .limit(1)
          .get();
      
      return doc.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  /// Obtener lista de profesores favoritos
  static Future<List<String>> getFavoriteProfessorIds() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return [];
      }
      
      final snapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .orderBy('addedAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) => doc.data()['professorId'] as String).toList();
    } catch (e) {
      NotificationService.showError('Error al cargar favoritos: $e');
      return [];
    }
  }
  
  /// Obtener profesores favoritos completos
  static Future<List<Professor>> getFavoriteProfessors(List<Professor> allProfessors) async {
    try {
      final favoriteIds = await getFavoriteProfessorIds();
      return allProfessors.where((professor) => favoriteIds.contains(professor.id)).toList();
    } catch (e) {
      NotificationService.showError('Error al cargar profesores favoritos: $e');
      return [];
    }
  }
  
  /// Obtener estadísticas de favoritos
  static Future<Map<String, dynamic>> getFavoriteStats() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return {
          'totalFavorites': 0,
          'recentFavorites': 0,
        };
      }
      
      final snapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .get();
      
      final totalFavorites = snapshot.docs.length;
      
      // Contar favoritos recientes (últimos 30 días)
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final recentFavorites = snapshot.docs.where((doc) {
        final addedAt = (doc.data()['addedAt'] as Timestamp?)?.toDate();
        return addedAt != null && addedAt.isAfter(thirtyDaysAgo);
      }).length;
      
      return {
        'totalFavorites': totalFavorites,
        'recentFavorites': recentFavorites,
      };
    } catch (e) {
      return {
        'totalFavorites': 0,
        'recentFavorites': 0,
      };
    }
  }
  
  /// Limpiar todos los favoritos del usuario
  static Future<void> clearAllFavorites() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }
      
      final snapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .get();
      
      // Eliminar todos los documentos en lotes
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      
      NotificationService.showSuccess('Todos los favoritos han sido eliminados');
    } catch (e) {
      NotificationService.showError('Error al limpiar favoritos: $e');
      throw Exception('Error al limpiar favoritos: $e');
    }
  }
  
  /// Obtener profesores más favoritos (estadísticas globales)
  static Future<List<Map<String, dynamic>>> getMostFavoritedProfessors() async {
    try {
      final snapshot = await _firestore
          .collection('favorites')
          .get();
      
      // Contar favoritos por profesor
      final Map<String, int> professorCounts = {};
      for (final doc in snapshot.docs) {
        final professorId = doc.data()['professorId'] as String;
        professorCounts[professorId] = (professorCounts[professorId] ?? 0) + 1;
      }
      
      // Ordenar por cantidad de favoritos
      final sortedProfessors = professorCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      return sortedProfessors.take(10).map((entry) => {
        'professorId': entry.key,
        'favoriteCount': entry.value,
      }).toList();
    } catch (e) {
      return [];
    }
  }
} 