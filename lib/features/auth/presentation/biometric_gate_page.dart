import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/biometric_provider.dart';
import '../data/biometric_service.dart';
import '../../auth/presentation/login_page.dart'; // we create this next phase

class BiometricGatePage extends ConsumerStatefulWidget {
  const BiometricGatePage({super.key});

  @override
  ConsumerState<BiometricGatePage> createState() => _BiometricGatePageState();
}

class _BiometricGatePageState extends ConsumerState<BiometricGatePage> {
  bool _isAuthenticating = false;
  String? _errorMessage;

  // Called on page load AND when the user taps retry.
  Future<void> _authenticate() async {
    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    final service = ref.read(biometricServiceProvider);
    final result = await service.authenticate();

    if (!mounted) return; // widget might be gone by the time async finishes

    setState(() => _isAuthenticating = false);

    switch (result) {
      case BiometricResult.success:
        // Navigate to Login — replace so user can't back-navigate to gate
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );

      case BiometricResult.failure:
        setState(() => _errorMessage = 'Authentication failed. Please try again.');

      case BiometricResult.notAvailable:
        setState(() => _errorMessage =
            'No biometrics enrolled. Please set up fingerprint or face unlock in your device settings.');

      case BiometricResult.notSupported:
        setState(() => _errorMessage =
            'This device does not support biometric authentication.');

      case BiometricResult.lockedOut:
        setState(() => _errorMessage =
            'Too many failed attempts. Please unlock your device manually first.');
    }
  }

  @override
  void initState() {
    super.initState();
    // Auto-trigger on first load — don't make user tap a button first
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008751), // AppTheme.primaryGreen
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // App logo / wordmark
              _buildLogo(),

              const SizedBox(height: 64),

              // Biometric icon with loading state
              _buildBiometricIcon(),

              const SizedBox(height: 32),

              // Status text
              _buildStatusText(),

              const SizedBox(height: 24),

              // Error message (conditional)
              if (_errorMessage != null) _buildErrorMessage(),

              const Spacer(flex: 3),

              // Retry button (only shown on failure)
              if (_errorMessage != null && !_isAuthenticating)
                _buildRetryButton(),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.how_to_vote_rounded,
            size: 40,
            color: Color(0xFF008751),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Votrr',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Secure Digital Voting',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildBiometricIcon() {
    if (_isAuthenticating) {
      return const SizedBox(
        width: 72,
        height: 72,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3,
        ),
      );
    }

    return Icon(
      _errorMessage != null
          ? Icons.fingerprint // stays as fingerprint even on error, for retry
          : Icons.fingerprint,
      size: 72,
      color: _errorMessage != null ? Colors.red.shade300 : Colors.white,
    );
  }

  Widget _buildStatusText() {
    final text = _isAuthenticating
        ? 'Verifying identity...'
        : _errorMessage != null
            ? 'Verification failed'
            : 'Authenticating';

    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _errorMessage!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRetryButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: _authenticate,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Try Again',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}