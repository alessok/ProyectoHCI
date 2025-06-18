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

  Professor({
    required this.id,
    required this.name,
    required this.department,
    this.photoUrl,
    required this.courses,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.bio,
  });

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
    );
  }
}

// Objeto centinela para diferenciar entre null y "no proporcionado"
const Object _notProvided = Object();
