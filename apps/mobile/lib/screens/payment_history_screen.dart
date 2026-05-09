import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 12 -- Payment History (Settings -> Balance).
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  static final _transactions = [
    _TxData(title: '10 Photplay Credits', amount: '\$8.99', date: 'May 5, 2026', status: 'completed', icon: PhosphorIcons.flower),
    _TxData(title: 'Vault+ Monthly', amount: '\$4.99', date: 'May 1, 2026', status: 'completed', icon: PhosphorIcons.lock),
    _TxData(title: '5 Photplay Credits', amount: '\$4.49', date: 'Apr 22, 2026', status: 'completed', icon: PhosphorIcons.flower),
    _TxData(title: 'Kinnect Kit Order', amount: '\$0.00', date: 'Apr 15, 2026', status: 'completed', icon: PhosphorIcons.dna),
    _TxData(title: 'Vault+ Monthly', amount: '\$4.99', date: 'Apr 1, 2026', status: 'completed', icon: PhosphorIcons.lock),
    _TxData(title: '1 Photplay Credit', amount: '\$0.99', date: 'Mar 28, 2026', status: 'refunded', icon: PhosphorIcons.flower),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Payment History', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Restore Purchases', style: TextStyle(color: KinnectColors.primary, fontSize: 13)),
          ),
        ],
      ),
      body: _transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(PhosphorIcons.receipt(), size: 64, color: KinnectColors.textMuted),
                  const SizedBox(height: 16),
                  Text('No transactions yet', style: KinnectTextStyles.headlineSmall),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _transactions.length,
              separatorBuilder: (_, __) => Divider(color: KinnectColors.dividerSubtle, height: 1),
              itemBuilder: (context, i) => _TransactionTile(tx: _transactions[i]),
            ),
    );
  }
}

class _TxData {
  const _TxData({required this.title, required this.amount, required this.date, required this.status, required this.icon});
  final String title;
  final String amount;
  final String date;
  final String status;
  final IconData Function() icon;
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.tx});
  final _TxData tx;

  @override
  Widget build(BuildContext context) {
    final isRefunded = tx.status == 'refunded';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isRefunded ? KinnectColors.error.withOpacity(0.1) : KinnectColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(tx.icon(), size: 22, color: isRefunded ? KinnectColors.error : KinnectColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                Text(tx.date, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tx.amount,
                style: TextStyle(
                  color: isRefunded ? KinnectColors.error : KinnectColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  decoration: isRefunded ? TextDecoration.lineThrough : null,
                ),
              ),
              if (isRefunded)
                Text('Refunded', style: TextStyle(color: KinnectColors.error, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

