import 'package:local_auth/local_auth.dart';

  
  
enum BiometricResult {
  success,
  failure,
  notAvailable,     
  notSupported,     
  lockedOut,        
}

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

    
    
  Future<bool> isSupported() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    return canCheck || isSupported;
  }

    
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

    
  Future<BiometricResult> authenticate() async {
    try {
      final supported = await isSupported();
      if (!supported) return BiometricResult.notSupported;

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Verify your identity to access Votrr',
        options: const AuthenticationOptions(
          biometricOnly: false,   
          stickyAuth: true,       
          sensitiveTransaction: true,   
        ),
      );

      return didAuthenticate
          ? BiometricResult.success
          : BiometricResult.failure;

    } on Exception catch (e) {
        
        
        
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