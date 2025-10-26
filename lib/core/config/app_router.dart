import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_banking_frontend/auth/presentation/providers/auth_provider.dart';
import 'package:go_banking_frontend/auth/presentation/screens/login_screen.dart';
import 'package:go_banking_frontend/auth/presentation/screens/signup_screen.dart';
import 'package:go_banking_frontend/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/signup',
        name: 'SignUp',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'Login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'Dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context);
      final authState = container.read(authStateProvider);
      final authNotifierState = container.read(authNotifierProvider);

      // If we are on the signup page and the auth state is a SignupResult,
      // it means we are waiting to show the PIN. Don't redirect.
      if (state.uri.path == '/signup' &&
          authNotifierState is AsyncData &&
          authNotifierState.value is SignupResult) {
        return null;
      }

      final loggingInOrSigningUp =
          state.uri.path == '/login' || state.uri.path == '/signup';

      if (!authState && !loggingInOrSigningUp) {
        return '/login';
      }
      // if (authState && loggingInOrSigningUp) {
      //   return '/';
      // }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(ref),
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Ref ref) {
    ref.listen<bool>(authStateProvider, (previous, next) {
      notifyListeners();
    });
    ref.listen<AsyncValue>(authNotifierProvider, (previous, next) {
      notifyListeners();
    });
  }
}
