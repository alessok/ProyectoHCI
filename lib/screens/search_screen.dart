import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/professor.dart';
import '../services/mock_data_service.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_filter.dart';
import 'professor_profile_screen.dart';

/// Pantalla de búsqueda de profesores con filtros
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  List<Professor> _allProfessors = [];
  List<Professor> _filteredProfessors = [];
  String _selectedCategory = 'Todo';
  String _searchQuery = '';

  final List<String> _categories = [
    'Todo',
    'Ing. Sistemas',
    'Ing. Industrial',
    'Ing. Civil',
    'Arquitectura',
    'Comunicación',
    'Derecho',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfessors();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _loadProfessors() {
    setState(() {
      _allProfessors = MockDataService.getAllProfessors();
      _filteredProfessors = _allProfessors;
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterProfessors();
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _filterProfessors();
    });
  }

  void _filterProfessors() {
    _filteredProfessors = _allProfessors.where((professor) {
      // Filtro por categoría
      bool categoryMatch = _selectedCategory == 'Todo' || 
          professor.department == _selectedCategory;
      
      // Filtro por búsqueda
      bool searchMatch = _searchQuery.isEmpty ||
          professor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          professor.department.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          professor.courses.any((course) => 
              course.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      return categoryMatch && searchMatch;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'Todo';
      _searchController.clear();
      _searchQuery = '';
      _filteredProfessors = _allProfessors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header con gradiente naranja
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila con botón de retroceder y título
                    Row(
                      children: [
                        // Botón de retroceder
                        GestureDetector(
                          onTap: () {
                            // Navegar de vuelta usando Navigator.pop para mantener la pila de navegación
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              // Si no hay una pantalla anterior, navegar a MainNavigationScreen
                              Navigator.pushReplacementNamed(context, '/main');
                            }
                          },
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
                            'Buscar Profesores',
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
                    
                    const SizedBox(height: 20),
                    
                    // Barra de búsqueda
                    SearchBarWidget(
                      controller: _searchController,
                      hintText: 'Buscar profesor...',
                      onChanged: (value) {
                        // La búsqueda se maneja en _onSearchChanged
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Contenido principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // Título "Buscar por carrera"
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Buscar por carrera',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Filtros de categoría
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  
                  const SizedBox(height: 20),
                  
                  // Resultados y botón eliminar filtros
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_filteredProfessors.length} Resultados',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (_selectedCategory != 'Todo' || _searchQuery.isNotEmpty)
                          TextButton(
                            onPressed: _clearFilters,
                            child: const Text(
                              'Eliminar filtros',
                              style: TextStyle(
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Lista de profesores
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: _filteredProfessors.length,
                      itemBuilder: (context, index) {
                        final professor = _filteredProfessors[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _ProfessorSearchCard(
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
          ],
        ),
      ),
    );
  }
}

/// Widget personalizado para las tarjetas de profesores en búsqueda
class _ProfessorSearchCard extends StatelessWidget {
  final Professor professor;
  final VoidCallback onTap;

  const _ProfessorSearchCard({
    required this.professor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar del profesor
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: AppColors.lightGray,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.mediumGray,
                size: 30,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Información del profesor
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del profesor
                  Text(
                    professor.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Departamento
                  Text(
                    professor.department,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Rating y menú
            Column(
              children: [
                // Menú de opciones
                IconButton(
                  onPressed: () {
                    // TODO: Mostrar opciones del profesor
                  },
                  icon: const Icon(
                    Icons.more_horiz,
                    color: AppColors.mediumGray,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Rating con estrella
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.star,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      professor.averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                
                // Número de reseñas
                Text(
                  '(${professor.totalReviews} reviews)',
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
    );
  }
}
