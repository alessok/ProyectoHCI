import '../models/professor.dart';
import '../models/user.dart';

/// Servicio que proporciona datos falsos para desarrollo y testing
class MockDataService {
  // Lista de profesores ficticios con datos realistas de Ulima
  static final List<Professor> _professors = [
    Professor(
      id: '1',
      name: 'Dr. Carlos Mendoza',
      department: 'Ing. de Sistemas',
      courses: ['Programación I', 'Algoritmos', 'Base de Datos'],
      averageRating: 4.8,
      totalReviews: 126,
      photoUrl: null,
      bio: 'Doctor en Ciencias de la Computación con 15 años de experiencia en desarrollo de software y bases de datos.',
    ),
    Professor(
      id: '2',
      name: 'Mg. Ana García',
      department: 'Ing. Industrial',
      courses: ['Investigación Operativa', 'Estadística'],
      averageRating: 4.5,
      totalReviews: 89,
      photoUrl: null,
      bio: 'Magíster en Ingeniería Industrial, especialista en optimización de procesos y análisis estadístico.',
    ),
    Professor(
      id: '3',
      name: 'Prof. Hernan Quintana',
      department: 'Ing. Sistemas',
      courses: ['Programación Avanzada', 'Desarrollo Mobile'],
      averageRating: 4.0,
      totalReviews: 332,
      photoUrl: null,
      bio: 'Profesor con experiencia en desarrollo de aplicaciones móviles y programación avanzada.',
    ),
    Professor(
      id: '4',
      name: 'Arq. María López',
      department: 'Arquitectura',
      courses: ['Diseño Arquitectónico', 'Urbanismo', 'Historia de la Arquitectura'],
      averageRating: 4.7,
      totalReviews: 95,
      photoUrl: null,
      bio: 'Arquitecta con maestría en Urbanismo, especializada en diseño sostenible y planificación urbana.',
    ),
    Professor(
      id: '5',
      name: 'Dr. Pedro Rodríguez',
      department: 'Medicina',
      courses: ['Anatomía', 'Fisiología', 'Patología'],
      averageRating: 4.2,
      totalReviews: 134,
      photoUrl: null,
      bio: 'Doctor en Medicina con especialización en Patología, con 20 años de experiencia docente.',
    ),
    Professor(
      id: '6',
      name: 'Mg. Laura Herrera',
      department: 'Ing. de Sistemas',
      courses: ['Desarrollo Web', 'Mobile Development', 'UX/UI'],
      averageRating: 4.9,
      totalReviews: 67,
      photoUrl: null,
      bio: 'Magíster en Tecnologías de la Información, especialista en desarrollo frontend y experiencia de usuario.',
    ),
    Professor(
      id: '7',
      name: 'Dr. Jorge Vargas',
      department: 'Ing. Industrial',
      courses: ['Gestión de Calidad', 'Lean Manufacturing', 'Six Sigma'],
      averageRating: 4.4,
      totalReviews: 112,
      photoUrl: null,
      bio: 'Doctor en Ingeniería Industrial, consultor en mejora de procesos y sistemas de gestión de calidad.',
    ),
    Professor(
      id: '8',
      name: 'Mg. Carmen Flores',
      department: 'Arquitectura',
      courses: ['Construcción', 'Materiales', 'Costos y Presupuestos'],
      averageRating: 4.1,
      totalReviews: 56,
      photoUrl: null,
      bio: 'Magíster en Gestión de la Construcción, con experiencia en dirección de obras y estimación de costos.',
    ),
    Professor(
      id: '9',
      name: 'Dr. Miguel Santos',
      department: 'Ing. Civil',
      courses: ['Hidráulica', 'Ingeniería Sanitaria', 'Recursos Hídricos'],
      averageRating: 4.6,
      totalReviews: 83,
      photoUrl: null,
      bio: 'Doctor en Ingeniería Hidráulica, especialista en gestión de recursos hídricos y tratamiento de aguas.',
    ),
    Professor(
      id: '10',
      name: 'Dra. Patricia Morales',
      department: 'Medicina',
      courses: ['Farmacología', 'Toxicología', 'Medicina Interna'],
      averageRating: 4.5,
      totalReviews: 91,
      photoUrl: null,
      bio: 'Doctora en Medicina con especialización en Farmacología Clínica y 18 años de experiencia médica.',
    ),
  ];

