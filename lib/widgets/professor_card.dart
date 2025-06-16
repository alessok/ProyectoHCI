import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/professor.dart';

/// Widget para las tarjetas de profesores favoritos
class ProfessorCard extends StatelessWidget {
  final Professor professor;
  final VoidCallback onTap;

  const ProfessorCard({
    super.key,
    required this.professor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, // Reducido de 120 a 100 para mejor fit
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del profesor (placeholder) - Más compacta
            Container(
              height: 55, // Reducido de 65 a 55
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 24, // Reducido de 28 a 24
                color: AppColors.mediumGray,
              ),
            ),
            
            // Información del profesor - Más compacta
            Padding(
              padding: const EdgeInsets.all(4.0), // Reducido de 6.0 a 4.0
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professor.name,
                    style: const TextStyle(
                      fontSize: 11, // Reducido de 13 a 11
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 1), // Reducido de 2 a 1
                  
                  Text(
                    professor.department,
                    style: const TextStyle(
                      fontSize: 9, // Reducido de 10 a 9
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 2), // Reducido de 4 a 2
                  
                  // Rating - Más compacto
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.primaryGold,
                        size: 10, // Reducido de 12 a 10
                      ),
                      const SizedBox(width: 1), // Reducido de 2 a 1
                      Text(
                        professor.averageRating.toString(),
                        style: const TextStyle(
                          fontSize: 9, // Reducido de 11 a 9
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
