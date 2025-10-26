import 'package:go_banking_frontend/core/network/api_client.dart';
import 'package:go_banking_frontend/dashboard/domain/entities/account.dart';

class AccountDataSource {
  final ApiClient _apiClient;

  AccountDataSource(this._apiClient);

  Future<List<Account>> getAccounts() async {
    final response = await _apiClient.dio.get('/accounts');
    return (response.data as List)
        .map(
          (accountJson) => Account(
            id: accountJson['id'],
            currency: accountJson['currency'],
            accountType: accountJson['account_type'],
            balance: accountJson['balance'].toDouble(),
            accountNumber: accountJson['account_number'],
          ),
        )
        .toList();
  }

  Future<void> createAccount(String currency, String accountType) async {
    await _apiClient.dio.post(
      '/create-account',
      data: {'currency': currency, 'account_type': accountType},
    );
  }
}
