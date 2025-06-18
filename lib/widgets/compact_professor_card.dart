import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/professor.dart';

/// Widget compacto y reutilizable para mostrar profesores
/// Usado en la pantalla principal para profesores favoritos
class CompactProfessorCard extends StatelessWidget {
  final Professor professor;
  final VoidCallback onTap;

  const CompactProfessorCard({
    super.key,
    required this.professor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del profesor
            Container(
              height: 70,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 30,
                color: AppColors.mediumGray,
              ),
            ),
            
            // Información del profesor
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professor.formattedName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 2),
                  
                  Text(
                    professor.department,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.primaryGold,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        professor.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 10,
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
