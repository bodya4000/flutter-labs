import 'package:flutter/material.dart';
import 'package:unik_mobile/app/lab2/page.dart';
import 'package:unik_mobile/app/lab2/register.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/widgets/app_button.dart';
import 'package:unik_mobile/widgets/app_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _busy = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
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
    final outcome = await AppScope.authService.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) {
      return;
    }
    setState(() => _busy = false);
    if (!outcome.isSuccess) {
      AppToast.show(
        context,
        outcome.errorMessage ?? 'Sign in failed',
        variant: AppToastVariant.error,
      );
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomePage()),
      (route) => route.isFirst,
    );
  }

  void _goRegister() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.pageHorizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: AppSpacing.s24),
                  const Icon(
                    Icons.home_work_rounded,
                    size: 72,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  const Text(
                    'UNIK IoT',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.onSurface,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  const Text(
                    'Smart Home Platform',
                    style: TextStyle(color: AppTheme.muted, fontSize: 14),
                  ),
                  const SizedBox(height: AppSpacing.s40),
                  AppInput(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  AppInput(
                    label: 'Password',
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  AppButton(
                    label: _busy ? 'Signing in…' : 'Sign In',
                    onPressed: _busy ? null : _submit,
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  AppButton(
                    label: 'Create Account',
                    variant: AppButtonVariant.ghost,
                    onPressed: _busy ? null : _goRegister,
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
