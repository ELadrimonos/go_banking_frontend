import 'package:go_banking_frontend/auth/data/datasources/auth_remote_datasources.dart';
import 'package:go_banking_frontend/auth/domain/entities/token_response.dart';
import 'package:go_banking_frontend/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<TokenResponse> login(String dni, String pin) {
    return remoteDataSource.login(dni, pin);
  }

  @override
  Future<Map<String, dynamic>> signup(String fullName, String dni, String email) {
    return remoteDataSource.signup(fullName, dni, email);
  }
}