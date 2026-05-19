import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unik_mobile/app/lab2/register_inputs.dart';
import 'package:unik_mobile/core/config/app_scope.dart';
import 'package:unik_mobile/core/navigation/lab2_auth_gate.dart';
import 'package:unik_mobile/core/theme/app_theme.dart';
import 'package:unik_mobile/core/toast/app_toast.dart';
import 'package:unik_mobile/state/app_registry.dart';
import 'package:unik_mobile/state/register/register_cubit.dart';
import 'package:unik_mobile/state/register/register_models.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(
        AppScope.authService,
        AppScope.connectivity,
        GlobalSession.cubit,
      ),
      child: const _RegisterFormHost(),
    );
  }
}

class _RegisterFormHost extends StatefulWidget {
  const _RegisterFormHost();

  @override
  State<_RegisterFormHost> createState() => _RegisterFormHostState();
}

class _RegisterFormHostState extends State<_RegisterFormHost> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _nickname.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
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
              child: BlocBuilder<RegisterCubit, RegisterRunning>(
                builder: (context, run) {
                  final e = run.lastErrors;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: registerAccountInputs(
                      nameController: _name,
                      emailController: _email,
                      nicknameController: _nickname,
                      passwordController: _password,
                      confirmController: _confirm,
                      nameError: e.name,
                      emailError: e.email,
                      nicknameError: e.nickname,
                      passwordError: e.password,
                      confirmError: e.confirm,
                      busy: run.busy,
                      onSubmit: () => _submit(context),
                      onBack: () => Navigator.of(context).pop(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext outer) async {
    final cubit = outer.read<RegisterCubit>();
    final end = await cubit.submit(
      fullName: _name.text,
      email: _email.text,
      nickname: _nickname.text,
      password: _password.text,
      confirm: _confirm.text,
    );
    if (!outer.mounted) {
      return;
    }
    if (end is RegisterEndOffline) {
      AppToast.show(
        outer,
        'No internet connection. Connect and try again.',
        variant: AppToastVariant.error,
      );
      return;
    }
    if (end is RegisterEndFailure) {
      AppToast.show(outer, end.message, variant: AppToastVariant.error);
      return;
    }
    if (end is RegisterEndSuccess) {
      Navigator.of(outer).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const Lab2AuthGate()),
        (route) => route.isFirst,
      );
    }
  }
}
