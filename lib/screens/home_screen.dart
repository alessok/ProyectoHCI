import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_filter.dart';
import '../widgets/compact_professor_card.dart';
import '../widgets/professor_card_variants.dart';
import '../core/providers/professor_provider.dart';
import 'search_screen.dart';
import 'professor_profile_screen.dart';
import 'ranking_screen.dart';

/// Pantalla principal (Home) completamente rediseñada y optimizada
class HomeScreen extends StatefulWidget {
  final VoidCallback? onSearchTap;
  
  const HomeScreen({super.key, this.onSearchTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar datos iniciales usando el provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfessorProvider>(context, listen: false);
      provider.loadProfessorsByCategory('All');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    
    // Usar el provider para cargar profesores por categoría
    final provider = Provider.of<ProfessorProvider>(context, listen: false);
    provider.changeCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header compacto con gradiente
            Container(
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
                    // Saludo y logo
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: AppColors.darkGray,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school,
                            color: AppColors.textLight,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hola, Bienvenido a',
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'RankedYourProf UL',
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Barra de búsqueda
                    GestureDetector(
                      onTap: () {
                        if (widget.onSearchTap != null) {
                          widget.onSearchTap!();
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          );
                        }
                      },
                      child: AbsorbPointer(
                        child: SearchBarWidget(
                          controller: _searchController,
                          hintText: 'Buscar profesor...',
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Contenido principal con Consumer
            Expanded(
              child: Consumer<ProfessorProvider>(
                builder: (context, provider, child) {
                  final categories = ['All', 'Ing. Sistemas', 'Ing. Industrial', 'Ing. Civil', 'Arquitectura', 'Comunicación', 'Derecho'];
                  final favoriteProfessors = provider.favoriteProfessors.take(4).toList();
                  final topProfessors = provider.topProfessors.take(3).toList();
                  
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filtros de categoría
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final isSelected = category == _selectedCategory;
                              
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CategoryFilter(
                                  text: category,
                                  isSelected: isSelected,
                                  onTap: () => _onCategoryChanged(category),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Sección Profesor Favorito
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Profesor Favorito',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SearchScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Ver todos',
                                style: TextStyle(
                                  color: AppColors.primaryOrange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Grid de profesores favoritos
                        SizedBox(
                          height: 160, // Aumentado de 140 a 160 para evitar overflow
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: favoriteProfessors.length,
                            itemBuilder: (context, index) {
                              final professor = favoriteProfessors[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: CompactProfessorCard(
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
                                ),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Sección Top Profesor
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Top Profesor',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RankingScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Ver todos',
                                style: TextStyle(
                                  color: AppColors.primaryOrange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Lista de top profesores
                        ...topProfessors.map((professor) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: ProfessorListCard(
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
                          ),
                        )),
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
