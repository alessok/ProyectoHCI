import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/mock_data_service.dart';
import '../services/session_service.dart';

/// Pantalla que muestra las reseñas del usuario actual
class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  List<Map<String, dynamic>> _userReviews = [];

  @override
  void initState() {
    super.initState();
    _loadUserReviews();
  }

  void _loadUserReviews() {
    setState(() {
      final currentUser = SessionService.getCurrentUser();
      _userReviews = _getUserReviews(currentUser.id);
    });
  }

  List<Map<String, dynamic>> _getUserReviews(String userId) {
    final allProfessors = MockDataService.getAllProfessors();
    final userReviews = <Map<String, dynamic>>[];

    for (final professor in allProfessors) {
      final professorReviews = MockDataService.getReviewsForProfessor(professor.id);
      for (final review in professorReviews) {
        if (review['userId'] == userId) {
          userReviews.add({
            ...review,
            'professorName': professor.name,
            'professorDepartment': professor.department,
          });
        }
      }
    }

    // Ordenar por fecha (más recientes primero)
    userReviews.sort((a, b) => b['date'].compareTo(a['date']));
    return userReviews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header con gradiente y botón de retroceder
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryOrange, AppColors.primaryGold],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    // Botón de retroceder
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.textLight,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Título centrado
                    const Expanded(
                      child: Text(
                        'Mis Reseñas',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Espacio vacío para mantener centrado el título
                    const SizedBox(width: 44), // Ancho del botón + padding
                  ],
                ),
              ),
            ),
            
            // Contenido principal
            Expanded(
              child: _userReviews.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 64,
                    color: AppColors.mediumGray,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No has escrito reseñas aún',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Califica a tus profesores para ayudar a otros estudiantes',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.mediumGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Has escrito ${_userReviews.length} reseñas',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _userReviews.length,
                      itemBuilder: (context, index) {
                        final review = _userReviews[index];
                        return _buildReviewCard(review);
                      },
                    ),
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

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
          // Header con profesor y fecha
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['professorName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      review['professorDepartment'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatDate(review['date']),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Rating con estrellas
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < review['rating'] 
                    ? Icons.star 
                    : Icons.star_border,
                  color: AppColors.star,
                  size: 18,
                );
              }),
              const SizedBox(width: 8),
              Text(
                '${review['rating']}/5',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Comentario
          Text(
            review['comment'] ?? 'Sin comentario',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} horas';
    } else {
      return 'Hace ${difference.inMinutes} minutos';
    }
  }
}
