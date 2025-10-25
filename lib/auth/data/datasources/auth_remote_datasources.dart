import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<String> login(String dni, String pin) async {
    final response = await dio.post('/login', data: {
      'dni': dni,
      'pin': pin,
    });

    return response.data['token'];
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