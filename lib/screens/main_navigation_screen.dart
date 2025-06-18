import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/session_service.dart';
import 'home_screen.dart'; // Cambio a la pantalla consolidada
import 'search_screen.dart';
import 'ranking_screen.dart';
import 'favorite_professors_screen.dart';
import 'my_reviews_screen.dart';

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

/// Pantalla de Perfil
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  /// Obtener iniciales del nombre
  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0][0].toUpperCase();
    }
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    // Obtener usuario actual de la sesión
    final currentUser = SessionService.getCurrentUser();
    
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Avatar y info del usuario
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGold,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(currentUser.name),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      currentUser.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    
                    Text(
                      currentUser.email,
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
                        _buildStatCard('Reseñas', '5'),
                        _buildStatCard('Favoritos', '8'),
                        _buildStatCard('Siguiendo', '12'),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
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
            ),
          ],
        ),
      ),
    );
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
              onPressed: () {
                Navigator.of(context).pop();
                // Cerrar sesión usando SessionService
                SessionService.logout();
                // Navegar de vuelta al login
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
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
