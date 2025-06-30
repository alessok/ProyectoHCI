import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/professor.dart';
import '../models/review.dart';
import '../firebase_options.dart';

/// Servicio para manejar todas las operaciones de Firebase
class FirebaseService {
  static FirebaseAuth get _auth => FirebaseAuth.instance;
  static FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  
  /// Inicializar Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  
  // ==================== AUTENTICACIÓN ====================
  
  /// Registrar usuario con email y contraseña
  static Future<UserCredential> registerWithEmailAndPassword(
    String email, 
    String password, 
    String name
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw Exception('No se pudo obtener el usuario después del registro');
      }
      // Crear documento de usuario en Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'isVerified': false,
      });
      return credential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
  
  /// Iniciar sesión con email y contraseña
  static Future<UserCredential> signInWithEmailAndPassword(
    String email, 
    String password
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
  
  /// Cerrar sesión
  static Future<void> signOut() async {
    await _auth.signOut();
  }
  
  /// Obtener usuario actual
  static User? getCurrentUser() {
    return _auth.currentUser;
  }
  
  /// Verificar si hay usuario logueado
  static bool isLoggedIn() {
    return _auth.currentUser != null;
  }
  
  /// Enviar email de verificación
  static Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }
  
  /// Restablecer contraseña
  static Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
  
  // ==================== USUARIOS ====================
  
  /// Obtener datos del usuario desde Firestore
  static Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener datos del usuario: $e');
    }
  }
  
  /// Actualizar datos del usuario
  static Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }
  
  // ==================== PROFESORES ====================
  
  /// Obtener todos los profesores
  static Future<List<Professor>> getAllProfessors() async {
    try {
      final snapshot = await _firestore.collection('professors').get();
      return snapshot.docs.map((doc) => Professor.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error al obtener profesores: $e');
    }
  }
  
  /// Obtener profesor por ID
  static Future<Professor?> getProfessorById(String id) async {
    try {
      final doc = await _firestore.collection('professors').doc(id).get();
      if (doc.exists) {
        return Professor.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener profesor: $e');
    }
  }
  
  /// Buscar profesores
  static Future<List<Professor>> searchProfessors(String query) async {
    try {
      final snapshot = await _firestore
          .collection('professors')
          .where('searchKeywords', arrayContains: query.toLowerCase())
          .get();
      return snapshot.docs.map((doc) => Professor.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error al buscar profesores: $e');
    }
  }
  
  /// Obtener profesores por departamento
  static Future<List<Professor>> getProfessorsByDepartment(String department) async {
    try {
      final snapshot = await _firestore
          .collection('professors')
          .where('department', isEqualTo: department)
          .get();
      return snapshot.docs.map((doc) => Professor.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error al obtener profesores por departamento: $e');
    }
  }
  
  /// Obtener top profesores
  static Future<List<Professor>> getTopProfessors({int limit = 5}) async {
    try {
      final snapshot = await _firestore
          .collection('professors')
          .orderBy('averageRating', descending: true)
          .orderBy('totalReviews', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs.map((doc) => Professor.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error al obtener top profesores: $e');
    }
  }
  
  /// Obtener todos los departamentos
  static Future<List<String>> getAllDepartments() async {
    try {
      final snapshot = await _firestore.collection('departments').get();
      return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    } catch (e) {
      throw Exception('Error al obtener departamentos: $e');
    }
  }
  
  // ==================== RESEÑAS ====================
  
  /// Crear nueva reseña
  static Future<void> createReview(Review review) async {
    try {
      final reviewData = review.toFirestore();
      await _firestore.collection('reviews').add(reviewData);
      
      // Actualizar estadísticas del profesor
      await _updateProfessorStats(review.professorId);
    } catch (e) {
      throw Exception('Error al crear reseña: $e');
    }
  }
  
  /// Obtener reseñas de un profesor
  static Future<List<Review>> getProfessorReviews(String professorId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('professorId', isEqualTo: professorId)
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error al obtener reseñas: $e');
    }
  }
  
  /// Obtener reseñas del usuario actual
  static Future<List<Review>> getUserReviews(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error al obtener reseñas del usuario: $e');
    }
  }
  
  /// Verificar si el usuario ya calificó al profesor
  static Future<bool> hasUserReviewedProfessor(String userId, String professorId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .where('professorId', isEqualTo: professorId)
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Error al verificar reseña: $e');
    }
  }
  
  // ==================== FAVORITOS ====================
  
  /// Obtener profesores favoritos del usuario
  static Future<List<String>> getUserFavorites(String userId) async {
    try {
      final doc = await _firestore.collection('userFavorites').doc(userId).get();
      if (doc.exists) {
        return List<String>.from(doc.data()?['favorites'] ?? []);
      }
      return [];
    } catch (e) {
      throw Exception('Error al obtener favoritos: $e');
    }
  }
  
  /// Agregar/quitar profesor de favoritos
  static Future<void> toggleFavorite(String userId, String professorId) async {
    try {
      final docRef = _firestore.collection('userFavorites').doc(userId);
      final doc = await docRef.get();
      
      if (doc.exists) {
        final favorites = List<String>.from(doc.data()?['favorites'] ?? []);
        if (favorites.contains(professorId)) {
          favorites.remove(professorId);
        } else {
          favorites.add(professorId);
        }
        await docRef.update({'favorites': favorites});
      } else {
        await docRef.set({'favorites': [professorId]});
      }
    } catch (e) {
      throw Exception('Error al actualizar favoritos: $e');
    }
  }
  
  /// Verificar si un profesor está en favoritos
  static Future<bool> isFavorite(String userId, String professorId) async {
    try {
      final favorites = await getUserFavorites(userId);
      return favorites.contains(professorId);
    } catch (e) {
      throw Exception('Error al verificar favorito: $e');
    }
  }
  
  // ==================== MÉTODOS PRIVADOS ====================
  
  /// Actualizar estadísticas del profesor
  static Future<void> _updateProfessorStats(String professorId) async {
    try {
      final reviews = await getProfessorReviews(professorId);
      if (reviews.isEmpty) return;
      
      final totalRating = reviews.fold(0.0, (total, review) => total + review.rating);
      final averageRating = totalRating / reviews.length;
      
      await _firestore.collection('professors').doc(professorId).update({
        'averageRating': averageRating,
        'totalReviews': reviews.length,
      });
    } catch (e) {
      throw Exception('Error al actualizar estadísticas: $e');
    }
  }
  
  /// Manejar errores de autenticación
  static String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No se encontró una cuenta con este email';
        case 'wrong-password':
          return 'Contraseña incorrecta';
        case 'email-already-in-use':
          return 'Este email ya está registrado';
        case 'weak-password':
          return 'La contraseña es muy débil';
        case 'invalid-email':
          return 'Email inválido';
        default:
          return 'Error de autenticación: ${error.message}';
      }
    }
    return 'Error inesperado: $error';
  }
} 