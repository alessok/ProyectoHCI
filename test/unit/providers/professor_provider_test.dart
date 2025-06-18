import 'package:flutter_test/flutter_test.dart';
import 'package:professor_ranking_app/core/providers/professor_provider.dart';
import 'package:professor_ranking_app/core/repositories/professor_repository.dart';
import 'package:professor_ranking_app/models/professor.dart';

/// Mock implementation del repositorio para testing
class MockProfessorRepository implements ProfessorRepository {
  final List<Professor> _mockProfessors = [
    Professor(
      id: '1',
      name: 'Dr. Test Professor',
      department: 'Ing. Sistemas',
      courses: ['Programación I', 'Algoritmos'],
      averageRating: 4.5,
      totalReviews: 10,
    ),
    Professor(
      id: '2',
      name: 'Mg. Test Professor 2',
      department: 'Ing. Industrial',
      courses: ['Gestión de Proyectos'],
      averageRating: 4.0,
      totalReviews: 8,
    ),
  ];

  @override
  Future<List<Professor>> getAllProfessors() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simular delay
    return _mockProfessors;
  }

  @override
  Future<List<Professor>> getFavoriteProfessors({int? limit}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final sorted = List<Professor>.from(_mockProfessors)
      ..sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return limit != null ? sorted.take(limit).toList() : sorted;
  }

  @override
  Future<List<Professor>> getTopProfessors({int? limit}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final sorted = List<Professor>.from(_mockProfessors)
      ..sort((a, b) => b.totalReviews.compareTo(a.totalReviews));
    return limit != null ? sorted.take(limit).toList() : sorted;
  }

  @override
  Future<List<Professor>> getProfessorsByDepartment(String department) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockProfessors.where((p) => p.department == department).toList();
  }

  @override
  Future<List<Professor>> searchProfessors(String query) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockProfessors.where((p) => 
      p.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  @override
  Future<Professor?> getProfessorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _mockProfessors.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<String>> getAllDepartments() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockProfessors.map((p) => p.department).toSet().toList();
  }

  @override
  Future<bool> isFavoriteProfessor(String professorId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    // Simular que el profesor con id '1' está en favoritos
    return professorId == '1';
  }

  @override
  Future<void> toggleFavoriteProfessor(String professorId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    // Simular toggle de favoritos (no necesita implementación real para tests)
  }
}

void main() {
  group('ProfessorProvider Tests', () {
    late ProfessorProvider provider;
    late MockProfessorRepository mockRepository;

    setUp(() {
      mockRepository = MockProfessorRepository();
      provider = ProfessorProvider(mockRepository);
    });

    group('Initial State', () {
      test('should have empty initial state', () {
        expect(provider.professors, isEmpty);
        expect(provider.favoriteProfessors, isEmpty);
        expect(provider.topProfessors, isEmpty);
        expect(provider.selectedCategory, equals('All'));
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
      });
    });

    group('loadProfessorsByCategory', () {
      test('should load all professors when category is All', () async {
        // Act
        await provider.loadProfessorsByCategory('All');

        // Assert
        expect(provider.professors, hasLength(2));
        expect(provider.favoriteProfessors, hasLength(2));
        expect(provider.topProfessors, hasLength(2));
        expect(provider.selectedCategory, equals('All'));
        expect(provider.isLoading, isFalse);
        expect(provider.errorMessage, isNull);
      });

      test('should load professors by specific department', () async {
        // Act
        await provider.loadProfessorsByCategory('Ing. Sistemas');

        // Assert
        expect(provider.professors, hasLength(1));
        expect(provider.professors.first.department, equals('Ing. Sistemas'));
        expect(provider.selectedCategory, equals('Ing. Sistemas'));
        expect(provider.isLoading, isFalse);
      });

      test('should set loading state during operation', () async {
        // Arrange
        bool wasLoading = false;
        provider.addListener(() {
          if (provider.isLoading) {
            wasLoading = true;
          }
        });

        // Act
        await provider.loadProfessorsByCategory('All');

        // Assert
        expect(wasLoading, isTrue);
        expect(provider.isLoading, isFalse);
      });

      test('should handle errors gracefully', () async {
        // Arrange
        final errorRepository = ErrorProfessorRepository();
        final errorProvider = ProfessorProvider(errorRepository);

        // Act
        await errorProvider.loadProfessorsByCategory('All');

        // Assert
        expect(errorProvider.errorMessage, isNotNull);
        expect(errorProvider.errorMessage, contains('Error al cargar profesores'));
        expect(errorProvider.isLoading, isFalse);
      });
    });

    group('searchProfessors', () {
      test('should return matching professors', () async {
        // Act
        final results = await provider.searchProfessors('Test');

        // Assert
        expect(results, hasLength(2));
        expect(results.every((p) => p.name.contains('Test')), isTrue);
      });

      test('should return empty list for no matches', () async {
        // Act
        final results = await provider.searchProfessors('NonExistent');

        // Assert
        expect(results, isEmpty);
      });

      test('should handle search errors', () async {
        // Arrange
        final errorRepository = ErrorProfessorRepository();
        final errorProvider = ProfessorProvider(errorRepository);

        // Act
        final results = await errorProvider.searchProfessors('test');

        // Assert
        expect(results, isEmpty);
        expect(errorProvider.errorMessage, isNotNull);
      });
    });

    group('changeCategory', () {
      test('should change category and reload professors', () async {
        // Arrange
        await provider.loadProfessorsByCategory('All');
        
        // Act
        provider.changeCategory('Ing. Sistemas');
        await Future.delayed(const Duration(milliseconds: 200)); // Wait for async operation

        // Assert
        expect(provider.selectedCategory, equals('Ing. Sistemas'));
        expect(provider.professors.every((p) => p.department == 'Ing. Sistemas'), isTrue);
      });

      test('should not reload if same category', () async {
        // Arrange
        await provider.loadProfessorsByCategory('All');
        final initialProfessors = provider.professors;
        
        // Act
        provider.changeCategory('All');

        // Assert
        expect(provider.professors, equals(initialProfessors));
      });
    });

    group('getProfessorById', () {
      test('should return professor when found', () async {
        // Act
        final professor = await provider.getProfessorById('1');

        // Assert
        expect(professor, isNotNull);
        expect(professor?.id, equals('1'));
        expect(professor?.name, equals('Dr. Test Professor'));
      });

      test('should return null when not found', () async {
        // Act
        final professor = await provider.getProfessorById('999');

        // Assert
        expect(professor, isNull);
      });
    });
  });
}

/// Repository que simula errores para testing
class ErrorProfessorRepository implements ProfessorRepository {
  @override
  Future<List<Professor>> getAllProfessors() async {
    throw Exception('Network error');
  }

  @override
  Future<List<Professor>> getFavoriteProfessors({int? limit}) async {
    throw Exception('Network error');
  }

  @override
  Future<List<Professor>> getTopProfessors({int? limit}) async {
    throw Exception('Network error');
  }

  @override
  Future<List<Professor>> getProfessorsByDepartment(String department) async {
    throw Exception('Network error');
  }

  @override
  Future<List<Professor>> searchProfessors(String query) async {
    throw Exception('Search error');
  }

  @override
  Future<Professor?> getProfessorById(String id) async {
    throw Exception('Network error');
  }

  @override
  Future<List<String>> getAllDepartments() async {
    throw Exception('Network error');
  }

  @override
  Future<bool> isFavoriteProfessor(String professorId) async {
    throw Exception('Network error');
  }

  @override
  Future<void> toggleFavoriteProfessor(String professorId) async {
    throw Exception('Network error');
  }
}
