import 'package:flutter/material.dart';
import 'package:unik_mobile/app/lab2/page.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';
import 'package:unik_mobile/widgets/app_button.dart';
import 'package:unik_mobile/widgets/app_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  bool _busy = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nameErr = RegistrationValidator.validateFullName(
      _nameController.text,
    );
    final emailErr = RegistrationValidator.validateEmail(_emailController.text);
    final pwdErr = RegistrationValidator.validatePassword(
      _passwordController.text,
    );
    final matchErr = RegistrationValidator.validateConfirmPassword(
      _passwordController.text,
      _confirmController.text,
    );
    setState(() {
      _nameError = nameErr;
      _emailError = emailErr;
      _passwordError = pwdErr;
      _confirmError = matchErr;
    });
    if (nameErr != null ||
        emailErr != null ||
        pwdErr != null ||
        matchErr != null) {
      return;
    }
    final online = await AppScope.connectivity.checkOnline();
    if (!mounted) {
      return;
    }
    if (!online) {
      AppToast.show(
        context,
        'No internet connection. Connect and try again.',
        variant: AppToastVariant.error,
      );
      return;
    }
    setState(() => _busy = true);
    final outcome = await AppScope.authService.register(
      fullName: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmController.text,
    );
    if (!mounted) {
      return;
    }
    setState(() => _busy = false);
    if (!outcome.isSuccess) {
      AppToast.show(
        context,
        outcome.errorMessage ?? 'Registration failed',
        variant: AppToastVariant.error,
      );
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomePage()),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.pageHorizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: AppSpacing.s16),
                  AppInput(
                    label: 'Full Name',
                    controller: _nameController,
                    errorText: _nameError,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  AppInput(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    errorText: _emailError,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  AppInput(
                    label: 'Password',
                    obscureText: true,
                    controller: _passwordController,
                    errorText: _passwordError,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  AppInput(
                    label: 'Confirm Password',
                    obscureText: true,
                    controller: _confirmController,
                    errorText: _confirmError,
                  ),
                  const SizedBox(height: AppSpacing.s28),
                  AppButton(
                    label: _busy ? 'Creating…' : 'Register',
                    onPressed: _busy ? null : _submit,
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  AppButton(
                    label: 'Back to Sign In',
                    variant: AppButtonVariant.ghost,
                    onPressed: _busy ? null : () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: AppSpacing.s24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
