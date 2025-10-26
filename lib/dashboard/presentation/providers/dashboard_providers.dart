import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_banking_frontend/core/network/api_client.dart';
import 'package:go_banking_frontend/dashboard/data/datasources/account_data_source.dart';
import 'package:go_banking_frontend/dashboard/data/repositories/account_repository_impl.dart';
import 'package:go_banking_frontend/dashboard/domain/repositories/account_repository.dart';
import 'package:go_banking_frontend/dashboard/presentation/providers/account_provider.dart';

import '../../../auth/presentation/providers/auth_token_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return ApiClient('http://localhost:8080', tokenStorage);
});

final accountDataSourceProvider = Provider<AccountDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AccountDataSource(apiClient);
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final dataSource = ref.watch(accountDataSourceProvider);
  return AccountRepositoryImpl(dataSource);
});

final accountProvider = ChangeNotifierProvider<AccountProvider>((ref) {
  final accountRepository = ref.watch(accountRepositoryProvider);
  return AccountProvider(accountRepository)..fetchAccounts();
});
