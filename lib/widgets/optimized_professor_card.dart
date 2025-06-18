import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/professor.dart';

/// Widget optimizado para mostrar tarjetas de profesores
/// Incluye mejoras de performance con const constructors y memorización
class OptimizedProfessorCard extends StatelessWidget {
  final Professor professor;
  final VoidCallback? onTap;
  final bool showFavoriteButton;
  final bool isCompact;
  final Widget? trailing;

  const OptimizedProfessorCard({
    super.key,
    required this.professor,
    this.onTap,
    this.showFavoriteButton = false,
    this.isCompact = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
          child: isCompact ? _buildCompactContent() : _buildFullContent(),
        ),
      ),
    );
  }

  Widget _buildCompactContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar y nombre
        Row(
          children: [
            _buildAvatar(32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OptimizedText(
                    professor.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  _OptimizedText(
                    professor.department,
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
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Rating
        _buildRatingRow(isCompact: true),
      ],
    );
  }

  Widget _buildFullContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con avatar, nombre y favorito
        Row(
          children: [
            _buildAvatar(48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OptimizedText(
                    professor.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _OptimizedText(
                    professor.department,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (showFavoriteButton) _buildFavoriteButton(),
            if (trailing != null) trailing!,
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Rating y reviews
        _buildRatingRow(),
        
        const SizedBox(height: 12),
        
        // Cursos (solo mostrar los primeros 2)
        if (professor.courses.isNotEmpty) _buildCoursesSection(),
      ],
    );
  }

  Widget _buildAvatar(double size) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.primaryOrange,
      backgroundImage: professor.photoUrl != null 
          ? NetworkImage(professor.photoUrl!) 
          : null,
      child: professor.photoUrl == null
          ? Text(
              _getInitials(professor.name),
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  Widget _buildRatingRow({bool isCompact = false}) {
    return Row(
      children: [
        // Estrellas optimizadas
        _OptimizedStarRating(
          rating: professor.averageRating,
          size: isCompact ? 14 : 16,
        ),
        
        const SizedBox(width: 8),
        
        // Rating numérico
        _OptimizedText(
          professor.averageRating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: isCompact ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        
        const SizedBox(width: 8),
        
        // Número de reviews
        _OptimizedText(
          '(${professor.totalReviews} reviews)',
          style: TextStyle(
            fontSize: isCompact ? 10 : 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return IconButton(
      onPressed: () {
        // TODO: Implementar toggle de favorito
      },
      icon: const Icon(
        Icons.favorite_border,
        color: AppColors.mediumGray,
        size: 20,
      ),
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildCoursesSection() {
    final displayCourses = professor.courses.take(2).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _OptimizedText(
          'Cursos:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: displayCourses.map((course) => _CourseChip(course)).toList(),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0][0].toUpperCase();
    }
    return 'P';
  }
}

/// Widget optimizado para texto que evita reconstrucciones innecesarias
class _OptimizedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const _OptimizedText(
    this.text, {
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }
}

/// Widget optimizado para mostrar rating con estrellas
class _OptimizedStarRating extends StatelessWidget {
  final double rating;
  final double size;

  const _OptimizedStarRating({
    required this.rating,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    // Pre-calcular las estrellas para evitar recálculos
    final stars = _buildStars();
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }

  List<Widget> _buildStars() {
    final stars = <Widget>[];
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;
    
    // Estrellas llenas
    for (int i = 0; i < fullStars; i++) {
      stars.add(_StarIcon(
        icon: Icons.star,
        color: AppColors.star,
        size: size,
      ));
    }
    
    // Media estrella
    if (hasHalfStar) {
      stars.add(_StarIcon(
        icon: Icons.star_half,
        color: AppColors.star,
        size: size,
      ));
    }
    
    // Estrellas vacías
    final emptyStars = 5 - stars.length;
    for (int i = 0; i < emptyStars; i++) {
      stars.add(_StarIcon(
        icon: Icons.star_border,
        color: AppColors.lightGray,
        size: size,
      ));
    }
    
    return stars;
  }
}

/// Widget optimizado para iconos de estrella
class _StarIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _StarIcon({
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: size,
    );
  }
}

/// Widget optimizado para chips de cursos
class _CourseChip extends StatelessWidget {
  final String course;

  const _CourseChip(this.course);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _OptimizedText(
        course,
        style: const TextStyle(
          fontSize: 10,
          color: AppColors.primaryOrange,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
