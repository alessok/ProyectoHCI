import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/auth_service.dart';
import '../services/favorite_service.dart';
import '../services/hybrid_review_service.dart';
import '../services/hybrid_data_service.dart';
import '../models/professor.dart';
import '../models/review.dart';
import 'home_screen.dart'; // Cambio a la pantalla consolidada
import 'search_screen.dart';
import 'ranking_screen.dart';
import 'favorite_professors_screen.dart';
import 'my_reviews_screen.dart';
import 'professor_profile_screen.dart';

/// Navegación principal con Bottom Navigation Bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    HomeScreen(
      onSearchTap: () {
        setState(() {
          _currentIndex = 1; // Navegar al tab de búsqueda
        });
      },
    ),
    const SearchScreen(showBackButton: false), // Sin botón de retroceder en la pestaña
    const RankingScreen(showBackButton: false), // Sin botón de retroceder en la pestaña
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryOrange,
        unselectedItemColor: AppColors.mediumGray,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

/// Pantalla de Notificaciones
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header con gradiente
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryOrange, AppColors.primaryGold],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Notificaciones',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Contenido de notificaciones
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  _buildNotificationCard(
                    icon: Icons.star,
                    title: 'Nueva reseña de Dr. Carlos Mendoza',
                    subtitle: 'Un estudiante ha calificado al profesor con 5 estrellas',
                    time: 'Hace 2 horas',
                    isNew: true,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.trending_up,
                    title: '¡Nuevo récord de calificaciones!',
                    subtitle: 'La app ha superado las 500 reseñas de profesores',
                    time: 'Hace 3 horas',
                    isNew: true,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.favorite,
                    title: 'Profesor agregado a favoritos',
                    subtitle: 'Mg. Laura Herrera fue agregada a tus favoritos',
                    time: 'Hace 1 día',
                    isNew: false,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.school,
                    title: 'Nuevo profesor en Ing. Sistemas',
                    subtitle: 'Dr. Roberto Silva ahora está disponible para calificar',
                    time: 'Hace 1 día',
                    isNew: false,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.emoji_events,
                    title: 'Cambio en el ranking',
                    subtitle: 'Dr. Ana García subió al puesto #2 en el ranking general',
                    time: 'Hace 2 días',
                    isNew: false,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.comment,
                    title: 'Comentario destacado',
                    subtitle: 'Tu reseña de Prof. Miguel Torres fue marcada como útil',
                    time: 'Hace 2 días',
                    isNew: false,
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    icon: Icons.trending_up,
                    title: 'Nuevo Top Profesor',
                    subtitle: 'Prof. Hernan Quintana subió en el ranking',
                    time: 'Hace 3 días',
                    isNew: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required bool isNew,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isNew ? Border.all(color: AppColors.primaryOrange, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryOrange,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isNew ? FontWeight.bold : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isNew)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pantalla de Perfil del Usuario
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _totalReviews = 0;
  int _totalFavorites = 0;
  List<Review> _recentReviews = [];
  List<Professor> _recentFavorites = [];
  Map<String, String> _professorNames = {}; // Mapa de ID a nombre
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Cargar datos en paralelo
      final futures = await Future.wait([
        _loadReviewStats(),
        _loadFavoriteStats(),
        _loadRecentReviews(),
        _loadRecentFavorites(),
        _loadProfessorNames(),
      ]);

      setState(() {
        _totalReviews = futures[0] as int;
        _totalFavorites = futures[1] as int;
        _recentReviews = futures[2] as List<Review>;
        _recentFavorites = futures[3] as List<Professor>;
        _professorNames = futures[4] as Map<String, String>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<int> _loadReviewStats() async {
    try {
      final reviews = await HybridReviewService.getUserReviews();
      return reviews.length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> _loadFavoriteStats() async {
    try {
      final stats = await FavoriteService.getFavoriteStats();
      return stats['totalFavorites'] as int;
    } catch (e) {
      return 0;
    }
  }

  Future<List<Review>> _loadRecentReviews() async {
    try {
      final reviews = await HybridReviewService.getUserReviews();
      return reviews.take(3).toList(); // Solo las 3 más recientes
    } catch (e) {
      return [];
    }
  }

  Future<List<Professor>> _loadRecentFavorites() async {
    try {
      final allProfessors = await HybridDataService.getAllProfessors();
      final favoriteProfessors = await FavoriteService.getFavoriteProfessors(allProfessors);
      return favoriteProfessors.take(3).toList(); // Solo los 3 más recientes
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, String>> _loadProfessorNames() async {
    try {
      final allProfessors = await HybridDataService.getAllProfessors();
      final Map<String, String> names = {};
      for (final professor in allProfessors) {
        names[professor.id] = professor.name;
      }
      return names;
    } catch (e) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.currentUser;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header con gradiente
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryOrange, AppColors.primaryGold],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Mi Perfil',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Contenido del perfil
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryOrange,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadUserData,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Información del usuario
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Avatar del usuario
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColors.primaryOrange,
                                    backgroundImage: currentUser?.photoURL != null
                                        ? NetworkImage(currentUser!.photoURL!)
                                        : null,
                                    child: currentUser?.photoURL == null
                                        ? const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: AppColors.textLight,
                                          )
                                        : null,
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  Text(
                                    currentUser?.displayName ?? 'Usuario',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  
                                  Text(
                                    currentUser?.email ?? 'usuario@ulima.edu.pe',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Estadísticas del usuario
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildStatCard('Reseñas', _totalReviews.toString()),
                                      _buildStatCard('Favoritos', _totalFavorites.toString()),
                                      _buildStatCard('Siguiendo', '12'),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Sección de reseñas recientes
                                  if (_recentReviews.isNotEmpty) ...[
                                    _buildSectionHeader('Reseñas Recientes', Icons.rate_review),
                                    const SizedBox(height: 12),
                                    ..._recentReviews.map((review) => _buildRecentReviewCard(review)),
                                    const SizedBox(height: 16),
                                  ],
                                  
                                  // Sección de favoritos recientes
                                  if (_recentFavorites.isNotEmpty) ...[
                                    _buildSectionHeader('Favoritos Recientes', Icons.favorite),
                                    const SizedBox(height: 12),
                                    ..._recentFavorites.map((professor) => _buildRecentFavoriteCard(professor)),
                                    const SizedBox(height: 16),
                                  ],
                                  
                                  // Opciones del menú
                                  _buildMenuOption(
                                    icon: Icons.favorite_border,
                                    title: 'Profesores Favoritos',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const FavoriteProfessorsScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildMenuOption(
                                    icon: Icons.history,
                                    title: 'Mis Reseñas',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const MyReviewsScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildMenuOption(
                                    icon: Icons.settings,
                                    title: 'Configuración',
                                    onTap: () {},
                                  ),
                                  _buildMenuOption(
                                    icon: Icons.help_outline,
                                    title: 'Ayuda y Soporte',
                                    onTap: () {},
                                  ),
                                  _buildMenuOption(
                                    icon: Icons.logout,
                                    title: 'Cerrar Sesión',
                                    onTap: () {
                                      // Mostrar diálogo de confirmación
                                      _showLogoutDialog(context);
                                    },
                                    isLogout: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryOrange, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentReviewCard(Review review) {
    final professorName = _professorNames[review.professorId] ?? 'Profesor desconocido';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  professorName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < review.rating ? Icons.star : Icons.star_border,
                        color: AppColors.star,
                        size: 14,
                      );
                    }),
                    const SizedBox(width: 8),
                    Text(
                      '${review.rating}/5',
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
          Text(
            _formatDate(review.createdAt),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentFavoriteCard(Professor professor) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfessorProfileScreen(professor: professor),
          ),
        );
        if (result == true) {
          _loadUserData();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.lightGray),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryOrange,
              backgroundImage: professor.photoUrl != null
                  ? NetworkImage(professor.photoUrl!)
                  : null,
              child: professor.photoUrl == null
                  ? const Icon(
                      Icons.person,
                      size: 20,
                      color: AppColors.textLight,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professor.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    professor.department,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.favorite,
              color: AppColors.primaryOrange,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Fecha desconocida';
    }
    
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

  /// Mostrar diálogo de confirmación para cerrar sesión
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Cerrar Sesión',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: const Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppColors.mediumGray),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                navigator.pop();
                
                try {
                  // Mostrar indicador de carga
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Cerrando sesión...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  
                  // Cerrar sesión usando AuthService
                  await AuthService.signOut();
                  
                  // Limpiar la pila de navegación y navegar al login
                  navigator.pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Error al cerrar sesión: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : AppColors.primaryOrange,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : AppColors.textPrimary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isLogout ? Colors.red : AppColors.mediumGray,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.white,
      ),
    );
  }
}
