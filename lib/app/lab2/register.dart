import 'package:flutter/material.dart';
import 'package:unik_mobile/app/lab2/register_inputs.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/navigation/lab2_auth_gate.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/domain/auth/registration_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _nicknameError;
  String? _passwordError;
  String? _confirmError;

  bool _busy = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nickname = _nicknameController.text;
    final nicknameErr = RegistrationValidator.firstOf([
      if (nickname.trim().isNotEmpty)
        RegistrationValidator.validateNickname(nickname),
    ]);
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
      _nicknameError = nicknameErr;
      _passwordError = pwdErr;
      _confirmError = matchErr;
    });
    if (nameErr != null ||
        emailErr != null ||
        pwdErr != null ||
        matchErr != null ||
        nicknameErr != null) {
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
      nickname: nickname,
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
      MaterialPageRoute<void>(builder: (_) => const Lab2AuthGate()),
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
                children: registerAccountInputs(
                  nameController: _nameController,
                  emailController: _emailController,
                  nicknameController: _nicknameController,
                  passwordController: _passwordController,
                  confirmController: _confirmController,
                  nameError: _nameError,
                  emailError: _emailError,
                  nicknameError: _nicknameError,
                  passwordError: _passwordError,
                  confirmError: _confirmError,
                  busy: _busy,
                  onSubmit: _submit,
                  onBack: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
