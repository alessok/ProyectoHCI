import 'package:flutter_test/flutter_test.dart';
import 'package:professor_ranking_app/models/professor.dart';

void main() {
  group('Basic Professor Model Tests', () {
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
    });
  });
}
