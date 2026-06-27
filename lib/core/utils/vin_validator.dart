class VinValidator {
  static const int vinLength = 19;
  static final RegExp _alphanumeric = RegExp(r'^[A-Z0-9]+$');

  // form validation
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

  // for formmating the VIN to all caps and ints
  static String format(String raw) {
    final clean = raw.toUpperCase().replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(clean[i]);
    }
    return buffer.toString();
  }

  // for removing spaces from strings before sending i.e if any
  static String normalize(String formatted) {
    return formatted.toUpperCase().replaceAll(' ', '');
  }
}