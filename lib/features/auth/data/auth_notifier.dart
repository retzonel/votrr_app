import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:votrr/features/auth/domain/auth_state.dart';
import 'auth_repository.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthInitial()) {
    // Check if user is already logged in when app starts.
    // Firebase persists sessions, so returning users are auto-logged-in.
    final currentUser = _repository.currentUser;
    if (currentUser != null) {
      state = AuthAuthenticated(currentUser);
    } else {
      state = const AuthUnauthenticated();
    }
  }

  Future<void> login({required String vin, required String password}) async {
    state = const AuthLoading();
    try {
      final credential = await _repository.loginWithVin(
        vin: vin,
        password: password,
      );
      state = AuthAuthenticated(credential.user!);
    } on FirebaseAuthException catch (e) {
      state = AuthError(_mapFirebaseError(e));
    } catch (_) {
      state = const AuthError('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> register({required String vin, required String password}) async {
    state = const AuthLoading();
    try {
      final credential = await _repository.registerWithVin(
        vin: vin,
        password: password,
      );
      state = AuthAuthenticated(credential.user!);
    } on FirebaseAuthException catch (e) {
      state = AuthError(_mapFirebaseError(e));
    } catch (_) {
      state = const AuthError('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthUnauthenticated();
  }

  // Firebase gives error codes like 'user-not-found'.
  // We translate those into human-readable messages.
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        // Deliberately vague — don't tell attackers which part was wrong
        return 'Invalid Voter ID or password.';
      case 'invalid-email':
        return 'Invalid Voter ID format.';
      case 'email-already-in-use':
        return 'This Voter ID is already registered.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}

// The provider — this is what the UI imports.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});