/// Modelo para representar una reseña de profesor
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

  /// Crear Review desde JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convertir Review a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  /// Crear copia de la reseña con campos modificados
  Review copyWith({
    String? id,
    String? userId,
    String? userName,
    int? rating,
    String? comment,
    DateTime? date,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'Review{id: $id, userId: $userId, userName: $userName, rating: $rating, comment: $comment, date: $date}';
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
