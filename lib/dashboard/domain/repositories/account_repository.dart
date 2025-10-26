import 'package:go_banking_frontend/dashboard/domain/entities/account.dart';

abstract class AccountRepository {
  Future<List<Account>> getAccounts();
  Future<void> createAccount(String currency, String accountType);
}
