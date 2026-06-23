class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'Votrr';
  static const String appTagline = 'Your Vote. Your Voice. Secured.';

  // Auth
  static const String loginTitle = 'Voter Login';
  static const String ninLabel = 'National Identification Number (NIN)';
  static const String vinLabel = 'Voter Identification Number (VIN)';
  static const String ninHint = 'Enter your 11-digit NIN';
  static const String vinHint = 'Enter your 19-digit VIN';
  static const String loginButton = 'Verify & Login';
  static const String loggingIn = 'Verifying credentials...';

  // Biometric
  static const String biometricTitle = 'Identity Verification Required';
  static const String biometricSubtitle =
      'Use your device security to continue';
  static const String biometricReason =
      'Votrr requires device authentication to protect your voting identity.';
  static const String biometricFailed = 'Authentication failed. Try again.';
  static const String biometricNotAvailable =
      'Device security not set up. Please set up a PIN or fingerprint in your device settings.';

  // Navigation
  static const String navHome = 'Home';
  static const String navVote = 'Vote';
  static const String navResults = 'Results';
  static const String navProfile = 'Profile';

  // Voting
  static const String voteTitle = 'Cast Your Vote';
  static const String confirmVote = 'Confirm Vote';
  static const String voteSuccess = 'Your vote has been recorded securely.';

  // Errors
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError =
      'No internet connection. Please check your network.';
  static const String sessionExpired =
      'Your session has expired. Please log in again.';
}