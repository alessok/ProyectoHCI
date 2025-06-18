import 'package:flutter/material.dart';
import '../models/professor.dart';
import '../constants/colors.dart';

/// Tipos de filtro disponibles para profesores
enum FilterType {
  all,           // Todos los profesores
  highRated,     // Mejor valorados (≥ 4.0)
  popular,       // Populares (≥ 50 reseñas)
  newProfessors, // Nuevos profesores (< 10 reseñas)
}

/// Tipos de ordenamiento disponibles
enum SortType {
  rating,     // Por calificación promedio
  reviews,    // Por número de reseñas
  name,       // Por nombre alfabético
  department, // Por departamento
  newest,     // Por más recientes (menos reseñas = más nuevo)
}

/// Servicio estático para aplicar filtros y ordenamientos avanzados
class FilterService {
  /// Aplica filtros a una lista de profesores
  static List<Professor> applyFilters(List<Professor> professors, FilterType filterType) {
    switch (filterType) {
      case FilterType.all:
        return professors;
      
      case FilterType.highRated:
        return professors.where((prof) => prof.averageRating >= 4.0).toList();
      
      case FilterType.popular:
        return professors.where((prof) => prof.totalReviews >= 50).toList();
      
      case FilterType.newProfessors:
        return professors.where((prof) => prof.totalReviews < 10).toList();
    }
  }

  /// Ordena una lista de profesores según el tipo de ordenamiento
  static List<Professor> sortProfessors(
    List<Professor> professors, 
    SortType sortType, {
    bool ascending = false,
  }) {
    final sortedList = List<Professor>.from(professors);

    switch (sortType) {
      case SortType.rating:
        sortedList.sort((a, b) => ascending 
          ? a.averageRating.compareTo(b.averageRating)
          : b.averageRating.compareTo(a.averageRating));
        break;

      case SortType.reviews:
        sortedList.sort((a, b) => ascending 
          ? a.totalReviews.compareTo(b.totalReviews)
          : b.totalReviews.compareTo(a.totalReviews));
        break;

      case SortType.name:
        sortedList.sort((a, b) => ascending 
          ? a.name.compareTo(b.name)
          : b.name.compareTo(a.name));
        break;

      case SortType.department:
        sortedList.sort((a, b) => ascending 
          ? a.department.compareTo(b.department)
          : b.department.compareTo(a.department));
        break;

      case SortType.newest:
        // Menos reseñas = más nuevo
        sortedList.sort((a, b) => ascending 
          ? b.totalReviews.compareTo(a.totalReviews)
          : a.totalReviews.compareTo(b.totalReviews));
        break;
    }

    return sortedList;
  }

  /// Obtiene la etiqueta de texto para un tipo de filtro
  static String getFilterLabel(FilterType filterType) {
    switch (filterType) {
      case FilterType.all:
        return 'Todos';
      case FilterType.highRated:
        return 'Mejor valorados';
      case FilterType.popular:
        return 'Populares';
      case FilterType.newProfessors:
        return 'Nuevos profesores';
    }
  }

  /// Obtiene la etiqueta de texto para un tipo de ordenamiento
  static String getSortLabel(SortType sortType) {
    switch (sortType) {
      case SortType.rating:
        return 'Calificación';
      case SortType.reviews:
        return 'Número de reseñas';
      case SortType.name:
        return 'Nombre';
      case SortType.department:
        return 'Departamento';
      case SortType.newest:
        return 'Más recientes';
    }
  }

  /// Obtiene el icono para un tipo de filtro
  static IconData getFilterIcon(FilterType filterType) {
    switch (filterType) {
      case FilterType.all:
        return Icons.list;
      case FilterType.highRated:
        return Icons.star;
      case FilterType.popular:
        return Icons.trending_up;
      case FilterType.newProfessors:
        return Icons.new_releases;
    }
  }

  /// Obtiene el icono para un tipo de ordenamiento
  static IconData getSortIcon(SortType sortType) {
    switch (sortType) {
      case SortType.rating:
        return Icons.star_outline;
      case SortType.reviews:
        return Icons.comment_outlined;
      case SortType.name:
        return Icons.sort_by_alpha;
      case SortType.department:
        return Icons.business;
      case SortType.newest:
        return Icons.access_time;
    }
  }
}

/// Widget para mostrar opciones de filtro
class FilterOptionWidget extends StatelessWidget {
  final FilterType filterType;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterOptionWidget({
    super.key,
    required this.filterType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryOrange : AppColors.lightGray,
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primaryOrange.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Icon(
              FilterService.getFilterIcon(filterType),
              color: isSelected ? Colors.white : AppColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              FilterService.getFilterLabel(filterType),
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

/// Widget para mostrar opciones de ordenamiento
class SortOptionWidget extends StatelessWidget {
  final SortType sortType;
  final bool isSelected;
  final bool isAscending;
  final VoidCallback onTap;

  const SortOptionWidget({
    super.key,
    required this.sortType,
    required this.isSelected,
    required this.isAscending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGold : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : AppColors.lightGray,
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primaryGold.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Icon(
              FilterService.getSortIcon(sortType),
              color: isSelected ? Colors.white : AppColors.textPrimary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                FilterService.getSortLabel(sortType),
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            if (isSelected) ...[
              Icon(
                isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                isAscending ? 'Asc' : 'Desc',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
