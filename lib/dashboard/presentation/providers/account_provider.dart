import 'package:flutter/material.dart';
import 'package:go_banking_frontend/dashboard/domain/entities/account.dart';
import 'package:go_banking_frontend/dashboard/domain/repositories/account_repository.dart';

class AccountProvider extends ChangeNotifier {
  final AccountRepository _accountRepository;

  AccountProvider(this._accountRepository);

  List<Account> _accounts = [];
  List<Account> get accounts => _accounts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAccounts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _accounts = await _accountRepository.getAccounts();
    } catch (e) {
      // Handle error
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createAccount(String currency, String accountType) async {
    try {
      await _accountRepository.createAccount(currency, accountType);
      await fetchAccounts(); // Refresh the list after creating a new account
    } catch (e) {
      // Handle error
    }
  }
}
