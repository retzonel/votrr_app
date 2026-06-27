import 'package:firebase_auth/firebase_auth.dart';

// coonvert mock VIn to email so we can save on firebase firestore
String _vinToEmail(String vin) => '${vin.trim().toLowerCase()}@votrr.ng';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // she currently signed-in Firebase user, or null.
  User? get currentUser => _firebaseAuth.currentUser;

  // stream that emits whenever auth state changes.
  // go_router listens
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