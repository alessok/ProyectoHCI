/// Excepción base para la aplicación
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (Code: $code)';
}

/// Excepción de autenticación
class AuthenticationException extends AppException {
  const AuthenticationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'AuthenticationException: $message (Code: $code)';
}

/// Excepción de autorización
class AuthorizationException extends AppException {
  const AuthorizationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'AuthorizationException: $message (Code: $code)';
}

/// Excepción de validación
class ValidationException extends AppException {
  final Map<String, String> fieldErrors;

  const ValidationException(
    super.message, {
    this.fieldErrors = const {},
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'ValidationException: $message (Field Errors: $fieldErrors)';
}

/// Excepción de red/conectividad
class NetworkException extends AppException {
  const NetworkException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'NetworkException: $message (Code: $code)';
}

/// Excepción de Firebase
class FirebaseException extends AppException {
  const FirebaseException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'FirebaseException: $message (Code: $code)';
}

/// Excepción de datos no encontrados
class NotFoundException extends AppException {
  const NotFoundException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'NotFoundException: $message (Code: $code)';
}

/// Excepción de conflicto (datos duplicados, etc.)
class ConflictException extends AppException {
  const ConflictException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'ConflictException: $message (Code: $code)';
}

/// Excepción de límite de rate
class RateLimitException extends AppException {
  final Duration? retryAfter;

  const RateLimitException(
    super.message, {
    this.retryAfter,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'RateLimitException: $message (Retry after: $retryAfter)';
}

/// Excepción de servidor interno
class ServerException extends AppException {
  const ServerException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'ServerException: $message (Code: $code)';
}

/// Excepción de cache
class CacheException extends AppException {
  const CacheException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'CacheException: $message (Code: $code)';
} 