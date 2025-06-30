import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo para representar un profesor
class Professor {
  final String id;
  final String name;
  final String department;
  final String? photoUrl;
  final List<String> courses;
  final double averageRating;
  final int totalReviews;
  final String? bio;
  final List<String> searchKeywords;

  Professor({
    required this.id,
    required this.name,
    required this.department,
    this.photoUrl,
    required this.courses,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.bio,
    this.searchKeywords = const [],
  });
  
  /// Retorna el nombre formateado con nombres primero y apellidos después
  String get formattedName {
    // Verificar si el nombre está en formato "Apellidos Nombres"
    final parts = name.split(' ');
    
    // Si tiene menos de 3 partes, probablemente es un formato simple
    if (parts.length < 3) return name;
    
    // Analizamos el nombre en el formato peruano común: "Apellido1 Apellido2 Nombre1 Nombre2..."
    // Donde los primeros dos elementos son apellidos
    String apellidos = '';
    String nombres = '';
    
    // Para profesores con formato "Apellido1 Apellido2 Nombre1 Nombre2..."
    if (parts.length >= 3) {
      // Los dos primeros son apellidos
      apellidos = parts.take(2).join(' ');
      // El resto son nombres
      nombres = parts.skip(2).join(' ');
      
      // Invertimos el orden: primero nombres y luego apellidos
      return '$nombres $apellidos';
    }
    
    return name; // Fallback al nombre original si algo falla
  }

  /// Crear Professor desde Firestore DocumentSnapshot
  factory Professor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Professor(
      id: doc.id,
      name: data['name'] ?? '',
      department: data['department'] ?? '',
      photoUrl: data['photoUrl'],
      courses: List<String>.from(data['courses'] ?? []),
      averageRating: (data['averageRating'] ?? 0.0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      bio: data['bio'],
      searchKeywords: List<String>.from(data['searchKeywords'] ?? []),
    );
  }

  /// Crear Professor desde JSON
  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      department: json['department'] ?? '',
      photoUrl: json['photoUrl'],
      courses: List<String>.from(json['courses'] ?? []),
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      bio: json['bio'],
      searchKeywords: List<String>.from(json['searchKeywords'] ?? []),
    );
  }

  /// Convertir Professor a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'photoUrl': photoUrl,
      'courses': courses,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'bio': bio,
      'searchKeywords': searchKeywords,
    };
  }

  /// Convertir Professor a Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'department': department,
      'photoUrl': photoUrl,
      'courses': courses,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'bio': bio,
      'searchKeywords': searchKeywords,
    };
  }

  /// Crear copia del profesor con campos modificados
  Professor copyWith({
    String? id,
    String? name,
    String? department,
    Object? photoUrl = _notProvided,
    List<String>? courses,
    double? averageRating,
    int? totalReviews,
    Object? bio = _notProvided,
    List<String>? searchKeywords,
  }) {
    return Professor(
      id: id ?? this.id,
      name: name ?? this.name,
      department: department ?? this.department,
      photoUrl: photoUrl == _notProvided ? this.photoUrl : photoUrl as String?,
      courses: courses ?? this.courses,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      bio: bio == _notProvided ? this.bio : bio as String?,
      searchKeywords: searchKeywords ?? this.searchKeywords,
    );
  }

  @override
  String toString() {
    return 'Professor{id: $id, name: $name, department: $department, averageRating: $averageRating}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Professor &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Objeto centinela para diferenciar entre null y "no proporcionado"
const Object _notProvided = Object();
