import '../exceptions/app_exceptions.dart';

/// Validador base para la aplicación
abstract class AppValidator<T> {
  String? validate(T value);
  
  /// Validar múltiples valores
  Map<String, String> validateMultiple(Map<String, T> values) {
    final errors = <String, String>{};
    
    for (final entry in values.entries) {
      final error = validate(entry.value);
      if (error != null) {
        errors[entry.key] = error;
      }
    }
    
    return errors;
  }
}

/// Validador de email
class EmailValidator extends AppValidator<String> {
  static const String _emailPattern = 
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
  
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }
    
    if (!RegExp(_emailPattern).hasMatch(value)) {
      return 'El formato del email no es válido';
    }
    
    // Validación específica para emails de Ulima
    if (!value.toLowerCase().contains('@ulima.edu.pe') && 
        !value.toLowerCase().contains('@aloe.ulima.edu.pe')) {
      return 'Debe ser un email institucional de Ulima';
    }
    
    return null;
  }
}

/// Validador de contraseña
class PasswordValidator extends AppValidator<String> {
  final int minLength;
  final bool requireUppercase;
  final bool requireLowercase;
  final bool requireNumbers;
  final bool requireSpecialChars;
  
  PasswordValidator({
    this.minLength = 6,
    this.requireUppercase = false,
    this.requireLowercase = true,
    this.requireNumbers = false,
    this.requireSpecialChars = false,
  });
  
  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    
    if (value.length < minLength) {
      return 'La contraseña debe tener al menos $minLength caracteres';
    }
    
    if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe contener al menos una mayúscula';
    }
    
    if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      return 'La contraseña debe contener al menos una minúscula';
    }
    
    if (requireNumbers && !value.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe contener al menos un número';
    }
    
    if (requireSpecialChars && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'La contraseña debe contener al menos un carácter especial';
    }
    
    return null;
  }
}

/// Validador de nombre
class NameValidator extends AppValidator<String> {
  final int minLength;
  final int maxLength;
  
  NameValidator({
    this.minLength = 2,
    this.maxLength = 50,
  });
  
  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es requerido';
    }
    
    final trimmedValue = value.trim();
    
    if (trimmedValue.length < minLength) {
      return 'El nombre debe tener al menos $minLength caracteres';
    }
    
    if (trimmedValue.length > maxLength) {
      return 'El nombre no puede exceder $maxLength caracteres';
    }
    
    // Validar que solo contenga letras, espacios y algunos caracteres especiales
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(trimmedValue)) {
      return 'El nombre solo puede contener letras y espacios';
    }
    
    return null;
  }
}

/// Validador de rating
class RatingValidator extends AppValidator<double> {
  final double minValue;
  final double maxValue;
  
  RatingValidator({
    this.minValue = 1.0,
    this.maxValue = 5.0,
  });
  
  @override
  String? validate(double? value) {
    if (value == null) {
      return 'La calificación es requerida';
    }
    
    if (value < minValue || value > maxValue) {
      return 'La calificación debe estar entre $minValue y $maxValue';
    }
    
    return null;
  }
}

/// Validador de comentario
class CommentValidator extends AppValidator<String> {
  final int minLength;
  final int maxLength;
  
  CommentValidator({
    this.minLength = 10,
    this.maxLength = 500,
  });
  
  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El comentario es requerido';
    }
    
    final trimmedValue = value.trim();
    
    if (trimmedValue.length < minLength) {
      return 'El comentario debe tener al menos $minLength caracteres';
    }
    
    if (trimmedValue.length > maxLength) {
      return 'El comentario no puede exceder $maxLength caracteres';
    }
    
    // Validar contenido inapropiado (básico)
    final inappropriateWords = [
      'spam', 'publicidad', 'promoción', 'venta', 'comprar', 'vender',
      'http://', 'https://', 'www.', '.com', '.pe'
    ];
    
    final lowerValue = trimmedValue.toLowerCase();
    for (final word in inappropriateWords) {
      if (lowerValue.contains(word)) {
        return 'El comentario no puede contener contenido promocional o enlaces';
      }
    }
    
    return null;
  }
}

