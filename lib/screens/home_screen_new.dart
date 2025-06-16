import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/professor.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_filter.dart';
import 'search_screen.dart';
import 'professor_profile_screen.dart';
import 'ranking_screen.dart';
import '../services/mock_data_service.dart';

/// Pantalla principal (Home) completamente rediseñada y optimizada
class HomeScreenNew extends StatefulWidget {
  final VoidCallback? onSearchTap;
  
  const HomeScreenNew({super.key, this.onSearchTap});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
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
      _categories = MockDataService.getAllDepartments();
      _loadProfessorsByCategory();
    });
  }

  void _loadProfessorsByCategory() {
    if (_selectedCategory == 'All') {
      _favoriteProfessors = MockDataService.getFavoriteProfessors(limit: 4); // Reducido a 4
      _topProfessors = MockDataService.getTopProfessors(limit: 3);
    } else {
      final allProfessors = MockDataService.getAllProfessors();
      final filteredProfessors = allProfessors
          .where((professor) => professor.department == _selectedCategory)
          .toList();
      
      _favoriteProfessors = filteredProfessors.take(4).toList(); // Reducido a 4
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
            
            // Contenido principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0), // Aumentado de 16.0 a 20.0 para más margen
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filtros de categoría
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
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
                    
                    // Grid de profesores favoritos - NUEVO DISEÑO
                    SizedBox(
                      height: 140, // Aumentado de 130 a 140 para eliminar overflow
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _favoriteProfessors.length,
                        itemBuilder: (context, index) {
                          final professor = _favoriteProfessors[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0), // Aumentado de 10.0 a 12.0
                            child: _CompactProfessorCard(
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
                    ..._topProfessors.map((professor) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _TopProfessorListCard(
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
                    )).toList(),
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

/// Widget compacto para tarjetas de profesores favoritos
class _CompactProfessorCard extends StatelessWidget {
  final Professor professor;
  final VoidCallback onTap;

  const _CompactProfessorCard({
    required this.professor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Extraer sufijo y nombre para mostrar en la tarjeta
    String getDisplayPrefix(String fullName) {
      // Extraer solo el prefijo (Dr., Mg., Prof., Arq.)
      final match = RegExp(r'^(Dr\.|Mg\.|Prof\.|Arq\.)\s+').firstMatch(fullName);
      return match?.group(1) ?? '';
    }

    String getDisplayName(String fullName) {
      // Remover prefijos y obtener el apellido
      String cleanName = fullName.replaceAll(RegExp(r'^(Dr\.|Mg\.|Prof\.|Arq\.)\s+'), '');
      final parts = cleanName.split(' ');
      
      if (parts.length >= 2) {
        // Si hay nombre y apellido, mostrar solo el apellido
        return parts.last;
      }
      // Si solo hay una palabra, mostrarla completa
      return parts[0];
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, // Aumentado de 95 a 100 para más espacio horizontal
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Avatar
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 30,
                color: AppColors.mediumGray,
              ),
            ),
            
            // Información
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Aumentado de 6.0 a 8.0 para más espacio
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        // Mostrar prefijo (Dr., Mg., etc.)
                        Text(
                          getDisplayPrefix(professor.name),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryOrange,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2), // Aumentado de 1 a 2
                        // Mostrar apellido
                        Text(
                          getDisplayName(professor.name),
                          style: const TextStyle(
                            fontSize: 12, // Aumentado de 11 a 12
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 3), // Aumentado de 2 a 3
                        Text(
                          professor.department.split(' ').last, // Solo último término del departamento
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    // Rating en la parte inferior
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.primaryGold,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          professor.averageRating.toString(),
                          style: const TextStyle(
                            fontSize: 10, // Aumentado de 9 a 10
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
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

/// Widget para las tarjetas de top profesores en lista
class _TopProfessorListCard extends StatelessWidget {
  final Professor professor;
  final VoidCallback onTap;

  const _TopProfessorListCard({
    required this.professor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: AppColors.lightGray,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.mediumGray,
                size: 25,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professor.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    professor.department,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    professor.courses.join(' • '),
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
            
            // Rating y menú
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.primaryGold,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      professor.averageRating.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${professor.totalReviews} reseñas',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
