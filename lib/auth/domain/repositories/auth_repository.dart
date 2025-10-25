import 'package:go_banking_frontend/auth/data/datasources/auth_remote_datasources.dart';
import 'package:go_banking_frontend/auth/domain/entities/token_response.dart';

abstract class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository(this.remoteDataSource);

  Future<TokenResponse> login(String dni, String pin);

  Future<Map<String, dynamic>> signup(String fullName, String dni, String email);
}