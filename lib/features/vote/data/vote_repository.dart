import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/candidate.dart';

class VoteRepository {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  VoteRepository({
    FirebaseFirestore? db,
    FirebaseAuth? auth,
  })  : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<List<Candidate>> getCandidates() async {
    final snapshot = await _db.collection('candidates').orderBy('order').get();
    return snapshot.docs.map(Candidate.fromDoc).toList();
  }

  Future<String?> getUserVote() async {
    final doc = await _db.collection('votes').doc(_uid).get();
    if (!doc.exists) return null;
    return doc.data()?['candidateId'] as String?;
  }

  Future<void> castVote({
    required String candidateId,
    required String candidateName,
  }) async {
    await _db.collection('votes').doc(_uid).set({
      'candidateId': candidateId,
      'candidateName': candidateName,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': _uid,
    });
  }

  Future<bool> isElectionOpen() async {
    final doc = await _db.collection('election').doc('config').get();
    if (!doc.exists) return false;
    return doc.data()?['isOpen'] as bool? ?? false;
  }
}
