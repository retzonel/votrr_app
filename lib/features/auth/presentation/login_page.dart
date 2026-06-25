import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/vin_validator.dart';
import '../data/auth_notifier.dart';
import '../domain/auth_state.dart';
import 'register_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _vinController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _vinController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final vin = VinValidator.normalize(_vinController.text);
    final password = _passwordController.text;

    await ref.read(authProvider.notifier).login(
          vin: vin,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                _buildHeader(),
                const SizedBox(height: 48),
                _buildVinField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 32),
                _buildLoginButton(isLoading),
                const SizedBox(height: 24),
                _buildRegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.how_to_vote_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Votrr',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          'Voter Sign In',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter your Voter Identification Number and password to access the platform.',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textMuted,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildVinField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voter ID (VIN)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _vinController,
          textCapitalization: TextCapitalization.characters,
          keyboardType: TextInputType.text,
          inputFormatters: [
            // Only allow alphanumeric + spaces (spaces added by formatter)
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
            _VinInputFormatter(),
          ],
          decoration: const InputDecoration(
            hintText: 'XXXX XXXX XXXX XXXX XXX',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
          validator: (value) => VinValidator.validate(
            VinValidator.normalize(value ?? ''),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: !_passwordVisible,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () =>
                  setState(() => _passwordVisible = !_passwordVisible),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Password is required.';
            if (value.length < 6)
              return 'Password must be at least 6 characters.';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _submit,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text('Sign In'),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: AppTheme.textMuted),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const RegisterPage()),
          ),
          child: const Text(
            'Register',
            style: TextStyle(
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom input formatter that auto-spaces the VIN as the user types.
// Keeps the cursor in the right position after formatting.
class _VinInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = VinValidator.format(newValue.text);
    // Cap at 19 chars + 4 spaces = 23 display chars
    if (formatted.length > 23) {
      return oldValue;
    }
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
