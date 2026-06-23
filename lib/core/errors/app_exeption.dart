/// all possible errors in the Votrr app.
/// the UI should never see raw exceptions — it sees Failures.
sealed class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({required this.message, this.code});
}

/// Firebase Authentication failed
class AuthException extends AppException {
  const AuthException({required super.message, super.code});
}

/// Network or connectivity error
class NetworkException extends AppException {
  const NetworkException({required super.message, super.code});
}

/// Firebase Firestore operation failed
class DatabaseException extends AppException {
  const DatabaseException({required super.message, super.code});
}

/// Biometric authentication error
class BiometricException extends AppException {
  const BiometricException({required super.message, super.code});
}

/// Face detection/verification error
class FaceDetectionException extends AppException {
  const FaceDetectionException({required super.message, super.code});
}

/// The user is not authorized to perform this action
class UnauthorizedException extends AppException {
  const UnauthorizedException({required super.message, super.code});
}

/// Unexpected/unknown error
class UnknownException extends AppException {
  const UnknownException({required super.message, super.code});
}
