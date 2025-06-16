import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/professor.dart';
import '../services/mock_data_service.dart';
import '../widgets/professor_card_variants.dart';
import 'professor_profile_screen.dart';

/// Pantalla de ranking de profesores
class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Professor> _professors = [];
  String _sortBy = 'rating'; // 'rating' o 'reviews'

  @override
  void initState() {
    super.initState();
    _loadProfessors();
  }

  void _loadProfessors() {
    setState(() {
      if (_sortBy == 'rating') {
        _professors = MockDataService.getFavoriteProfessors(limit: 15);
      } else {
        _professors = MockDataService.getTopProfessors(limit: 15);
      }
    });
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
                        // Botón de retroceder
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
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
                            '🏆 Ranking de Profesores',
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
                    const SizedBox(height: 16),
                    
                    // Selector de ordenamiento
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _sortBy = 'rating';
                                  _loadProfessors();
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
                                  _loadProfessors();
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
            
            // Lista de ranking
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: _professors.length,
                itemBuilder: (context, index) {
                  final professor = _professors[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: RankingProfessorCard(
                      professor: professor,
                      position: index + 1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfessorProfileScreen(
                              professor: professor,
                            ),
                          ),
                        );
                      },
                    ),
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
