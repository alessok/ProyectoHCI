import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/professor.dart';
import '../services/mock_data_service.dart';
import '../widgets/professor_card_variants.dart';
import 'professor_profile_screen.dart';

/// Pantalla que muestra los profesores favoritos del usuario
class FavoriteProfessorsScreen extends StatefulWidget {
  const FavoriteProfessorsScreen({super.key});

  @override
  State<FavoriteProfessorsScreen> createState() => _FavoriteProfessorsScreenState();
}

class _FavoriteProfessorsScreenState extends State<FavoriteProfessorsScreen> {
  List<Professor> _favoriteProfessors = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteProfessors();
  }

  void _loadFavoriteProfessors() {
    setState(() {
      // Obtener profesores favoritos (los mejor calificados por ahora)
      _favoriteProfessors = MockDataService.getFavoriteProfessors(limit: 10);
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
                        'Profesores Favoritos',
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
              child: _favoriteProfessors.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: AppColors.mediumGray,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No tienes profesores favoritos aún',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Agrega profesores a favoritos desde sus perfiles',
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
                    'Tienes ${_favoriteProfessors.length} profesores favoritos',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _favoriteProfessors.length,
                      itemBuilder: (context, index) {
                        final professor = _favoriteProfessors[index];
                        return ProfessorGridCard(
                          professor: professor,
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
                        );
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
}
