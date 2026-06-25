import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/election_config.dart';

class FeedRepository {
  final FirebaseFirestore _db;

  FeedRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  // Real-time stream of election config
  Stream<ElectionConfig> electionConfigStream() {
    return _db
        .collection('election')
        .doc('config')
        .snapshots()
        .map(ElectionConfig.fromDoc);
  }

  // Real-time stream of vote counts per candidate.
  // Returns a map of candidateId → count.
  Stream<Map<String, int>> voteCountsStream() {
    return _db.collection('votes').snapshots().map((snapshot) {
      final counts = <String, int>{};
      for (final doc in snapshot.docs) {
        final candidateId = doc.data()['candidateId'] as String?;
        if (candidateId != null) {
          counts[candidateId] = (counts[candidateId] ?? 0) + 1;
        }
      }
      return counts;
    });
  }

  // Real-time stream of candidates (reuse from vote feature)
  Stream<List<Map<String, dynamic>>> candidatesStream() {
    return _db
        .collection('candidates')
        .orderBy('order')
        .snapshots()
        .map((s) => s.docs
            .map((d) => {'id': d.id, ...d.data()})
            .toList());
  }
}