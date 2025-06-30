import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo para representar una reseña de profesor
class Review {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String professorId;
  final double rating;
  final String comment;
  final String course;
  final String semester;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likes;
  final int dislikes;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.professorId,
    required this.rating,
    required this.comment,
    required this.course,
    required this.semester,
    required this.createdAt,
    required this.updatedAt,
    this.likes = 0,
    this.dislikes = 0,
  });

  /// Crear Review desde Firestore DocumentSnapshot
  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Review(
      id: data['id'] ?? doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      professorId: data['professorId'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'] ?? '',
      course: data['course'] ?? '',
      semester: data['semester'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: data['likes'] ?? 0,
      dislikes: data['dislikes'] ?? 0,
    );
  }

  /// Crear Review desde JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      professorId: json['professorId'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      course: json['course'] ?? '',
      semester: json['semester'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }

  /// Convertir Review a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'professorId': professorId,
      'rating': rating,
      'comment': comment,
      'course': course,
      'semester': semester,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'likes': likes,
      'dislikes': dislikes,
    };
  }

  /// Convertir Review a Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'professorId': professorId,
      'rating': rating,
      'comment': comment,
      'course': course,
      'semester': semester,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'likes': likes,
      'dislikes': dislikes,
    };
  }

  /// Crear copia de la reseña con campos modificados
  Review copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? professorId,
    double? rating,
    String? comment,
    String? course,
    String? semester,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likes,
    int? dislikes,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      professorId: professorId ?? this.professorId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      course: course ?? this.course,
      semester: semester ?? this.semester,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
    );
  }

  /// Obtener el rating como entero (para compatibilidad)
  int get ratingAsInt => rating.round();

  /// Obtener la fecha formateada
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} día${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} hora${difference.inHours == 1 ? '' : 's'}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minuto${difference.inMinutes == 1 ? '' : 's'}';
    } else {
      return 'Ahora mismo';
    }
  }

  @override
  String toString() {
    return 'Review{id: $id, userId: $userId, userName: $userName, professorId: $professorId, rating: $rating, comment: $comment, course: $course, semester: $semester}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Review &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
