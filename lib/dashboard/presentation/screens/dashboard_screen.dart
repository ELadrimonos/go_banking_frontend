import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_banking_frontend/auth/presentation/providers/auth_provider.dart';
import 'package:go_banking_frontend/dashboard/presentation/providers/dashboard_providers.dart';

import '../widgets/account_list_tile.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountState = ref.watch(accountProvider);
    final userAsyncValue = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Builder(
        builder: (context) {
          if (accountState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                userAsyncValue.when(
                  data: (user) => Text(
                    'Welcome, ${user?.fullName ?? 'UNKNOWN'}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                ),
                const SizedBox(height: 24),
                Text(
                  'Your Accounts',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: accountState.accounts.length,
                    itemBuilder: (context, index) {
                      final account = accountState.accounts[index];
                      // TODO Get stored locally account color and seed
                      //  from account id
                      return SizedBox(
                        width: 400,
                        height: 200,
                        child: AccountListTile(account: account),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create account screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
