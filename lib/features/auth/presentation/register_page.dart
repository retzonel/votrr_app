import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/vin_validator.dart';
import '../data/auth_notifier.dart';
import '../domain/auth_state.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _vinController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmVisible = false;

  @override
  void dispose() {
    _vinController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final vin = VinValidator.normalize(_vinController.text);
    final password = _passwordController.text;

    await ref.read(authProvider.notifier).register(
          vin: vin,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      // router handles navigation automatically via redirect.
      // handle errors here.
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppTheme.textDark),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildVinField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmField(),
                const SizedBox(height: 12),
                _buildVinHint(),
                const SizedBox(height: 32),
                _buildRegisterButton(isLoading),
                const SizedBox(height: 32),
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
      children: const [
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Register with your Voter Identification Number to access the platform.',
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
    return _labelledField(
      label: 'Voter ID (VIN)',
      child: TextFormField(
        controller: _vinController,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
          _VinInputFormatter(),
        ],
        decoration: const InputDecoration(
          hintText: 'XXXX XXXX XXXX XXXX XXX',
          prefixIcon: Icon(Icons.badge_outlined),
        ),
        validator: (value) =>
            VinValidator.validate(VinValidator.normalize(value ?? '')),
      ),
    );
  }

  Widget _buildPasswordField() {
    return _labelledField(
      label: 'Password',
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          hintText: 'Create a strong password',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility_off : Icons.visibility),
            onPressed: () =>
                setState(() => _passwordVisible = !_passwordVisible),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Password is required.';
          if (value.length < 6) return 'Minimum 6 characters.';
          return null;
        },
      ),
    );
  }

  Widget _buildConfirmField() {
    return _labelledField(
      label: 'Confirm Password',
      child: TextFormField(
        controller: _confirmController,
        obscureText: !_confirmVisible,
        decoration: InputDecoration(
          hintText: 'Re-enter your password',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon:
                Icon(_confirmVisible ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _confirmVisible = !_confirmVisible),
          ),
        ),
        validator: (value) {
          if (value != _passwordController.text) {
            return 'Passwords do not match.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildVinHint() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, size: 16, color: AppTheme.primaryGreen),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Your VIN is on your Permanent Voter Card (PVC). It is 19 characters long.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.primaryGreen,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _submit,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
          : const Text('Create Account'),
    );
  }

  Widget _labelledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textDark)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _VinInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final formatted = VinValidator.format(newValue.text);
    if (formatted.length > 23) return oldValue;
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
