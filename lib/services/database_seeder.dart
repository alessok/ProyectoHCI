import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/professor.dart';
import 'mock_data_service.dart';
import 'logger_service.dart';

/// Servicio para poblar la base de datos con datos reales de la Universidad de Lima
class DatabaseSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Migrar datos reales de la universidad a Firebase
  static Future<void> migrateUniversityData() async {
    try {
      await _migrateDepartments();
      await _migrateProfessors();
      LoggerService.info('Migración de datos de la Universidad de Lima completada exitosamente');
    } catch (e) {
      LoggerService.error(
        'Error al migrar datos',
        data: e,
      );
    }
  }
  
  /// Migrar departamentos
  static Future<void> _migrateDepartments() async {
    final departments = MockDataService.getAllDepartments()
        .where((dept) => dept != 'All')
        .toList();
    
    final batch = _firestore.batch();
    
    for (final department in departments) {
      final docRef = _firestore.collection('departments').doc();
      batch.set(docRef, {
        'name': department,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    
    await batch.commit();
    LoggerService.info('Departamentos migrados: ${departments.length}');
  }
  
  /// Migrar profesores con datos reales
  static Future<void> _migrateProfessors() async {
    final professors = MockDataService.getAllProfessors();
    final batch = _firestore.batch();
    
    for (final professor in professors) {
      // Generar keywords de búsqueda
      final searchKeywords = _generateSearchKeywords(professor);
      
      // Crear profesor con keywords
      final professorWithKeywords = professor.copyWith(
        searchKeywords: searchKeywords,
      );
      
      // Usar el ID original del profesor
      final docRef = _firestore.collection('professors').doc(professor.id);
      batch.set(docRef, professorWithKeywords.toFirestore());
    }
    
    await batch.commit();
    LoggerService.info('Profesores migrados: ${professors.length}');
  }
  
  /// Generar keywords de búsqueda para un profesor
  static List<String> _generateSearchKeywords(Professor professor) {
    final keywords = <String>[];
    
    // Agregar nombre en diferentes formatos
    final nameParts = professor.name.toLowerCase().split(' ');
    keywords.addAll(nameParts);
    keywords.add(professor.name.toLowerCase());
    
    // Agregar departamento
    keywords.add(professor.department.toLowerCase());
    
    // Agregar cursos
    for (final course in professor.courses) {
      final courseParts = course.toLowerCase().split(' ');
      keywords.addAll(courseParts);
      keywords.add(course.toLowerCase());
    }
    
    // Agregar bio si existe
    if (professor.bio != null) {
      final bioParts = professor.bio!.toLowerCase().split(' ');
      keywords.addAll(bioParts.take(10)); // Solo las primeras 10 palabras
    }
    
    // Agregar keywords específicos de la Universidad de Lima
    keywords.addAll([
      'ulima',
      'universidad de lima',
      'ingeniería',
      'sistemas',
      'profesor',
      'docente',
    ]);
    
    return keywords.toSet().toList(); // Eliminar duplicados
  }
  
  /// Migrar reseñas mock existentes (opcional)
  static Future<void> migrateMockReviews() async {
    try {
      final professors = MockDataService.getAllProfessors();
      final batch = _firestore.batch();
      
      for (final professor in professors) {
        final mockReviewsData = MockDataService.getReviewsForProfessor(professor.id);
        
        for (final reviewData in mockReviewsData) {
          final docRef = _firestore.collection('reviews').doc();
          batch.set(docRef, {
            'userId': reviewData['userId'],
            'userName': reviewData['userName'],
            'professorId': professor.id,
            'rating': reviewData['rating'],
            'comment': reviewData['comment'],
            'date': Timestamp.fromDate(reviewData['date']),
            'isMockData': true, // Marcar como datos mock
          });
        }
      }
      
      await batch.commit();
      LoggerService.info('Reseñas mock migradas exitosamente');
    } catch (e) {
      LoggerService.error(
        'Error al migrar reseñas mock',
        data: e,
      );
    }
  }
  
  /// Limpiar todos los datos (solo para desarrollo)
  static Future<void> clearAllData() async {
    try {
      // Limpiar profesores
      final professorsSnapshot = await _firestore.collection('professors').get();
      final batch1 = _firestore.batch();
      for (final doc in professorsSnapshot.docs) {
        batch1.delete(doc.reference);
      }
      await batch1.commit();
      
      // Limpiar departamentos
      final departmentsSnapshot = await _firestore.collection('departments').get();
      final batch2 = _firestore.batch();
      for (final doc in departmentsSnapshot.docs) {
        batch2.delete(doc.reference);
      }
      await batch2.commit();
      
      // Limpiar reseñas
      final reviewsSnapshot = await _firestore.collection('reviews').get();
      final batch3 = _firestore.batch();
      for (final doc in reviewsSnapshot.docs) {
        batch3.delete(doc.reference);
      }
      await batch3.commit();
      
      // Limpiar favoritos
      final favoritesSnapshot = await _firestore.collection('userFavorites').get();
      final batch4 = _firestore.batch();
      for (final doc in favoritesSnapshot.docs) {
        batch4.delete(doc.reference);
      }
      await batch4.commit();
      
      LoggerService.info('Todos los datos han sido eliminados');
    } catch (e) {
      LoggerService.error(
        'Error al limpiar datos',
        data: e,
      );
    }
  }
  
  /// Verificar si los datos ya están migrados
  static Future<bool> isDataMigrated() async {
    try {
      final professorsSnapshot = await _firestore.collection('professors').limit(1).get();
      return professorsSnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  /// Obtener estadísticas de la migración
  static Future<Map<String, int>> getMigrationStats() async {
    try {
      final professorsSnapshot = await _firestore.collection('professors').get();
      final departmentsSnapshot = await _firestore.collection('departments').get();
      final reviewsSnapshot = await _firestore.collection('reviews').get();
      
      return {
        'professors': professorsSnapshot.docs.length,
        'departments': departmentsSnapshot.docs.length,
        'reviews': reviewsSnapshot.docs.length,
      };
    } catch (e) {
      return {
        'professors': 0,
        'departments': 0,
        'reviews': 0,
      };
    }
  }

  /// Poblar la base de datos con datos de ejemplo
  static Future<void> seedDatabase() async {
    LoggerService.info('Iniciando población de base de datos...');
    
    try {
      // Crear usuarios de ejemplo
      await _createSampleUsers();
      
      // Crear profesores de ejemplo
      await _createSampleProfessors();
      
      // Crear reviews de ejemplo
      await _createSampleReviews();
      
      LoggerService.info('Base de datos poblada exitosamente');
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error al poblar la base de datos',
        data: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Crear usuarios de ejemplo
  static Future<void> _createSampleUsers() async {
    LoggerService.info('Creando usuarios de ejemplo...');
    
    final users = [
      {
        'id': 'user1',
        'name': 'Ana García',
        'email': 'ana.garcia@example.com',
        'role': 'student',
        'university': 'Universidad Nacional',
        'createdAt': DateTime.now(),
      },
      {
        'id': 'user2',
        'name': 'Carlos López',
        'email': 'carlos.lopez@example.com',
        'role': 'student',
        'university': 'Universidad Nacional',
        'createdAt': DateTime.now(),
      },
      {
        'id': 'user3',
        'name': 'María Rodríguez',
        'email': 'maria.rodriguez@example.com',
        'role': 'student',
        'university': 'Universidad Nacional',
        'createdAt': DateTime.now(),
      },
    ];

    for (final userData in users) {
      try {
        // Crear usuario en Firestore directamente
        await FirebaseFirestore.instance.collection('users').doc(userData['id'] as String).set(userData);
      } catch (e) {
        LoggerService.warning('Usuario ya existe: ${userData['email']}');
      }
    }
  }

  /// Crear profesores de ejemplo
  static Future<void> _createSampleProfessors() async {
    LoggerService.info('Creando profesores de ejemplo...');
    
    final professors = [
      {
        'id': 'prof1',
        'name': 'Dr. Juan Pérez',
        'department': 'Ingeniería de Sistemas',
        'university': 'Universidad Nacional',
        'email': 'juan.perez@universidad.edu.co',
        'phone': '+57 300 123 4567',
        'office': 'Edificio A, Oficina 301',
        'bio': 'Especialista en algoritmos y estructuras de datos con más de 15 años de experiencia.',
        'expertise': ['Algoritmos', 'Estructuras de Datos', 'Programación'],
        'rating': 4.5,
        'totalReviews': 25,
        'imageUrl': 'https://example.com/prof1.jpg',
        'createdAt': DateTime.now(),
      },
      {
        'id': 'prof2',
        'name': 'Dra. Laura Martínez',
        'department': 'Matemáticas',
        'university': 'Universidad Nacional',
        'email': 'laura.martinez@universidad.edu.co',
        'phone': '+57 300 234 5678',
        'office': 'Edificio B, Oficina 205',
        'bio': 'Matemática con especialización en análisis numérico y optimización.',
        'expertise': ['Análisis Numérico', 'Optimización', 'Cálculo'],
        'rating': 4.8,
        'totalReviews': 32,
        'imageUrl': 'https://example.com/prof2.jpg',
        'createdAt': DateTime.now(),
      },
      {
        'id': 'prof3',
        'name': 'Dr. Roberto Silva',
        'department': 'Física',
        'university': 'Universidad Nacional',
        'email': 'roberto.silva@universidad.edu.co',
        'phone': '+57 300 345 6789',
        'office': 'Edificio C, Oficina 102',
        'bio': 'Físico teórico especializado en mecánica cuántica y relatividad.',
        'expertise': ['Mecánica Cuántica', 'Relatividad', 'Física Teórica'],
        'rating': 4.2,
        'totalReviews': 18,
        'imageUrl': 'https://example.com/prof3.jpg',
        'createdAt': DateTime.now(),
      },
    ];

    for (final profData in professors) {
      try {
        // Crear profesor en Firestore directamente
        await FirebaseFirestore.instance.collection('professors').doc(profData['id'] as String).set(profData);
      } catch (e) {
        LoggerService.warning('Profesor ya existe: ${profData['email']}');
      }
    }
  }

  /// Crear reviews de ejemplo
  static Future<void> _createSampleReviews() async {
    LoggerService.info('Creando reviews de ejemplo...');
    
    final reviews = [
      {
        'id': 'review1',
        'professorId': 'prof1',
        'userId': 'user1',
        'userName': 'Ana García',
        'userEmail': 'ana.garcia@example.com',
        'rating': 5.0,
        'comment': 'Excelente profesor, explica muy bien los conceptos complejos de algoritmos.',
        'course': 'Algoritmos y Estructuras de Datos',
        'semester': '2024-1',
        'createdAt': DateTime.now().subtract(const Duration(days: 5)),
        'updatedAt': DateTime.now().subtract(const Duration(days: 5)),
        'likes': 3,
        'dislikes': 0,
      },
      {
        'id': 'review2',
        'professorId': 'prof1',
        'userId': 'user2',
        'userName': 'Carlos López',
        'userEmail': 'carlos.lopez@example.com',
        'rating': 4.0,
        'comment': 'Buen profesor, pero las tareas son muy difíciles.',
        'course': 'Algoritmos y Estructuras de Datos',
        'semester': '2024-1',
        'createdAt': DateTime.now().subtract(const Duration(days: 3)),
        'updatedAt': DateTime.now().subtract(const Duration(days: 3)),
        'likes': 1,
        'dislikes': 1,
      },
      {
        'id': 'review3',
        'professorId': 'prof2',
        'userId': 'user1',
        'userName': 'Ana García',
        'userEmail': 'ana.garcia@example.com',
        'rating': 5.0,
        'comment': 'La mejor profesora de matemáticas que he tenido.',
        'course': 'Análisis Numérico',
        'semester': '2023-2',
        'createdAt': DateTime.now().subtract(const Duration(days: 10)),
        'updatedAt': DateTime.now().subtract(const Duration(days: 10)),
        'likes': 5,
        'dislikes': 0,
      },
    ];

    for (final reviewData in reviews) {
      try {
        // Crear review en Firestore directamente
        await FirebaseFirestore.instance.collection('reviews').doc(reviewData['id'] as String).set(reviewData);
      } catch (e) {
        LoggerService.warning('Review ya existe: ${reviewData['id']}');
      }
    }
  }
} 