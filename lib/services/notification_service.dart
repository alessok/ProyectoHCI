import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Servicio para manejar notificaciones en la aplicación
class NotificationService {
  static final GlobalKey<ScaffoldMessengerState> _messengerKey = 
      GlobalKey<ScaffoldMessengerState>();
  
  /// Obtener la clave del messenger para mostrar SnackBars
  static GlobalKey<ScaffoldMessengerState> get messengerKey => _messengerKey;
  
  /// Mostrar notificación de éxito
  static void showSuccess(String message, {Duration? duration}) {
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
  
  /// Mostrar notificación de error
  static void showError(String message, {Duration? duration}) {
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: duration ?? const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
  
  /// Mostrar notificación de información
  static void showInfo(String message, {Duration? duration}) {
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.primaryOrange,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
  
  /// Mostrar notificación de carga
  static void showLoading(String message) {
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.primaryOrange,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
  
  /// Ocultar todas las notificaciones
  static void hideAll() {
    _messengerKey.currentState?.hideCurrentSnackBar();
  }
} 