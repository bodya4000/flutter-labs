import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/app/lab2/register.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/navigation/lab2_auth_gate.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/state/app_registry.dart';
import 'package:unik_mobile/state/login/login_cubit.dart';
import 'package:unik_mobile/widgets/app_button.dart';
import 'package:unik_mobile/widgets/app_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(AppScope.authService, GlobalSession.cubit),
      child: const _LoginControllersHost(),
    );
  }
}

class _LoginControllersHost extends StatefulWidget {
  const _LoginControllersHost();

  @override
  State<_LoginControllersHost> createState() => _LoginControllersHostState();
}

class _LoginControllersHostState extends State<_LoginControllersHost> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, bool>(
      builder: (context, busy) {
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
                        controller: _email,
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      AppInput(
                        label: 'Password',
                        obscureText: true,
                        controller: _password,
                      ),
                      const SizedBox(height: AppSpacing.s24),
                      AppButton(
                        label: busy ? 'Signing in…' : 'Sign In',
                        onPressed: busy ? null : () => signInTap(context),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      AppButton(
                        label: 'Create Account',
                        variant: AppButtonVariant.ghost,
                        onPressed: busy
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                      ),
                      const SizedBox(height: AppSpacing.s24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> signInTap(BuildContext outer) async {
    final cubit = outer.read<LoginCubit>();
    final err = await cubit.login(email: _email.text, password: _password.text);
    if (!outer.mounted) {
      return;
    }
    if (err != null) {
      AppToast.show(outer, err, variant: AppToastVariant.error);
      return;
    }
    Navigator.of(outer).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const Lab2AuthGate()),
      (route) => route.isFirst,
    );
  }
}
