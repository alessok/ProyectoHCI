import 'package:flutter_test/flutter_test.dart';
import 'package:professor_ranking_app/core/repositories/mock_professor_repository.dart';
import 'package:professor_ranking_app/models/professor.dart';

void main() {
  group('MockProfessorRepository Tests', () {
    late MockProfessorRepository repository;

    setUp(() {
      repository = MockProfessorRepository();
    });

    group('getAllProfessors', () {
      test('should return all professors', () async {
        // Act
        final professors = await repository.getAllProfessors();

        // Assert
        expect(professors, isNotEmpty);
        expect(professors, isA<List<Professor>>());
        expect(professors.every((p) => p.id.isNotEmpty), isTrue);
        expect(professors.every((p) => p.name.isNotEmpty), isTrue);
        expect(professors.every((p) => p.department.isNotEmpty), isTrue);
      });
    });

    group('getFavoriteProfessors', () {
      test('should return professors sorted by rating', () async {
        // Act
        final professors = await repository.getFavoriteProfessors();

        // Assert
        expect(professors, isNotEmpty);
        // Verificar que están ordenados por rating descendente
        for (int i = 0; i < professors.length - 1; i++) {
          expect(professors[i].averageRating, 
                 greaterThanOrEqualTo(professors[i + 1].averageRating));
        }
      });

      test('should respect limit parameter', () async {
        // Act
        final professors = await repository.getFavoriteProfessors(limit: 3);

        // Assert
        expect(professors.length, lessThanOrEqualTo(3));
      });

      test('should return all when no limit specified', () async {
        // Act
        final allProfessors = await repository.getAllProfessors();
        final favoriteProfessors = await repository.getFavoriteProfessors();

        // Assert
        expect(favoriteProfessors.length, lessThanOrEqualTo(allProfessors.length));
        expect(favoriteProfessors.length, lessThanOrEqualTo(5)); // Default limit is 5
      });
    });

    group('getTopProfessors', () {
      test('should return professors sorted by review count', () async {
        // Act
        final professors = await repository.getTopProfessors();

        // Assert
        expect(professors, isNotEmpty);
        // Verificar que están ordenados por totalReviews descendente
        for (int i = 0; i < professors.length - 1; i++) {
          expect(professors[i].totalReviews, 
                 greaterThanOrEqualTo(professors[i + 1].totalReviews));
        }
      });

      test('should respect limit parameter', () async {
        // Act
        final professors = await repository.getTopProfessors(limit: 5);

        // Assert
        expect(professors.length, lessThanOrEqualTo(5));
      });
    });

    group('getProfessorsByDepartment', () {
      test('should return professors from specific department', () async {
        // Arrange
        const department = 'Ing. Sistemas';

        // Act
        final professors = await repository.getProfessorsByDepartment(department);

        // Assert
        expect(professors.every((p) => p.department == department), isTrue);
      });

      test('should return empty list for non-existent department', () async {
        // Act
        final professors = await repository.getProfessorsByDepartment('NonExistent');

        // Assert
        expect(professors, isEmpty);
      });

      test('should be case sensitive', () async {
        // Act
        final professors = await repository.getProfessorsByDepartment('ing. sistemas');

        // Assert
        expect(professors, isEmpty);
      });
    });

    group('searchProfessors', () {
      test('should find professors by name', () async {
        // Arrange
        final allProfessors = await repository.getAllProfessors();
        final firstProfessorName = allProfessors.first.name;
        final searchTerm = firstProfessorName.split(' ').first;

        // Act
        final results = await repository.searchProfessors(searchTerm);

        // Assert
        expect(results, isNotEmpty);
        expect(results.any((p) => p.name.contains(searchTerm)), isTrue);
      });

      test('should find professors by department', () async {
        // Act
        final results = await repository.searchProfessors('Sistemas');

        // Assert
        expect(results, isNotEmpty);
        expect(results.any((p) => p.department.contains('Sistemas')), isTrue);
      });

      test('should find professors by course', () async {
        // Arrange
        final allProfessors = await repository.getAllProfessors();
        final firstCourse = allProfessors.first.courses.first;
        final searchTerm = firstCourse.split(' ').first;

        // Act
        final results = await repository.searchProfessors(searchTerm);

        // Assert
        expect(results.any((p) => 
          p.courses.any((course) => course.contains(searchTerm))), isTrue);
      });

      test('should be case insensitive', () async {
        // Act
        final lowerResults = await repository.searchProfessors('sistemas');
        final upperResults = await repository.searchProfessors('SISTEMAS');

        // Assert
        expect(lowerResults.length, equals(upperResults.length));
      });

      test('should return empty list for no matches', () async {
        // Act
        final results = await repository.searchProfessors('NonExistentSearchTerm123');

        // Assert
        expect(results, isEmpty);
      });

      test('should return empty list for empty query', () async {
        // Act
        final results = await repository.searchProfessors('');

        // Assert
        expect(results, isEmpty);
      });
    });

    group('getProfessorById', () {
      test('should return professor when found', () async {
        // Arrange
        final allProfessors = await repository.getAllProfessors();
        final firstProfessorId = allProfessors.first.id;

        // Act
        final professor = await repository.getProfessorById(firstProfessorId);

        // Assert
        expect(professor, isNotNull);
        expect(professor?.id, equals(firstProfessorId));
      });

      test('should return null when not found', () async {
        // Act
        final professor = await repository.getProfessorById('non-existent-id');

        // Assert
        expect(professor, isNull);
      });

      test('should return null for empty id', () async {
        // Act
        final professor = await repository.getProfessorById('');

        // Assert
        expect(professor, isNull);
      });
    });

    group('Data Consistency', () {
      test('should have consistent data across different methods', () async {
        // Arrange
        final allProfessors = await repository.getAllProfessors();
        
        // Act
        final favorites = await repository.getFavoriteProfessors();
        final topProfessors = await repository.getTopProfessors();

        // Assert
        // Todos los favoritos deben estar en la lista completa
        for (final fav in favorites) {
          expect(allProfessors.any((p) => p.id == fav.id), isTrue);
        }
        
        // Todos los top profesores deben estar en la lista completa
        for (final top in topProfessors) {
          expect(allProfessors.any((p) => p.id == top.id), isTrue);
        }
      });

      test('should have valid professor data', () async {
        // Act
        final professors = await repository.getAllProfessors();

        // Assert
        for (final professor in professors) {
          expect(professor.id, isNotEmpty);
          expect(professor.name, isNotEmpty);
          expect(professor.department, isNotEmpty);
          expect(professor.courses, isNotEmpty);
          expect(professor.averageRating, greaterThanOrEqualTo(0.0));
          expect(professor.averageRating, lessThanOrEqualTo(5.0));
          expect(professor.totalReviews, greaterThanOrEqualTo(0));
        }
      });

      test('should have unique professor IDs', () async {
        // Act
        final professors = await repository.getAllProfessors();

        // Assert
        final ids = professors.map((p) => p.id).toList();
        final uniqueIds = ids.toSet();
        expect(ids.length, equals(uniqueIds.length));
      });
    });
  });
}
