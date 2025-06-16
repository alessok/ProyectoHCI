import 'package:flutter/material.dart';

/// Colores oficiales de la Universidad de Lima para la app
class AppColors {
  // Colores primarios de la Universidad de Lima
  static const Color primaryOrange = Color(0xFFFF8C00); // Naranja institucional
  static const Color primaryGold = Color(0xFFFFD700);   // Dorado
  
  // Variaciones del naranja
  static const Color lightOrange = Color(0xFFFFB347);
  static const Color darkOrange = Color(0xFFE67E22);
  
  // Colores neutros
  static const Color darkGray = Color(0xFF2C3E50);
  static const Color mediumGray = Color(0xFF7F8C8D);
  static const Color lightGray = Color(0xFFECF0F1);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  
  // Colores de estado
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color star = Color(0xFFFFD700); // Color dorado para estrellas
  
  // Colores de texto
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFFFFFFFF);
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryOrange, primaryGold],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundColor, lightGray],
  );
}
