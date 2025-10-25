import 'package:dio/dio.dart';
import 'package:go_banking_frontend/auth/domain/entities/token_response.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<TokenResponse> login(String dni, String pin) async {
    final response = await dio.post('/login', data: {
      'dni': dni,
      'pin': pin,
    });

    return TokenResponse.fromJson(response.data);
  }

  Future<Map<String, dynamic>> signup(String fullName, String dni, String email) async {
    final response = await dio.post('/signup', data: {
      'full_name': fullName,
      'dni': dni,
      'email': email,
    });

    return {
      'user_id': response.data['user_id'],
      'pin': response.data['pin'],
    };
  }
}