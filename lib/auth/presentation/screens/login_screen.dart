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
    final token = await _tokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      if (mounted) {
        setState(() {
          _hasToken = true;
        });
      }
    }
  }

  void _submitLogin(Map<String, String> formData) {
    ref.read(authNotifierProvider.notifier).login(
          formData['dni']!,
          formData['pin']!,
        );
  }

  void _accessDirectly() {
    final authState = ref.read(authStateProvider);
    if (authState) {
      context.goNamed('Dashboard');
    } else {
      // Optionally, show a message that authentication is in progress
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verificando tu sesión...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: const Text('Acceder directamente'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

