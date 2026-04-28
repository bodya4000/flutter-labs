import 'package:flutter/material.dart';
import 'package:unik_mobile/screens/lab2/page.dart';
import 'package:unik_mobile/widgets/app_button.dart';
import 'package:unik_mobile/widgets/app_input.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  void _goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const AppInput(label: 'Full Name'),
                  const SizedBox(height: 16),
                  const AppInput(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  const AppInput(label: 'Password', obscureText: true),
                  const SizedBox(height: 16),
                  const AppInput(
                    label: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 28),
                  AppButton(
                    label: 'Register',
                    onPressed: () => _goHome(context),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Back to Sign In',
                    variant: AppButtonVariant.ghost,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
