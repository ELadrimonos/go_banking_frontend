import 'package:flutter/material.dart';
import 'package:go_banking_frontend/dashboard/domain/entities/account.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    super.key,
    required this.account,
  });

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${account.accountType} Account'),
        subtitle: Text('Currency: ${account.currency}'),
        trailing: Text(
          '${account.balance} ${account.currency}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
