import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/register_screen.dart';
import 'screens/search_screen.dart';
import 'screens/rating_completed_screen.dart';
import 'constants/colors.dart';
import 'constants/strings.dart';
import 'core/providers/professor_provider.dart';
import 'core/repositories/hybrid_professor_repository.dart';
import 'services/firebase_service.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await FirebaseService.initialize();
  
  // Inicializar AuthService
  await AuthService.initialize();
  
  runApp(const ProfessorRankingApp());
}

/// Aplicación principal para ranking de profesores
class ProfessorRankingApp extends StatelessWidget {
  const ProfessorRankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final provider = ProfessorProvider(HybridProfessorRepository());
            // Precargar datos para mejor performance
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.preloadData();
            });
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: NotificationService.messengerKey,
        theme: ThemeData(
          // Tema personalizado con colores de la Universidad de Lima
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryOrange,
            primary: AppColors.primaryOrange,
            secondary: AppColors.primaryGold,
          ),
          useMaterial3: true,
        
        // Configuración de AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: AppColors.textLight,
          elevation: 0,
          centerTitle: true,
        ),
        
        // Configuración de textos
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: AppColors.textPrimary),
          displayMedium: TextStyle(color: AppColors.textPrimary),
          displaySmall: TextStyle(color: AppColors.textPrimary),
          headlineLarge: TextStyle(color: AppColors.textPrimary),
          headlineMedium: TextStyle(color: AppColors.textPrimary),
          headlineSmall: TextStyle(color: AppColors.textPrimary),
          titleLarge: TextStyle(color: AppColors.textPrimary),
          titleMedium: TextStyle(color: AppColors.textPrimary),
          titleSmall: TextStyle(color: AppColors.textPrimary),
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textPrimary),
          bodySmall: TextStyle(color: AppColors.textSecondary),
        ),
        
        // Configuración de botones
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: AppColors.textLight,
          ),
        ),
      ),
        // Configuración de rutas nombradas
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/main': (context) => const MainNavigationScreen(),
          '/search': (context) => const SearchScreen(),
          '/rating-completed': (context) => const RatingCompletedScreen(),
        },
        home: const AuthWrapper(),
      ),
    );
  }
}

/// Widget que maneja la navegación basada en el estado de autenticación
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        // Mostrar loading mientras se verifica el estado de autenticación
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryOrange,
              ),
            ),
          );
        }
        
        // Si hay usuario autenticado, mostrar la pantalla principal
        if (snapshot.hasData && snapshot.data != null) {
          return const MainNavigationScreen();
        }
        
        // Si no hay usuario autenticado, mostrar la pantalla de login
        return const LoginScreen();
      },
    );
  }
}
