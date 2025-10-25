import 'package:flutter_riverpod/legacy.dart';
import 'package:go_banking_frontend/core/storage/token_storage.dart';

final authTokenProvider = StateNotifierProvider<AuthTokenNotifier, String?>((ref) {
  return AuthTokenNotifier();
});

class AuthTokenNotifier extends StateNotifier<String?> {
  final _tokenStorage = TokenStorage();

  AuthTokenNotifier() : super(null) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    state = await _tokenStorage.getToken();
  }

  Future<void> setToken(String token) async {
    await _tokenStorage.saveToken(token);
    state = token;
  }

  Future<void> clearToken() async {
    await _tokenStorage.deleteToken();
    state = null;
  }

  bool get isLoggedIn => state != null;
}