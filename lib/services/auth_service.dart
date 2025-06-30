import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../core/exceptions/app_exceptions.dart';
import 'logger_service.dart';

/// Servicio de autenticación con Firebase y Google Sign-In
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Configuración específica para web
    clientId: '516580128918-a92eubd6a8hmqbpcde3mrbmdfo5ha5su.apps.googleusercontent.com',
  );
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Usuario actual de Firebase
  static User? get currentUser => _auth.currentUser;
  
  /// ID del usuario actual
  static String? get userId => _auth.currentUser?.uid;
  
  /// Verificar si el usuario está logueado
  static bool get isLoggedIn => _auth.currentUser != null;
  
  /// Stream de cambios de autenticación
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  /// Inicializar el servicio de autenticación
  static Future<void> initialize() async {
    try {
      LoggerService.info('Initializing AuthService', tag: 'AUTH');
      
      // Configurar Google Sign-In
      await _googleSignIn.signOut();
      
      LoggerService.info('AuthService initialized successfully', tag: 'AUTH');
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error initializing AuthService',
        tag: 'AUTH',
        data: e,
        stackTrace: stackTrace,
      );
      throw AuthenticationException(
        'Error al inicializar el servicio de autenticación',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Iniciar sesión con email y contraseña
  static Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final startTime = DateTime.now();
      
      LoggerService.auth('Sign in attempt', email: email);
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Crear o actualizar perfil de usuario en Firestore
      await _createOrUpdateUserProfile(credential.user!);
      
      final duration = DateTime.now().difference(startTime);
      LoggerService.performance('Email sign in', duration, tag: 'AUTH');
      LoggerService.auth('Sign in successful', userId: credential.user!.uid, email: email);
      
      return credential;
    } on FirebaseAuthException catch (e) {
      LoggerService.error(
        'Firebase Auth error during sign in',
        tag: 'AUTH',
        data: {'email': email, 'code': e.code, 'error': e},
      );
      throw _handleAuthError(e);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error during sign in',
        tag: 'AUTH',
        data: e,
        stackTrace: stackTrace,
      );
      throw AuthenticationException(
        'Error inesperado al iniciar sesión',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Registrar usuario con email y contraseña
  static Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final startTime = DateTime.now();
      LoggerService.auth('User registration attempt', email: email);
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw Exception('No se pudo crear el usuario. Intenta nuevamente.');
      }
      LoggerService.auth('User created in Firebase Auth', userId: user.uid);
      // Actualizar display name
      await user.updateDisplayName(name);
      LoggerService.auth('Display name updated', userId: user.uid);
      // Crear perfil de usuario en Firestore
      await _createOrUpdateUserProfile(user, name: name);
      LoggerService.auth('User profile created in Firestore', userId: user.uid);
      final duration = DateTime.now().difference(startTime);
      LoggerService.performance('User registration', duration, tag: 'AUTH');
      LoggerService.auth('User registration successful', userId: user.uid, email: email);
      return credential;
    } on FirebaseAuthException catch (e) {
      LoggerService.error(
        'Firebase Auth error during registration',
        tag: 'AUTH',
        data: {'email': email, 'code': e.code, 'error': e},
      );
      throw _handleAuthError(e);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error during registration',
        tag: 'AUTH',
        data: e,
        stackTrace: stackTrace,
      );
      throw AuthenticationException(
        'Error inesperado al registrar usuario',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Iniciar sesión con Google (método moderno para web)
  static Future<UserCredential> signInWithGoogle() async {
    try {
      final startTime = DateTime.now();
      LoggerService.auth('Google sign in attempt');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      if (googleUser == null) {
        final GoogleSignInAccount? newGoogleUser = await _googleSignIn.signIn();
        if (newGoogleUser == null) {
          throw AuthenticationException('Inicio de sesión cancelado por el usuario');
        }
      }
      final GoogleSignInAccount? currentGoogleUser = _googleSignIn.currentUser;
      if (currentGoogleUser == null) {
        throw AuthenticationException('No se pudo obtener la cuenta de Google');
      }
      final GoogleSignInAuthentication googleAuth = await currentGoogleUser.authentication;
      if (googleAuth.accessToken == null) {
        throw AuthenticationException('No se pudo obtener el token de acceso de Google');
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw AuthenticationException('No se pudo obtener el usuario de Google');
      }
      await _createOrUpdateUserProfile(
        user,
        name: currentGoogleUser.displayName,
        email: currentGoogleUser.email,
        photoUrl: currentGoogleUser.photoUrl,
      );
      final duration = DateTime.now().difference(startTime);
      LoggerService.performance('Google sign in', duration, tag: 'AUTH');
      LoggerService.auth(
        'Google sign in successful',
        userId: user.uid,
        email: currentGoogleUser.email,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      LoggerService.error(
        'Firebase Auth error during Google sign in',
        tag: 'AUTH',
        data: {'code': e.code, 'error': e},
      );
      throw _handleAuthError(e);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error during Google sign in',
        tag: 'AUTH',
        data: e,
        stackTrace: stackTrace,
      );
      throw AuthenticationException(
        'Error inesperado al iniciar sesión con Google',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Cerrar sesión
  static Future<void> signOut() async {
    try {
      final startTime = DateTime.now();
      
      LoggerService.auth('Sign out attempt', userId: _auth.currentUser?.uid);
      
      // Verificar si hay usuario actual
      if (_auth.currentUser != null) {
        LoggerService.auth('Current user found', userId: _auth.currentUser!.uid);
      } else {
        LoggerService.auth('No authenticated user found');
      }
      
      // Cerrar sesión de Firebase Auth
      await _auth.signOut();
      LoggerService.auth('Firebase Auth sign out completed');
      
      // Cerrar sesión de Google Sign-In
      await _googleSignIn.signOut();
      LoggerService.auth('Google Sign-In sign out completed');
      
      // Verificar que el logout fue exitoso
      if (_auth.currentUser == null) {
        LoggerService.auth('Sign out successful - No authenticated user');
      } else {
        LoggerService.warning('User still authenticated after sign out', tag: 'AUTH');
      }
      
      final duration = DateTime.now().difference(startTime);
      LoggerService.performance('Sign out', duration, tag: 'AUTH');
      
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error during sign out',
        tag: 'AUTH',
        data: e,
        stackTrace: stackTrace,
      );
      throw AuthenticationException(
        'Error al cerrar sesión',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Obtener datos del usuario desde Firestore
  static Future<UserModel?> getUserData() async {
    if (!isLoggedIn) {
      LoggerService.warning('Attempted to get user data without authentication', tag: 'AUTH');
      return null;
    }
    
    try {
      final startTime = DateTime.now();
      
      LoggerService.auth('Getting user data', userId: _auth.currentUser!.uid);
      
      final doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      
      if (doc.exists) {
        final duration = DateTime.now().difference(startTime);
        LoggerService.performance('Get user data', duration, tag: 'AUTH');
        LoggerService.auth('User data retrieved successfully', userId: _auth.currentUser!.uid);
        return UserModel.fromFirestore(doc);
      }
      
      LoggerService.warning('User document not found', tag: 'AUTH', data: {'userId': _auth.currentUser!.uid});
      return null;
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error getting user data',
        tag: 'AUTH',
        data: e,
        stackTrace: stackTrace,
      );
      throw AuthenticationException(
        'Error al obtener datos del usuario',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Crear o actualizar perfil de usuario en Firestore
  static Future<void> _createOrUpdateUserProfile(
    User firebaseUser, {
    String? name,
    String? email,
    String? photoUrl,
  }) async {
    try {
      LoggerService.auth('Creating/updating user profile', userId: firebaseUser.uid);
      
      final userData = {
        'id': firebaseUser.uid,
        'name': name ?? firebaseUser.displayName ?? 'Usuario',
        'email': email ?? firebaseUser.email ?? '',
        'photoUrl': photoUrl ?? firebaseUser.photoURL,
        'createdAt': firebaseUser.metadata.creationTime ?? DateTime.now(),
        'lastLoginAt': DateTime.now(),
        'isEmailVerified': firebaseUser.emailVerified,
      };
      
      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(userData, SetOptions(merge: true));
          
      LoggerService.auth('User profile created/updated successfully', userId: firebaseUser.uid);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error creating/updating user profile',
        tag: 'AUTH',
        data: e,
        stackTrace: stackTrace,
      );
      throw AuthenticationException(
        'Error al crear perfil de usuario',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Enviar email de verificación
  static Future<void> sendEmailVerification() async {
    if (!isLoggedIn) {
      LoggerService.warning('Attempted to send email verification without authentication', tag: 'AUTH');
      throw AuthenticationException('Usuario no autenticado');
    }
    
    try {
      LoggerService.auth('Sending email verification', userId: _auth.currentUser!.uid);
      
      await _auth.currentUser!.sendEmailVerification();
      
      LoggerService.auth('Email verification sent successfully', userId: _auth.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      LoggerService.error(
        'Firebase Auth error sending email verification',
        tag: 'AUTH',
        data: {'code': e.code, 'error': e},
      );
      throw AuthenticationException(_handleAuthError(e));
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error sending email verification',
        tag: 'AUTH',
        data: e,
        stackTrace: stackTrace,
      );
      throw AuthenticationException(
        'Error inesperado al enviar email de verificación',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Restablecer contraseña
  static Future<void> resetPassword(String email) async {
    try {
      LoggerService.auth('Password reset requested', email: email);
      
      await _auth.sendPasswordResetEmail(email: email);
      
      LoggerService.auth('Password reset email sent successfully', email: email);
    } on FirebaseAuthException catch (e) {
      LoggerService.error(
        'Firebase Auth error sending password reset',
        tag: 'AUTH',
        data: {'email': email, 'code': e.code, 'error': e},
      );
      throw AuthenticationException(_handleAuthError(e));
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error sending password reset',
        tag: 'AUTH',
        data: e,
        stackTrace: stackTrace,
      );
      throw AuthenticationException(
        'Error inesperado al restablecer contraseña',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Actualizar perfil del usuario
  static Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    if (!isLoggedIn) {
      LoggerService.warning('Attempted to update profile without authentication', tag: 'AUTH');
      throw AuthenticationException('Usuario no autenticado');
    }
    
    try {
      LoggerService.auth('Updating user profile', userId: _auth.currentUser!.uid);
      
      await _auth.currentUser!.updateDisplayName(displayName);
      if (photoURL != null) {
        await _auth.currentUser!.updatePhotoURL(photoURL);
      }
      
      // Actualizar en Firestore
      await _createOrUpdateUserProfile(_auth.currentUser!);
      
      LoggerService.auth('User profile updated successfully', userId: _auth.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      LoggerService.error(
        'Firebase Auth error updating profile',
        tag: 'AUTH',
        data: {'code': e.code, 'error': e},
      );
      throw AuthenticationException(_handleAuthError(e));
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error updating profile',
        tag: 'AUTH',
        data: e,
        stackTrace: stackTrace,
      );
      throw AuthenticationException(
        'Error inesperado al actualizar perfil',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// Manejar errores de autenticación
  static String _handleAuthError(FirebaseAuthException e) {
    LoggerService.error(
      'Firebase Auth error handled',
      tag: 'AUTH',
      data: {'code': e.code, 'message': e.message, 'error': e},
    );
    
    switch (e.code) {
      case 'user-not-found':
        return 'No se encontró una cuenta con este email';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'Este email ya está registrado';
      case 'weak-password':
        return 'La contraseña es muy débil (mínimo 6 caracteres)';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Intenta más tarde';
      case 'operation-not-allowed':
        return 'Esta operación no está permitida';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu internet';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
} 