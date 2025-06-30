import '../models/user.dart';
import 'mock_data_service.dart';

/// Servicio para manejar la sesión del usuario actual
class SessionService {
  static UserModel? _currentUser;
  
  /// Obtener el usuario actual
  static UserModel getCurrentUser() {
    return _currentUser ?? MockDataService.getAllUsers().first;
  }
  
  /// Establecer el usuario actual al hacer login
  static void setCurrentUser(UserModel user) {
    _currentUser = user;
  }
  
  /// Simular login con email
  static UserModel? loginWithEmail(String email) {
    final users = MockDataService.getAllUsers();
    try {
      final user = users.firstWhere((u) => u.email.toLowerCase() == email.toLowerCase());
      _currentUser = user;
      return user;
    } catch (e) {
      return null;
    }
  }
  
  /// Cerrar sesión
  static void logout() {
    _currentUser = null;
  }
  
  /// Verificar si hay usuario logueado
  static bool isLoggedIn() {
    return _currentUser != null;
  }
}
