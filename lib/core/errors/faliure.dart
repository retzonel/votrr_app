import 'package:flutter/foundation.dart';

/// A Failure is a user-friendly representation of an error.
///
/// Why separate Failure from Exception?
///
/// AppException: thrown deep in data layers (Firebase code, etc.)
/// Failure: what the UI layer receives and displays
///
/// This means your screens never have try/catch blocks.
/// Repositories catch exceptions and convert them to Failures.
/// Providers receive Failures and pass them to the UI.
///
/// Think of it like: Exception = what went wrong technically,
/// Failure = what to tell the user.
///
///
@immutable
sealed class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.code});
}

class BiometricFailure extends Failure {
  const BiometricFailure({required super.message, super.code});
}

class FaceDetectionFailure extends Failure {
  const FaceDetectionFailure({required super.message, super.code});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message, super.code});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.code});
}
