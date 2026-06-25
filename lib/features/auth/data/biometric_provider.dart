import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'biometric_service.dart';

// A simple Provider — BiometricService has no state of its own,
// so we don't need a StateNotifier. It's just a service instance.
final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});