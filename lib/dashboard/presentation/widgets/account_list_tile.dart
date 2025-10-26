import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:go_banking_frontend/dashboard/domain/entities/account.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    super.key,
    required this.account,
    this.color,
    this.seed,
    this.icon,
  });

  final Account account;
  final Color? color;
  final int? seed;
  final IconData? icon;

  Color _generateColor(int seed) {
    final random = Random(seed);
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.red,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.green,
    ];
    return colors[random.nextInt(colors.length)];
  }

  int _generateSeed() {
    return Random().nextInt(10000);
  }

  IconData _getIconForAccountType(String type) {
    switch (type.toLowerCase()) {
      case 'checking':
        return Icons.account_balance;
      case 'savings':
        return Icons.savings;
      case 'vacation':
        return Icons.flight_takeoff;
      default:
        return Icons.wallet;
    }
  }

  @override
  Widget build(BuildContext context) {
    final finalColor = color ?? _generateColor(seed ?? _generateSeed());
    final finalSeed = seed ?? _generateSeed();
    final finalIcon = icon ?? _getIconForAccountType(account.accountType);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            onTapDown: (_) {},
            highlightColor: Colors.white.withOpacity(0.1),
            splashColor: Colors.white.withOpacity(0.2),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    finalColor,
                    finalColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Círculos procedurales
                  ProceduralCircles(seed: finalSeed),
                  // Contenido
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${account.accountType.toUpperCase()} Account',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Icon(
                              finalIcon,
                              color: Colors.white,
                              size: 28,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          account.balanceCurrency,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          account.hiddenAccountNumber,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProceduralCircles extends StatelessWidget {
  const ProceduralCircles({super.key, required this.seed});

  final int seed;

  @override
  Widget build(BuildContext context) {
    final random = Random(seed);

    return Stack(
      children: List.generate(3, (index) {
        final size = random.nextDouble() * 200 + 100;
        final offsetX = random.nextDouble() * 200 - 100;
        final offsetY = random.nextDouble() * 200 - 100;
        final opacity = random.nextDouble() * 0.3 + 0.1;

        return Positioned(
          right: offsetX,
          bottom: offsetY,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(opacity),
            ),
          ),
        );
      }),
    );
  }
}

@Preview(name: "Test Account tile",
size: Size(400, 200)
)
Widget accountTile() =>
    AccountListTile(account: Account(id: "1",
        currency: "EUR",
        accountType: "checking",
        balance: 2000,
        accountNumber: "[1020 0404 0505 6060]"));