import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_banking_frontend/core/storage/token_storage.dart';

final authTokenProvider = StateNotifierProvider<AuthTokenNotifier, String?>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthTokenNotifier(tokenStorage);
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

class AuthTokenNotifier extends StateNotifier<String?> {
  final TokenStorage _tokenStorage;

  AuthTokenNotifier(this._tokenStorage) : super(null);

  Future<void> loadInitialToken() async {
    state = await _tokenStorage.getAccessToken();
  }

  Future<void> saveTokens(
      {required String accessToken, required String refreshToken}) async {
    await _tokenStorage.saveTokens(
        accessToken: accessToken, refreshToken: refreshToken);
    state = accessToken;
  }

  Future<void> clearTokens() async {
    await _tokenStorage.deleteAllTokens();
    state = null;
  }

  bool get isLoggedIn => state != null;
}
