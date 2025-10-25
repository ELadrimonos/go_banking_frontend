import 'package:dio/dio.dart'; // Nuevo import para manejar DioException
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_banking_frontend/auth/data/datasources/auth_remote_datasources.dart';
import 'package:go_banking_frontend/auth/domain/repositories/auth_repository.dart';
import 'package:go_banking_frontend/core/network/api_client.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_token_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final token = ref.watch(authTokenProvider);
  final apiClient = ApiClient('http://localhost:8080', token: token);
  return AuthRepositoryImpl(AuthRemoteDataSource(apiClient.dio));
});

final authStateProvider = Provider<bool>((ref) {
  final token = ref.watch(authTokenProvider);
  return token != null;
});

// Estado para el resultado del signup (incluye el PIN generado)
class SignupResult {
  final String pin;
  final String token;

  SignupResult({required this.pin, required this.token});
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<dynamic>>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider), ref.read(authTokenProvider.notifier));
});

class AuthNotifier extends StateNotifier<AsyncValue<dynamic>> {
  final AuthRepository _repo;
  final AuthTokenNotifier _tokenNotifier;

  AuthNotifier(this._repo, this._tokenNotifier) : super(const AsyncValue.data(null));

  Future<void> login(String dni, String pin) async {
    state = const AsyncValue.loading();
    try {
      final token = await _repo.login(dni, pin);
      _tokenNotifier.setToken(token);
      state = AsyncValue.data(token);
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
      final token = await _repo.login(dni, pin);

      // Se actualiza el estado con el SignupResult ANTES de establecer el token.
      // Esto es fundamental para evitar que la redirección de go_router se active prematuramente.
      // La lógica de redirección ahora comprueba este estado y no redirigirá
      // mientras se deba mostrar el modal del PIN.
      state = AsyncValue.data(SignupResult(pin: pin, token: token));
      _tokenNotifier.setToken(token);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException && e.response?.data != null) {
        errorMessage = e.response?.data['error'] ?? e.toString();
      }
      state = AsyncValue.error(errorMessage, StackTrace.current);
    }
  }

  void logout() {
    _tokenNotifier.clearToken();
    state = const AsyncValue.data(null);
  }

  void clearState() {
    state = const AsyncValue.data(null);
  }
}