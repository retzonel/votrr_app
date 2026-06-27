import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'biometric_service.dart';

//provoider for biometric service to be imported to UI
final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});