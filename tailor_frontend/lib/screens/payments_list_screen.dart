import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_theme.dart';
import '../providers/payment_provider.dart';

class PaymentsListScreen extends ConsumerWidget {
  const PaymentsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () => context.go('/payments/new'),
              icon: const Icon(Icons.add),
              label: const Text('Add Payment'),
            ),
          )
        ],
      ),
      body: paymentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (payments) {
          if (payments.isEmpty) {
            return const Center(child: Text('No payments found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child: const Icon(Icons.payment, color: AppTheme.primaryColor),
                  ),
                  title: Text('\$${payment.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text('Order: ${payment.orderNumber}\nMethod: ${payment.paymentMethod}'),
                  isThreeLine: true,
                  trailing: payment.paymentDate != null
                      ? Text(
                          DateFormat('MMM dd, yyyy').format(payment.paymentDate!),
                          style: const TextStyle(color: AppTheme.textSecondary),
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
