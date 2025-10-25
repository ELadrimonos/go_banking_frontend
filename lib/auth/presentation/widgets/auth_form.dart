import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

typedef SubmitCallback = void Function(Map<String, String> formData);

class AuthForm extends ConsumerStatefulWidget {
  final bool isLogin;
  final void Function(Map<String, String>, WidgetRef) onSubmit;

  const AuthForm({super.key, required this.isLogin, required this.onSubmit});

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    _formKey.currentState?.save();
    widget.onSubmit(_formData, ref);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    final isLoading = state.isLoading;

    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'DNI'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu DNI';
                  }
                  return null;
                },
                onSaved: (value) => _formData['dni'] = value ?? '',
              ),
              if (!widget.isLogin)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombre Completo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre completo';
                    }
                    return null;
                  },
                  onSaved: (value) => _formData['full_name'] = value ?? '',
                ),
              if (!widget.isLogin)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu email';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor ingresa un email válido';
                    }
                    return null;
                  },
                  onSaved: (value) => _formData['email'] = value ?? '',
                ),
              if (widget.isLogin)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'PIN'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu PIN';
                    }
                    return null;
                  },
                  onSaved: (value) => _formData['pin'] = value ?? '',
                ),
              ElevatedButton(
                onPressed: isLoading ? null : _trySubmit,
                child: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text(widget.isLogin ? 'Iniciar Sesión' : 'Registrarse'),
              ),
              TextButton(
                onPressed: () {
                  if (widget.isLogin) {
                    context.goNamed('SignUp');
                  } else {
                    context.goNamed('Login');
                  }
                },
                child: Text(
                  widget.isLogin
                      ? '¿No tienes cuenta? Regístrate'
                      : '¿Ya tienes cuenta? Inicia sesión',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}