/// Validador de curso
class CourseValidator extends AppValidator<String> {
  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El curso es requerido';
    }
    
    final trimmedValue = value.trim();
    
    if (trimmedValue.length < 3) {
      return 'El nombre del curso debe tener al menos 3 caracteres';
    }
    
    if (trimmedValue.length > 100) {
      return 'El nombre del curso no puede exceder 100 caracteres';
    }
    
    return null;
  }
}

/// Validador de semestre
class SemesterValidator extends AppValidator<String> {
  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // El semestre es opcional
    }
    
    final trimmedValue = value.trim();
    
    // Validar formato YYYY-N (ej: 2024-1, 2023-2)
    if (!RegExp(r'^\d{4}-[12]$').hasMatch(trimmedValue)) {
      return 'El formato del semestre debe ser YYYY-N (ej: 2024-1)';
    }
    
    // Validar que el año sea razonable
    final year = int.tryParse(trimmedValue.split('-')[0]);
    final currentYear = DateTime.now().year;
    
    if (year == null || year < 2020 || year > currentYear + 1) {
      return 'El año del semestre no es válido';
    }
    
    return null;
  }
}

/// Validador de búsqueda
class SearchValidator extends AppValidator<String> {
  final int minLength;
  final int maxLength;
  
  SearchValidator({
    this.minLength = 2,
    this.maxLength = 50,
  });
  
  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El término de búsqueda es requerido';
    }
    
    final trimmedValue = value.trim();
    
    if (trimmedValue.length < minLength) {
      return 'El término de búsqueda debe tener al menos $minLength caracteres';
    }
    
    if (trimmedValue.length > maxLength) {
      return 'El término de búsqueda no puede exceder $maxLength caracteres';
    }
    
    return null;
  }
}

/// Validador de ID
class IdValidator extends AppValidator<String> {
  @override
  String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El ID es requerido';
    }
    
    final trimmedValue = value.trim();
    
    if (trimmedValue.isEmpty) {
      return 'El ID no puede estar vacío';
    }
    
    // Validar que solo contenga caracteres válidos para ID
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(trimmedValue)) {
      return 'El ID contiene caracteres no válidos';
    }
    
    return null;
  }
}

/// Validador compuesto para formularios
class FormValidator {
  static Map<String, String> validateForm(Map<String, dynamic> formData) {
    final errors = <String, String>{};
    
    // Validar email si existe
    if (formData.containsKey('email')) {
      final emailError = EmailValidator().validate(formData['email']);
      if (emailError != null) {
        errors['email'] = emailError;
      }
    }
    
    // Validar contraseña si existe
    if (formData.containsKey('password')) {
      final passwordError = PasswordValidator().validate(formData['password']);
      if (passwordError != null) {
        errors['password'] = passwordError;
      }
    }
    
    // Validar nombre si existe
    if (formData.containsKey('name')) {
      final nameError = NameValidator().validate(formData['name']);
      if (nameError != null) {
        errors['name'] = nameError;
      }
    }
    
    // Validar rating si existe
    if (formData.containsKey('rating')) {
      final ratingError = RatingValidator().validate(formData['rating']);
      if (ratingError != null) {
        errors['rating'] = ratingError;
      }
    }
    
    // Validar comentario si existe
    if (formData.containsKey('comment')) {
      final commentError = CommentValidator().validate(formData['comment']);
      if (commentError != null) {
        errors['comment'] = commentError;
      }
    }
    
    // Validar curso si existe
    if (formData.containsKey('course')) {
      final courseError = CourseValidator().validate(formData['course']);
      if (courseError != null) {
        errors['course'] = courseError;
      }
    }
    
    // Validar semestre si existe
    if (formData.containsKey('semester')) {
      final semesterError = SemesterValidator().validate(formData['semester']);
      if (semesterError != null) {
        errors['semester'] = semesterError;
      }
    }
    
    return errors;
  }
  
  /// Lanzar excepción si hay errores de validación
  static void throwIfInvalid(Map<String, dynamic> formData) {
    final errors = validateForm(formData);
    if (errors.isNotEmpty) {
      throw ValidationException(
        'Datos de formulario inválidos',
        fieldErrors: errors,
      );
    }
  }
} 