import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Pantalla principal (Home) - Versión simplificada para testing
class HomeScreenSimple extends StatelessWidget {
  const HomeScreenSimple({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Home - RankedYourProf UL'),
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: AppColors.textLight,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 100,
              color: AppColors.primaryOrange,
            ),
            SizedBox(height: 20),
            Text(
              '¡Bienvenido a RankedYourProf UL!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Pantalla Home en desarrollo...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
