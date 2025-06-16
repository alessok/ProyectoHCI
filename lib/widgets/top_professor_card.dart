import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/professor.dart';

/// Widget de tarjeta para profesores top en formato horizontal
class TopProfessorCard extends StatelessWidget {
  final Professor professor;
  final VoidCallback? onTap;

  const TopProfessorCard({
    super.key,
    required this.professor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar del profesor
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: AppColors.lightGray,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.mediumGray,
                size: 30,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Información del profesor
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del profesor
                  Text(
                    professor.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Departamento
                  Text(
                    professor.department,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Cursos
                  Text(
                    professor.courses.join(' • '),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Rating y reseñas
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Rating con estrella
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.star,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      professor.averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Número de reseñas
                Text(
                  '${professor.totalReviews} reseñas',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
