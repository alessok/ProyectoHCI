import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/professor.dart';
import 'rate_professor_screen.dart';
import '../core/providers/professor_provider.dart';

/// Pantalla de perfil detallado del profesor
class ProfessorProfileScreen extends StatefulWidget {
  final Professor professor;

  const ProfessorProfileScreen({
    super.key,
    required this.professor,
  });

  @override
  State<ProfessorProfileScreen> createState() => _ProfessorProfileScreenState();
}

class _ProfessorProfileScreenState extends State<ProfessorProfileScreen> {
  bool _isFavorite = false;
  final List<Map<String, dynamic>> _reviews = [];
  final Map<int, int> _ratingDistribution = {};

  @override
  void initState() {
    super.initState();
    _loadProfessorData();
  }

  void _loadProfessorData() async {
    final provider = Provider.of<ProfessorProvider>(context, listen: false);
    final isFav = await provider.isFavoriteProfessor(widget.professor.id);
    setState(() {
      _isFavorite = isFav;
    });
    // ... puedes cargar reviews reales aquí si lo deseas ...
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    final provider = Provider.of<ProfessorProvider>(context, listen: false);
    await provider.toggleFavoriteProfessor(widget.professor.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavorite 
            ? 'Profesor agregado a favoritos' 
            : 'Profesor removido de favoritos'),
          backgroundColor: AppColors.primaryOrange,
        ),
      );
      // Notificar al volver que hubo cambio
      Navigator.pop(context, true);
    }
  }

  void _openRatingDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RateProfessorScreen(professor: widget.professor),
      ),
    ).then((result) {
      // Si se envió una evaluación, recargar los datos
      if (result == true && mounted) {
        _loadProfessorData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header con gradiente y botón de retroceso
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryOrange,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.textLight,
                    size: 18,
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryOrange, AppColors.primaryGold],
                  ),
                ),
                child: const SafeArea(
                  child: Center(
                    child: Text(
                      'RankedYourProf ULima',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Contenido principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Perfil del profesor
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Foto del profesor
                      Container(
                        width: 120,
                        height: 160,
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Foto',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.mediumGray,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      // Información del profesor
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            
                            // Nombre del profesor
                            Text(
                              widget.professor.formattedName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Departamento
                            Text(
                              widget.professor.department,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Botón de favorito
                            IconButton(
                              onPressed: _toggleFavorite,
                              icon: Icon(
                                _isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: _isFavorite ? Colors.red : AppColors.mediumGray,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Rating y distribución
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating promedio
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              widget.professor.averageRating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            
                            // Estrellas
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < widget.professor.averageRating.floor()
                                    ? Icons.star
                                    : index < widget.professor.averageRating
                                      ? Icons.star_half
                                      : Icons.star_border,
                                  color: AppColors.star,
                                  size: 20,
                                );
                              }),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            Text(
                              '${widget.professor.totalReviews} Reviews',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Distribución de ratings
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: List.generate(5, (index) {
                            final rating = 5 - index;
                            final count = _ratingDistribution[rating] ?? 0;
                            final percentage = widget.professor.totalReviews > 0 
                                ? count / widget.professor.totalReviews 
                                : 0.0;
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                children: [
                                  Text(
                                    '$rating',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.star,
                                    color: AppColors.star,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.lightGray,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: percentage,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryOrange,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Palabras frecuentes
                  const Text(
                    'Palabras frecuentes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _FrequentWordChip(word: 'Dinámico', count: 120),
                      _FrequentWordChip(word: 'Carismático', count: 177),
                      _FrequentWordChip(word: 'Exigente', count: 80),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Reseñas
                  if (_reviews.isNotEmpty) ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _reviews.take(3).length,
                      itemBuilder: (context, index) {
                        final review = _reviews[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: _ReviewCard(review: review),
                        );
                      },
                    ),
                    
                    if (_reviews.length > 3)
                      TextButton(
                        onPressed: () {
                          // TODO: Navegar a todas las reseñas
                        },
                        child: const Text(
                          'Ver todas las reseñas',
                          style: TextStyle(
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                  
                  const SizedBox(height: 40),
                  
                  // Botón Calificar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _openRatingDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Calificar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 100), // Espacio para bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar palabras frecuentes
class _FrequentWordChip extends StatelessWidget {
  final String word;
  final int count;

  const _FrequentWordChip({
    required this.word,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$word ($count)',
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Widget para mostrar una reseña
class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Header de la reseña
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGold,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '😊',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Nombre y estrellas
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Alumno Ulima',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    
                    Row(
                      children: [
                        // Estrellas
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < review['rating'] 
                                ? Icons.star 
                                : Icons.star_border,
                              color: AppColors.star,
                              size: 16,
                            );
                          }),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        Text(
                          '1 h ago',
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
              
              // Menú de opciones
              IconButton(
                onPressed: () {
                  // TODO: Mostrar opciones de reseña
                },
                icon: const Icon(
                  Icons.more_horiz,
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Contenido de la reseña
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
}
