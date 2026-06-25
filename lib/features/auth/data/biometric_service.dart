import 'package:local_auth/local_auth.dart';

// Represents the outcome of a biometric check.
// We use a sealed-class-style enum so the UI can handle every case explicitly.
enum BiometricResult {
  success,
  failure,
  notAvailable,   // device has no biometrics enrolled
  notSupported,   // device hardware can't do biometrics
  lockedOut,      // too many failed attempts
}

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  // Check whether this device can do biometrics at all.
  // Call this before trying to authenticate.
  Future<bool> isSupported() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    return canCheck || isSupported;
  }

  // Returns which biometric types are enrolled (fingerprint, face, etc.)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

  // The main call: triggers the native biometric prompt.
  Future<BiometricResult> authenticate() async {
    try {
      final supported = await isSupported();
      if (!supported) return BiometricResult.notSupported;

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Verify your identity to access Votrr',
        options: const AuthenticationOptions(
          biometricOnly: false, // allow PIN/pattern as fallback
          stickyAuth: true,     // don't cancel if user switches apps briefly
          sensitiveTransaction: true, // tells Android this is security-sensitive
        ),
      );

      return didAuthenticate
          ? BiometricResult.success
          : BiometricResult.failure;

    } on Exception catch (e) {
      // local_auth throws PlatformException with specific error codes.
      // Rather than import the exception type, we check the string.
      // In production you'd map these more carefully.
      final message = e.toString().toLowerCase();
      if (message.contains('lockedout') || message.contains('locked_out')) {
        return BiometricResult.lockedOut;
      }
      if (message.contains('notenrolled') || message.contains('not_enrolled')) {
        return BiometricResult.notAvailable;
      }
      return BiometricResult.failure;
    }
  }
}