class VinValidator {
  static const int vinLength = 19;
  static final RegExp _alphanumeric = RegExp(r'^[A-Z0-9]+$');

  // Returns null if valid, or an error string if invalid.
  // This is the Flutter form validator convention.
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Voter ID is required.';
    }
    final upper = value.toUpperCase().trim();
    if (upper.length != vinLength) {
      return 'Voter ID must be exactly $vinLength characters.';
    }
    if (!_alphanumeric.hasMatch(upper)) {
      return 'Voter ID may only contain letters and numbers.';
    }
    return null;
  }

  // Formats VIN into groups of 4 for readability as the user types:
  // 1234567890ABC123456 → 1234 5678 90AB C123 456
  // We'll use this in the text field formatter.
  static String format(String raw) {
    final clean = raw.toUpperCase().replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(clean[i]);
    }
    return buffer.toString();
  }

  // Strip spaces before sending to Firebase.
  static String normalize(String formatted) {
    return formatted.toUpperCase().replaceAll(' ', '');
  }
}