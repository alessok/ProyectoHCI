import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/custom_button.dart';

class RatingCompletedScreen extends StatelessWidget {
  const RatingCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.school,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'RankedYourProf ULima',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false, // Remove back button
        elevation: 0,
      ),
      backgroundColor: AppColors.lightGray,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Icono de medalla/premio centrado
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryOrange,
                    width: 4,
                  ),
                ),
                child: Icon(
                  Icons.emoji_events_outlined,
                  size: 60,
                  color: AppColors.primaryOrange,
                ),
              ),
              const SizedBox(height: 40),
              // Mensaje principal de agradecimiento
              const Text(
                '¡Gracias por tu aporte!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Mensaje secundario
              const Text(
                'Tu opinión ayudará a otros estudiantes.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              // Botón para volver al inicio
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Volver al inicio',
                  onPressed: () {
                    // Navegar al main navigation y limpiar toda la pila de navegación
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/main',
                      (route) => false,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