  // Comentarios y reseñas ficticias
  static final Map<String, List<Review>> _reviews = {
    '3': [ // Hernan Quintana
      Review(
        id: 'r1',
        userId: 'u1',
        userName: 'Juan Pérez',
        rating: 4,
        comment: 'Fomenta la participación activa con preguntas y discusiones, creando un ambiente dinámico. Además, fundamenta sus clases en fuentes confiables, promoviendo el pensamiento crítico.',
        date: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Review(
        id: 'r2',
        userId: 'u2',
        userName: 'María González',
        rating: 5,
        comment: 'Excelente profesor, muy dinámico en sus clases. Siempre está actualizado con las últimas tecnologías.',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Review(
        id: 'r3',
        userId: 'u3',
        userName: 'Carlos Ruiz',
        rating: 3,
        comment: 'Buen profesor, aunque a veces es muy exigente. Sus proyectos son desafiantes pero educativos.',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ],
    '1': [
      Review(
        id: 'r4',
        userId: 'u1',
        userName: 'Ana Torres',
        rating: 5,
        comment: 'Excelente profesor, explica muy bien los conceptos de programación. Sus clases son dinámicas y siempre está dispuesto a ayudar.',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Review(
        id: 'r5',
        userId: 'u2',
        userName: 'Luis Mendoza',
        rating: 4,
        comment: 'Muy buen profesor, aunque a veces va un poco rápido. Los proyectos que asigna son muy útiles para aprender.',
        date: DateTime.now().subtract(const Duration(days: 8)),
      ),
    ],
  };

  // Usuarios ficticios
  static final List<User> _users = [
    User(
      id: 'u1',
      name: 'Juan Pérez',
      email: 'juan.perez@ulima.edu.pe',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    User(
      id: 'u2',
      name: 'María González',
      email: 'maria.gonzalez@ulima.edu.pe',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    User(
      id: 'u3',
      name: 'Carlos Ruiz',
      email: 'carlos.ruiz@ulima.edu.pe',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
  ];

  /// Obtiene todos los profesores
  static List<Professor> getAllProfessors() {
    return List.from(_professors);
  }

  /// Obtiene profesores por departamento
  static List<Professor> getProfessorsByDepartment(String department) {
    if (department == 'All') return getAllProfessors();
    return _professors.where((prof) => prof.department == department).toList();
  }

  /// Obtiene profesores favoritos (los mejor calificados)
  static List<Professor> getFavoriteProfessors({int limit = 5}) {
    final sorted = List<Professor>.from(_professors);
    sorted.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return sorted.take(limit).toList();
  }

  /// Obtiene top profesores (por número de reseñas)
  static List<Professor> getTopProfessors({int limit = 5}) {
    final sorted = List<Professor>.from(_professors);
    sorted.sort((a, b) => b.totalReviews.compareTo(a.totalReviews));
    return sorted.take(limit).toList();
  }

  /// Busca profesores por nombre o departamento
  static List<Professor> searchProfessors(String query) {
    if (query.isEmpty) return getAllProfessors();
    
    final lowerQuery = query.toLowerCase();
    return _professors.where((prof) {
      return prof.name.toLowerCase().contains(lowerQuery) ||
             prof.department.toLowerCase().contains(lowerQuery) ||
             prof.courses.any((course) => course.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Obtiene un profesor por ID
  static Professor? getProfessorById(String id) {
    try {
      return _professors.firstWhere((prof) => prof.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene reseñas de un profesor en formato Map
  static List<Map<String, dynamic>> getReviewsForProfessor(String professorId) {
    final reviews = _reviews[professorId] ?? [];
    return reviews.map((review) => {
      'id': review.id,
      'userId': review.userId,
      'userName': review.userName,
      'rating': review.rating,
      'comment': review.comment,
      'date': review.date,
    }).toList();
  }

  /// Obtiene la distribución de ratings para un profesor
  static Map<int, int> getRatingDistribution(String professorId) {
    final reviews = _reviews[professorId] ?? [];
    final distribution = <int, int>{
      1: 0, 2: 0, 3: 0, 4: 0, 5: 0,
    };
    
    for (final review in reviews) {
      distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
    }
    
    return distribution;
  }

  /// Verifica si un profesor está en favoritos
  static bool isFavoriteProfessor(String professorId) {
    // Simulamos que algunos profesores están en favoritos
    final favoriteIds = ['1', '4', '7'];
    return favoriteIds.contains(professorId);
  }

  /// Obtiene todos los departamentos únicos
  static List<String> getAllDepartments() {
    final departments = _professors.map((prof) => prof.department).toSet().toList();
    departments.sort();
    return ['All', ...departments];
  }

  /// Obtiene usuario actual (simulado)
  static User getCurrentUser() {
    return _users.first;
  }

  /// Agrega una nueva reseña a un profesor
  static void addReviewToProfessor({
    required String professorId,
    required String userId,
    required String userName,
    required int rating,
    required String comment,
  }) {
    final newReview = Review(
      id: 'review_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      userName: userName,
      rating: rating,
      comment: comment,
      date: DateTime.now(),
    );

    if (_reviews[professorId] == null) {
      _reviews[professorId] = [];
    }
    _reviews[professorId]!.insert(0, newReview); // Agregar al inicio

    // Actualizar el rating promedio del profesor
    final professorIndex = _professors.indexWhere((p) => p.id == professorId);
    if (professorIndex != -1) {
      final professor = _professors[professorIndex];
      final allReviews = _reviews[professorId]!;
      final totalRating = allReviews.fold(0, (sum, review) => sum + review.rating);
      final newAverage = totalRating / allReviews.length;
      
      _professors[professorIndex] = Professor(
        id: professor.id,
        name: professor.name,
        department: professor.department,
        courses: professor.courses,
        averageRating: newAverage,
        totalReviews: allReviews.length,
        photoUrl: professor.photoUrl,
        bio: professor.bio,
      );
    }
  }
}

/// Clase para representar una reseña
class Review {
  final String id;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
