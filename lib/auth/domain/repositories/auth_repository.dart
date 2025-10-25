import 'package:go_banking_frontend/auth/data/datasources/auth_remote_datasources.dart';

abstract class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository(this.remoteDataSource);

  Future<String> login(String dni, String pin);

  Future<Map<String, dynamic>> signup(String fullName, String dni, String email);
}