import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_form.dart';
import '../widgets/pin_display_modal.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  void _submitSignup(WidgetRef ref, Map<String, String> formData) {
    ref.read(authNotifierProvider.notifier).signup(
      formData['full_name']!,
      formData['dni']!,
      formData['email']!,
    );
  }

  void _showPinModal(BuildContext context, String pin) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PinDisplayModal(
        pin: pin,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          ref.read(authNotifierProvider.notifier).clearState();
          if (mounted && context.mounted) {
            context.goNamed('Dashboard');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (prev, next) {
      if (next is AsyncError) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${next.error.toString()}')),
          );
        }
      }
      if (next is AsyncData && next.value != null && next.value is SignupResult) {
        final result = next.value as SignupResult;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showPinModal(context, result.pin);
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Center(
        child: AuthForm(
          isLogin: false,
          onSubmit: (formData, r) => _submitSignup(ref, formData),
        ),
      ),
    );
  }
}