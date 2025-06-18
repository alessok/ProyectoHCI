import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/professor.dart';

/// Widget unificado para tarjetas de profesores en formato de lista
/// Usado en pantallas como ranking, search, top profesores
class ProfessorListCard extends StatelessWidget {
  final Professor professor;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;
  final bool showRating;
  final bool showReviewsCount;

  const ProfessorListCard({
    super.key,
    required this.professor,
    required this.onTap,
    this.leading,
    this.trailing,
    this.showRating = true,
    this.showReviewsCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Leading widget (posición, avatar, etc.)
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ] else ...[
              // Avatar por defecto
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: AppColors.lightGray,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.mediumGray,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
            ],
            
            // Información del profesor
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professor.formattedName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    professor.department,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    professor.courses.isNotEmpty 
                        ? professor.courses.join(' • ')
                        : 'Sin cursos asignados',
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
            
            // Trailing widget o rating por defecto
            if (trailing != null)
              trailing!
            else if (showRating)
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.primaryGold,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        professor.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (showReviewsCount) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${professor.totalReviews} reseñas',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Widget para tarjetas de profesores en grid
/// Usado en pantallas como favoritos donde se necesita vista de grid
class ProfessorGridCard extends StatelessWidget {
  final Professor professor;
  final VoidCallback onTap;
  final double? width;
  final bool compact;

  const ProfessorGridCard({
    super.key,
    required this.professor,
    required this.onTap,
    this.width,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? (compact ? 120.0 : 160.0);
    final cardHeight = compact ? 140.0 : 180.0;
    final imageHeight = compact ? 70.0 : 80.0;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
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
              height: imageHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Icon(
                Icons.person,
                size: compact ? 30 : 35,
                color: AppColors.mediumGray,
              ),
            ),
            
            // Información del profesor
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professor.formattedName,
                      style: TextStyle(
                        fontSize: compact ? 12 : 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 2),
                    
                    Text(
                      professor.department,
                      style: TextStyle(
                        fontSize: compact ? 10 : 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Spacer(),
                    
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
                          style: TextStyle(
                            fontSize: compact ? 10 : 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget especializado para el ranking con posición
class RankingProfessorCard extends StatelessWidget {
  final Professor professor;
  final int position;
  final VoidCallback onTap;

  const RankingProfessorCard({
    super.key,
    required this.professor,
    required this.position,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProfessorListCard(
      professor: professor,
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _getPositionColor(),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _getPositionWidget(),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.mediumGray,
        size: 16,
      ),
    );
  }

  Color _getPositionColor() {
    switch (position) {
      case 1:
        return const Color(0xFFFFD700); // Oro
      case 2:
        return const Color(0xFFC0C0C0); // Plata
      case 3:
        return const Color(0xFFCD7F32); // Bronce
      default:
        return AppColors.primaryOrange;
    }
  }

  Widget _getPositionWidget() {
    if (position <= 3) {
      return Icon(
        Icons.emoji_events,
        color: Colors.white,
        size: 24,
      );
    }
    return Text(
      position.toString(),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}
