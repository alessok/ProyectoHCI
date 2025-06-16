import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/professor.dart';
import '../widgets/professor_card.dart';
import '../widgets/top_professor_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_filter.dart';
import 'search_screen.dart';
import 'professor_profile_screen.dart';
import 'ranking_screen.dart';
import '../services/mock_data_service.dart';

/// Pantalla principal (Home) con diseño de la Universidad de Lima
class HomeScreen extends StatefulWidget {
  final VoidCallback? onSearchTap;
  
  const HomeScreen({super.key, this.onSearchTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Obtener datos desde el servicio
  List<String> _categories = [];
  List<Professor> _favoriteProfessors = [];
  List<Professor> _topProfessors = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _categories = MockDataService.getAllDepartments(); // Ya incluye 'All' 
      _loadProfessorsByCategory();
    });
  }

  void _loadProfessorsByCategory() {
    if (_selectedCategory == 'All') {
      _favoriteProfessors = MockDataService.getFavoriteProfessors(limit: 5);
      _topProfessors = MockDataService.getTopProfessors(limit: 3);
    } else {
      // Filtrar por categoría seleccionada
      final allProfessors = MockDataService.getAllProfessors();
      final filteredProfessors = allProfessors
          .where((professor) => professor.department == _selectedCategory)
          .toList();
      
      _favoriteProfessors = filteredProfessors.take(5).toList();
      _topProfessors = filteredProfessors.take(3).toList();
    }
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _loadProfessorsByCategory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header con gradiente naranja
          SliverAppBar(
            expandedHeight: 140, // Reducido de 150 a 140 para mejor balance
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryOrange,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryOrange, AppColors.primaryGold],
                  ),
                ),
                child: SafeArea(                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // Reducido de 20.0 a 16.0
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10), // Reducido de 20 a 10
                        
                        // Saludo y logo
                        Row(
                          children: [
                            // Logo circular
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: AppColors.darkGray,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.school,
                                color: AppColors.textLight,
                                size: 30,
                              ),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            // Texto de bienvenida
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hola, Bienvenido a',
                                    style: TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'RankedYourProf UL',
                                    style: TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),                          
                          const SizedBox(height: 16), // Reducido de 24 a 16
                          
                          // Barra de búsqueda
                        GestureDetector(
                          onTap: () {
                            // Si hay callback, usarlo (desde MainNavigation)
                            // Si no, navegar directamente (fallback)
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
                              onChanged: (value) {
                                // No hacer nada aquí, navegamos a SearchScreen
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Contenido principal
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Filtros de categoría
                Container(
                  height: 45, // Reducido de 50 a 45
                  padding: const EdgeInsets.symmetric(vertical: 2.0), // Reducido de 4.0 a 2.0
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // Reducido de 20.0 a 16.0
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: CategoryFilter(
                          text: category,
                          isSelected: isSelected,
                          onTap: () => _onCategoryChanged(category),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 12), // Reducido de 16 a 12
                
                // Sección Profesor Favorito
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Reducido de 20.0 a 16.0
                  child: Column(
                    children: [
                      // Título de sección
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Profesor Favorito',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navegar a la pantalla de búsqueda
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
                      
                      const SizedBox(height: 6), // Reducido de 8 a 6
                      
                      // Grid de profesores favoritos (altura más reducida)
                      SizedBox(
                        height: 80, // Reducido de 95 a 80 para las tarjetas más pequeñas
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _favoriteProfessors.length,
                          itemBuilder: (context, index) {
                            final professor = _favoriteProfessors[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0), // Aumentado de 6.0 a 8.0 para mejor separación
                              child: ProfessorCard(
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
                    ],
                  ),
                ),
                
                const SizedBox(height: 12), // Reducido de 16 a 12
                
                // Sección Top Profesor
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Reducido de 20.0 a 16.0
                  child: Column(
                    children: [
                      // Título de sección
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Top Profesor',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navegar a la pantalla de ranking usando ruta nombrada
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
                      
                      const SizedBox(height: 6), // Reducido de 8 a 6
                      
                      // Lista de top profesores (ultracompacta)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _topProfessors.length,
                        itemBuilder: (context, index) {
                          final professor = _topProfessors[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6.0), // Reducido de 8.0 a 6.0
                            child: TopProfessorCard(
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
                    ],
                  ),
                ),
                
                const SizedBox(height: 16), // Reducido de 20 a 16 para mejor fit
              ],
            ),
          ),
        ],
      ),
    );
  }
}
