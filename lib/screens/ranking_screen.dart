import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/professor.dart';
import '../widgets/professor_card_variants.dart';
import '../core/providers/professor_provider.dart';
import 'professor_profile_screen.dart';

/// Pantalla de ranking de profesores integrada con Provider
class RankingScreen extends StatefulWidget {
  final bool showBackButton;
  
  const RankingScreen({super.key, this.showBackButton = true});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  String _sortBy = 'rating'; // 'rating' o 'reviews'

  @override
  void initState() {
    super.initState();
    // Cargar profesores usando el provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfessorProvider>(context, listen: false);
      provider.loadProfessorsByCategory('All');
    });
  }

  List<Professor> _getSortedProfessors(List<Professor> professors) {
    final sortedList = List<Professor>.from(professors);
    if (_sortBy == 'rating') {
      sortedList.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    } else {
      sortedList.sort((a, b) => b.totalReviews.compareTo(a.totalReviews));
    }
    return sortedList.take(15).toList();
  }

  void _reloadRanking() {
    final provider = Provider.of<ProfessorProvider>(context, listen: false);
    provider.loadProfessorsByCategory('All');
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
                child: Column(
                  children: [
                    // Fila con botón de retroceder y título
                    Row(
                      children: [
                        // Botón de retroceder (solo si showBackButton es true)
                        if (widget.showBackButton) ...[
                          GestureDetector(
                            onTap: () {
                              // Verificar si se puede hacer pop, si no, navegar a main
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                // Si no hay pantalla anterior, navegar a MainNavigationScreen
                                Navigator.pushReplacementNamed(context, '/main');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
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
                        ],
                        
                        // Título centrado
                        Expanded(
                          child: Text(
                            '🏆 Ranking de Profesores',
                            textAlign: widget.showBackButton ? TextAlign.center : TextAlign.left,
                            style: const TextStyle(
                              color: AppColors.textLight,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        // Espacio vacío para mantener centrado el título (solo si hay botón)
                        if (widget.showBackButton)
                          const SizedBox(width: 44), // Ancho del botón + padding
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Selector de ordenamiento
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _sortBy = 'rating';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _sortBy == 'rating' 
                                    ? Colors.white 
                                    : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '⭐ Por Rating',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _sortBy == 'rating' 
                                      ? AppColors.textPrimary 
                                      : AppColors.textLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _sortBy = 'reviews';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _sortBy == 'reviews' 
                                    ? Colors.white 
                                    : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '💬 Por Reseñas',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _sortBy == 'reviews' 
                                      ? AppColors.textPrimary 
                                      : AppColors.textLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Lista de ranking usando Consumer
            Expanded(
              child: Consumer<ProfessorProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryOrange,
                      ),
                    );
                  }

                  if (provider.errorMessage != null) {
                    return Center(
                      child: Text(
                        provider.errorMessage!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  final sortedProfessors = _getSortedProfessors(provider.professors);

                  if (sortedProfessors.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay profesores disponibles',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: sortedProfessors.length,
                    itemBuilder: (context, index) {
                      final professor = sortedProfessors[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: RankingProfessorCard(
                          professor: professor,
                          position: index + 1,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfessorProfileScreen(
                                  professor: professor,
                                ),
                              ),
                            );
                            if (result == true) {
                              _reloadRanking();
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
