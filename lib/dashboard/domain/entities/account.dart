import 'dart:math';

import 'package:go_banking_frontend/core/helpers/currency_symbol.dart';

class Account {
  final String id;
  final String currency;
  final String accountType;
  final double balance;
  final String accountNumber;

  Account({
    required this.id,
    required this.currency,
    required this.accountType,
    required this.balance,
    required this.accountNumber,
  });

  String get balanceCurrency => "${getCurrencyIcon(currency)} ${balance.toStringAsFixed(2)}";

  String get hiddenAccountNumber =>
      "•••• ${accountNumber.substring(max(0, accountNumber.length - 6))}";
}
