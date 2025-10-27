import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_banking_frontend/auth/presentation/providers/auth_token_provider.dart';
import 'package:go_banking_frontend/core/config/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(authTokenProvider.notifier).loadInitialToken();


  runApp(UncontrolledProviderScope(
    container: container,
    child: const BankingApp(),
  ));
}

class BankingApp extends ConsumerWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: router,
    );
  }
}
