import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_banking_frontend/auth/presentation/providers/auth_token_provider.dart';
import 'package:go_banking_frontend/core/config/app_router.dart';
import 'package:go_banking_frontend/core/storage/token_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final tokenStorage = container.read(tokenStorageProvider);

  final refreshToken = await tokenStorage.getRefreshToken();

  if (refreshToken != null) {
    try {
      final refreshDio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
      final response = await refreshDio
          .post('/refresh', data: {'refresh_token': refreshToken});

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];
        await tokenStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
      }
    } catch (e) {
      // If refresh fails, we can choose to delete the tokens
      await tokenStorage.deleteAllTokens();
    }
  }
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
