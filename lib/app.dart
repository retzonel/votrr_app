import 'package:flutter/material.dart';
import 'package:votrr/core/theme/app_theme.dart';
import 'package:votrr/features/auth/presentation/biometric_gate_page.dart';

class VotrrApp extends StatelessWidget {
  const VotrrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votrr',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const BiometricGatePage(),
    );
  }
}
