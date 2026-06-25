import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Candidate {
  final String id;
  final String name;
  final String party;
  final String position;
  final int order;

  const Candidate({
    required this.id,
    required this.name,
    required this.party,
    required this.position,
    required this.order,
  });

  factory Candidate.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Candidate(
      id: doc.id,
      name: data['name'] as String,
      party: data['party'] as String,
      position: data['position'] as String,
      order: (data['order'] as num).toInt(),
    );
  }

  // party colour for the accent stripe on each card
  Color get partyColor {
    switch (party.toUpperCase()) {
      case 'APC':
        return const Color(0xFF006400); // dark green
      case 'PDP':
        return const Color(0xFFD4001A); // red — note: fix space
      case 'LP':
        return const Color(0xFF006400);
      case 'NNPP':
        return const Color(0xFF8B0000);
      case "United Food Coalition":
        return const Color(0xFF008CFF);
      case "Progressive Food Alliance":
        return const Color(0xFFFDFD00);
      default:
        return const Color(0xFF008751);
    }
  }
}
