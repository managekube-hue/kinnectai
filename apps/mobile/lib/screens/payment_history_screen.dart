import 'package:flutter/material.dart';
import '../theme/colors.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Payment History'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          return ListTile(
            title: const Text('Vault+ Premium'),
            subtitle: const Text('Monthly subscription'),
            trailing: const Text('\$9.99'),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: KinnectColors.darkCard,
              ),
              child: const Icon(Icons.receipt, size: 20),
            ),
            tileColor: index.isEven ? KinnectColors.darkCard.withOpacity(0.3) : null,
          );
        },
      ),
    );
  }
}
