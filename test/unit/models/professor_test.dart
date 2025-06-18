import 'package:flutter_test/flutter_test.dart';
import 'package:professor_ranking_app/models/professor.dart';

void main() {
  group('Professor Model Tests', () {
    
    group('Constructor', () {
      test('should create Professor with required parameters', () {
        // Arrange & Act
        final professor = Professor(
          id: '1',
          name: 'Dr. Test Professor',
          department: 'Ing. Sistemas',
          courses: ['Programación I', 'Algoritmos'],
        );

        // Assert
        expect(professor.id, equals('1'));
        expect(professor.name, equals('Dr. Test Professor'));
        expect(professor.department, equals('Ing. Sistemas'));
        expect(professor.courses, equals(['Programación I', 'Algoritmos']));
        expect(professor.averageRating, equals(0.0));
        expect(professor.totalReviews, equals(0));
        expect(professor.photoUrl, isNull);
        expect(professor.bio, isNull);
      });

      test('should create Professor with all parameters', () {
        // Arrange & Act
        final professor = Professor(
          id: '1',
          name: 'Dr. Test Professor',
          department: 'Ing. Sistemas',
          courses: ['Programación I'],
          averageRating: 4.5,
          totalReviews: 10,
          photoUrl: 'https://example.com/photo.jpg',
          bio: 'Test bio',
        );

        // Assert
        expect(professor.averageRating, equals(4.5));
        expect(professor.totalReviews, equals(10));
        expect(professor.photoUrl, equals('https://example.com/photo.jpg'));
        expect(professor.bio, equals('Test bio'));
      });
    });

    group('fromJson', () {
      test('should create Professor from complete JSON', () {
        // Arrange
        final json = {
          'id': '1',
          'name': 'Dr. Test Professor',
          'department': 'Ing. Sistemas',
          'courses': ['Programación I', 'Algoritmos'],
          'averageRating': 4.5,
          'totalReviews': 10,
          'photoUrl': 'https://example.com/photo.jpg',
          'bio': 'Test bio',
        };

        // Act
        final professor = Professor.fromJson(json);

        // Assert
        expect(professor.id, equals('1'));
        expect(professor.name, equals('Dr. Test Professor'));
        expect(professor.department, equals('Ing. Sistemas'));
        expect(professor.courses, equals(['Programación I', 'Algoritmos']));
        expect(professor.averageRating, equals(4.5));
        expect(professor.totalReviews, equals(10));
        expect(professor.photoUrl, equals('https://example.com/photo.jpg'));
        expect(professor.bio, equals('Test bio'));
      });

      test('should create Professor from minimal JSON', () {
        // Arrange
        final json = {
          'id': '1',
          'name': 'Dr. Test Professor',
          'department': 'Ing. Sistemas',
        };

        // Act
        final professor = Professor.fromJson(json);

        // Assert
        expect(professor.id, equals('1'));
        expect(professor.name, equals('Dr. Test Professor'));
        expect(professor.department, equals('Ing. Sistemas'));
        expect(professor.courses, isEmpty);
        expect(professor.averageRating, equals(0.0));
        expect(professor.totalReviews, equals(0));
        expect(professor.photoUrl, isNull);
        expect(professor.bio, isNull);
      });

      test('should handle null and missing values in JSON', () {
        // Arrange
        final json = {
          'id': null,
          'name': null,
          'department': null,
          'courses': null,
          'averageRating': null,
          'totalReviews': null,
          'photoUrl': null,
          'bio': null,
        };

        // Act
        final professor = Professor.fromJson(json);

        // Assert
        expect(professor.id, equals(''));
        expect(professor.name, equals(''));
        expect(professor.department, equals(''));
        expect(professor.courses, isEmpty);
        expect(professor.averageRating, equals(0.0));
        expect(professor.totalReviews, equals(0));
        expect(professor.photoUrl, isNull);
        expect(professor.bio, isNull);
      });

      test('should handle numeric rating as int', () {
        // Arrange
        final json = {
          'id': '1',
          'name': 'Test',
          'department': 'Test',
          'courses': [],
          'averageRating': 4, // int instead of double
          'totalReviews': 10,
        };

        // Act
        final professor = Professor.fromJson(json);

        // Assert
        expect(professor.averageRating, equals(4.0));
        expect(professor.averageRating, isA<double>());
      });
    });

    group('toJson', () {
      test('should convert Professor to JSON', () {
        // Arrange
        final professor = Professor(
          id: '1',
          name: 'Dr. Test Professor',
          department: 'Ing. Sistemas',
          courses: ['Programación I', 'Algoritmos'],
          averageRating: 4.5,
          totalReviews: 10,
          photoUrl: 'https://example.com/photo.jpg',
          bio: 'Test bio',
        );

        // Act
        final json = professor.toJson();

        // Assert
        expect(json, equals({
          'id': '1',
          'name': 'Dr. Test Professor',
          'department': 'Ing. Sistemas',
          'courses': ['Programación I', 'Algoritmos'],
          'averageRating': 4.5,
          'totalReviews': 10,
          'photoUrl': 'https://example.com/photo.jpg',
          'bio': 'Test bio',
        }));
      });

      test('should convert Professor with null values to JSON', () {
        // Arrange
        final professor = Professor(
          id: '1',
          name: 'Dr. Test Professor',
          department: 'Ing. Sistemas',
          courses: ['Programación I'],
        );

        // Act
        final json = professor.toJson();

        // Assert
        expect(json['photoUrl'], isNull);
        expect(json['bio'], isNull);
        expect(json['averageRating'], equals(0.0));
        expect(json['totalReviews'], equals(0));
      });
    });

    group('copyWith', () {
      test('should create copy with modified fields', () {
        // Arrange
        final original = Professor(
          id: '1',
          name: 'Dr. Test Professor',
          department: 'Ing. Sistemas',
          courses: ['Programación I'],
          averageRating: 4.0,
          totalReviews: 5,
        );

        // Act
        final copy = original.copyWith(
          name: 'Dr. Modified Professor',
          averageRating: 4.5,
          totalReviews: 10,
        );

        // Assert
        expect(copy.id, equals(original.id));
        expect(copy.name, equals('Dr. Modified Professor'));
        expect(copy.department, equals(original.department));
        expect(copy.courses, equals(original.courses));
        expect(copy.averageRating, equals(4.5));
        expect(copy.totalReviews, equals(10));
        expect(copy.photoUrl, equals(original.photoUrl));
        expect(copy.bio, equals(original.bio));
      });

      test('should create identical copy when no parameters provided', () {
        // Arrange
        final original = Professor(
          id: '1',
          name: 'Dr. Test Professor',
          department: 'Ing. Sistemas',
          courses: ['Programación I'],
          averageRating: 4.0,
          totalReviews: 5,
          photoUrl: 'test.jpg',
          bio: 'Test bio',
        );

        // Act
        final copy = original.copyWith();

        // Assert
        expect(copy.id, equals(original.id));
        expect(copy.name, equals(original.name));
        expect(copy.department, equals(original.department));
        expect(copy.courses, equals(original.courses));
        expect(copy.averageRating, equals(original.averageRating));
        expect(copy.totalReviews, equals(original.totalReviews));
        expect(copy.photoUrl, equals(original.photoUrl));
        expect(copy.bio, equals(original.bio));
      });

      test('should be able to set fields to null', () {
        // Arrange
        final original = Professor(
          id: '1',
          name: 'Dr. Test Professor',
          department: 'Ing. Sistemas',
          courses: ['Programación I'],
          photoUrl: 'test.jpg',
          bio: 'Test bio',
        );

        // Act
        final copy = original.copyWith(
          photoUrl: null,
          bio: null,
        );

        // Assert
        expect(copy.photoUrl, isNull);
        expect(copy.bio, isNull);
        expect(copy.name, equals(original.name)); // Other fields unchanged
      });
    });

    group('Validation', () {
      test('should have valid rating range', () {
        // Arrange & Act
        final professor1 = Professor(
          id: '1',
          name: 'Test',
          department: 'Test',
          courses: [],
          averageRating: 0.0,
        );

        final professor2 = Professor(
          id: '2',
          name: 'Test',
          department: 'Test',
          courses: [],
          averageRating: 5.0,
        );

        // Assert
        expect(professor1.averageRating, greaterThanOrEqualTo(0.0));
        expect(professor1.averageRating, lessThanOrEqualTo(5.0));
        expect(professor2.averageRating, greaterThanOrEqualTo(0.0));
        expect(professor2.averageRating, lessThanOrEqualTo(5.0));
      });

      test('should have non-negative review count', () {
        // Arrange & Act
        final professor = Professor(
          id: '1',
          name: 'Test',
          department: 'Test',
          courses: [],
          totalReviews: 0,
        );

        // Assert
        expect(professor.totalReviews, greaterThanOrEqualTo(0));
      });
    });

    group('Edge Cases', () {
      test('should handle empty courses list', () {
        // Arrange & Act
        final professor = Professor(
          id: '1',
          name: 'Test',
          department: 'Test',
          courses: [],
        );

        // Assert
        expect(professor.courses, isEmpty);
      });

      test('should handle very long strings', () {
        // Arrange
        final longString = 'a' * 1000;

        // Act
        final professor = Professor(
          id: '1',
          name: longString,
          department: longString,
          courses: [longString],
          bio: longString,
        );

        // Assert
        expect(professor.name, equals(longString));
        expect(professor.department, equals(longString));
        expect(professor.courses.first, equals(longString));
        expect(professor.bio, equals(longString));
      });

      test('should handle special characters', () {
        // Arrange & Act
        final professor = Professor(
          id: '1',
          name: 'Dr. José María Ñuñez-López',
          department: 'Ing. & Ciencias',
          courses: ['Álgebra Lineal', 'Cálculo ∑∫'],
        );

        // Assert
        expect(professor.name, equals('Dr. José María Ñuñez-López'));
        expect(professor.department, equals('Ing. & Ciencias'));
        expect(professor.courses, contains('Álgebra Lineal'));
        expect(professor.courses, contains('Cálculo ∑∫'));
      });
    });
  });
}
