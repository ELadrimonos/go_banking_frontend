import 'package:go_banking_frontend/dashboard/data/datasources/account_data_source.dart';
import 'package:go_banking_frontend/dashboard/domain/entities/account.dart';
import 'package:go_banking_frontend/dashboard/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountDataSource dataSource;

  AccountRepositoryImpl(this.dataSource);

  @override
  Future<List<Account>> getAccounts() {
    return dataSource.getAccounts();
  }

  @override
  Future<void> createAccount(String currency, String accountType) {
    return dataSource.createAccount(currency, accountType);
  }
}
