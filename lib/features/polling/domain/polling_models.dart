class PollingLocation {
  final String id;
  final String name;
  final String address;
  final String lga;         // Local Government Area
  final String state;
  final String openTime;
  final String closeTime;
  final bool isAccessible;  // wheelchair accessible

  const PollingLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.lga,
    required this.state,
    required this.openTime,
    required this.closeTime,
    required this.isAccessible,
  });
}

class VotingInstruction {
  final String step;
  final String title;
  final String description;

  const VotingInstruction({
    required this.step,
    required this.title,
    required this.description,
  });
}