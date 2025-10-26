import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_banking_frontend/auth/presentation/widgets/auth_form.dart';
import 'package:go_router/go_router.dart';
import 'package:go_banking_frontend/core/storage/token_storage.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _hasToken = false;
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await _tokenStorage.getRefreshToken();
    if (token != null && token.isNotEmpty) {
      if (mounted) {
        setState(() {
          _hasToken = true;
        });
      }
    }
  }

  Future<void> _submitLogin(Map<String, String> formData) async {
    await ref.read(authNotifierProvider.notifier).login(
          formData['dni']!,
          formData['pin']!,
        );
    final authState = ref.read(authNotifierProvider);
    if (authState is AsyncData && authState.value != null) {
      if (mounted) {
        context.goNamed('Dashboard');
      }
    }
  }

  void _accessDirectly() {
    context.goNamed('Dashboard');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        context.goNamed('Dashboard');
      }
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthForm(
                isLogin: true,
                onSubmit: (formData, r) => _submitLogin(formData),
              ),
              if (_hasToken) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _accessDirectly,
                  child: const Text('Acceder con biometría'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}