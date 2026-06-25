import 'package:cloud_firestore/cloud_firestore.dart';

class ElectionConfig {
  final String title;
  final bool isOpen;
  final DateTime? closesAt;

  const ElectionConfig({
    required this.title,
    required this.isOpen,
    this.closesAt,
  });

  factory ElectionConfig.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ElectionConfig(
      title: data['title'] as String? ?? 'Election',
      isOpen: data['isOpen'] as bool? ?? false,
      closesAt: (data['closesAt'] as Timestamp?)?.toDate(),
    );
  }
}