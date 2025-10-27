import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_banking_frontend/auth/data/datasources/auth_remote_datasources.dart';
import 'package:go_banking_frontend/auth/domain/repositories/auth_repository.dart';
import 'package:go_banking_frontend/core/network/api_client.dart';
import 'package:go_banking_frontend/auth/data/repositories/auth_repository_impl.dart';
import 'package:go_banking_frontend/auth/domain/entities/user.dart';
import 'auth_token_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final apiClient = ApiClient('http://localhost:8080', tokenStorage);
  return AuthRepositoryImpl(AuthRemoteDataSource(apiClient.dio));
});

final userProvider = FutureProvider<User?>((ref) async {
  final authState = ref.watch(authStateProvider);
  if (authState) {
    return await ref.watch(authRepositoryProvider).getUser();
  }
  return null;
});

final authStateProvider = Provider<bool>((ref) {
  final token = ref.watch(authTokenProvider);
  return token != null;
});

// Estado para el resultado del signup (incluye el PIN generado)
class SignupResult {
  final String pin;

  SignupResult({required this.pin});
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<dynamic>>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider),
      ref.read(authTokenProvider.notifier));
});

class AuthNotifier extends StateNotifier<AsyncValue<dynamic>> {
  final AuthRepository _repo;
  final AuthTokenNotifier _tokenNotifier;

  AuthNotifier(this._repo, this._tokenNotifier) : super(const AsyncValue.data(null));

  Future<void> login(String dni, String pin) async {
    state = const AsyncValue.loading();
    try {
      final tokens = await _repo.login(dni, pin);
      await _tokenNotifier.saveTokens(
          accessToken: tokens.accessToken, refreshToken: tokens.refreshToken);
      state = AsyncValue.data(tokens);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException && e.response?.data != null) {
        errorMessage = e.response?.data['error'] ?? e.toString();
      }
      state = AsyncValue.error(errorMessage, StackTrace.current);
    }
  }

  Future<void> signup(String fullName, String dni, String email) async {
    state = const AsyncValue.loading();
    try {
      final data = await _repo.signup(fullName, dni, email);
      final pin = data['pin'];

      state = AsyncValue.data(SignupResult(pin: pin));
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException && e.response?.data != null) {
        errorMessage = e.response?.data['error'] ?? e.toString();
      }
      state = AsyncValue.error(errorMessage, StackTrace.current);
    }
  }

  Future<void> logout() async {
    await _tokenNotifier.clearTokens();
    state = const AsyncValue.data(null);
  }

  void clearState() {
    state = const AsyncValue.data(null);
  }
}
