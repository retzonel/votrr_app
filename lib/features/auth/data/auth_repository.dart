import 'package:firebase_auth/firebase_auth.dart';

// Converts a VIN to a Firebase-compatible email.
// This is the only place this conversion lives.
String _vinToEmail(String vin) => '${vin.trim().toLowerCase()}@votrr.ng';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // The currently signed-in Firebase user, or null.
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream that emits whenever auth state changes.
  // go_router will listen to this
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> registerWithVin({
    required String vin,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: _vinToEmail(vin),
      password: password,
    );
  }

  Future<UserCredential> loginWithVin({
    required String vin,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: _vinToEmail(vin),
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}