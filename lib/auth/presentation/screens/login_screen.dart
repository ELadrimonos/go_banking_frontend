import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_banking_frontend/auth/presentation/widgets/auth_form.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void _submitLogin(WidgetRef ref, Map<String, String> formData) {
    ref.read(authNotifierProvider.notifier).login(
      formData['dni']!,
      formData['pin']!,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error.toString()}')),
        );
      }
      if (next is AsyncData && next.value != null && next.value is String) {
        context.goNamed('Dashboard');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: AuthForm(
          isLogin: true,
          onSubmit: (formData, r) => _submitLogin(ref, formData),
        ),
      ),
    );
  }
}

