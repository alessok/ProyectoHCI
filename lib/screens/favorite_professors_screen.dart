import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../widgets/professor_card_variants.dart';
import '../core/providers/professor_provider.dart';
import 'professor_profile_screen.dart';

/// Pantalla que muestra los profesores favoritos del usuario integrada con Provider
class FavoriteProfessorsScreen extends StatefulWidget {
  const FavoriteProfessorsScreen({super.key});

  @override
  State<FavoriteProfessorsScreen> createState() => _FavoriteProfessorsScreenState();
}

class _FavoriteProfessorsScreenState extends State<FavoriteProfessorsScreen> {
  void _reloadFavorites() {
    final provider = Provider.of<ProfessorProvider>(context, listen: false);
    provider.loadProfessorsByCategory('All');
  }

  @override
  void initState() {
    super.initState();
    // Cargar profesores favoritos usando el provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfessorProvider>(context, listen: false);
      provider.loadProfessorsByCategory('All');
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
            
            // Contenido principal usando Consumer
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

                  final favoriteProfessors = provider.favoriteProfessors;

                  if (favoriteProfessors.isEmpty) {
                    return const Center(
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
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tienes ${favoriteProfessors.length} profesores favoritos',
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
                            itemCount: favoriteProfessors.length,
                            itemBuilder: (context, index) {
                              final professor = favoriteProfessors[index];
                              return ProfessorGridCard(
                                professor: professor,
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
                                    _reloadFavorites();
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
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
