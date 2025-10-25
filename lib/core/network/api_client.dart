import 'package:dio/dio.dart';
import 'package:go_banking_frontend/core/storage/token_storage.dart';

class ApiClient {
  final Dio dio;
  final TokenStorage _tokenStorage;

  ApiClient(String baseUrl, this._tokenStorage)
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
        )) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _tokenStorage.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await _tokenStorage.getRefreshToken();
            if (refreshToken != null) {
              try {
                // Create a new Dio instance for the refresh token request
                final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
                final response = await refreshDio.post('/refresh', data: {'refresh_token': refreshToken});

                if (response.statusCode == 200) {
                  final newAccessToken = response.data['access_token'];
                  final newRefreshToken = response.data['refresh_token'];
                  await _tokenStorage.saveTokens(
                    accessToken: newAccessToken,
                    refreshToken: newRefreshToken,
                  );

                  // Update the header of the original request
                  e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

                  // Retry the original request
                  return handler.resolve(await dio.fetch(e.requestOptions));
                }
              } on DioException {
                // If refresh fails, delete tokens and pass the error
                await _tokenStorage.deleteAllTokens();
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
}
