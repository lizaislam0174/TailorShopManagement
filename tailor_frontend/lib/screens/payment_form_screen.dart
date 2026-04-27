import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/order.dart';
import '../models/payment.dart';
import '../providers/order_provider.dart';
import '../providers/payment_provider.dart';

class PaymentFormScreen extends ConsumerStatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  ConsumerState<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends ConsumerState<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  String _paymentMethod = 'CASH';
  OrderModel? _selectedOrder;
  bool _isLoading = false;

  final List<String> _methods = ['CASH', 'CREDIT_CARD', 'MOBILE_PAY'];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedOrder == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an order')));
        return;
      }

      setState(() => _isLoading = true);
      try {
        final newPayment = Payment(
          orderId: _selectedOrder!.id!,
          amount: double.tryParse(_amountController.text) ?? 0.0,
          paymentMethod: _paymentMethod,
        );

        final service = ref.read(paymentServiceProvider);
        await service.createPayment(newPayment);
        
        ref.invalidate(paymentsProvider);
        if (mounted) {
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   ordersAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text('Error loading orders: $e'),
                    data: (orders) {
                      return DropdownButtonFormField<OrderModel>(
                        decoration: const InputDecoration(labelText: 'Select Order'),
                        value: _selectedOrder,
                        items: orders.where((o) => o.id != null).map((o) {
                          return DropdownMenuItem(
                            value: o,
                            child: Text('${o.orderNumber} - ${o.customerName}'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedOrder = val;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Amount (\$)'),
                    validator: (v) => v!.isEmpty ? 'Amount is required' : null,
                  ),
                  const SizedBox(height: 16),
                   DropdownButtonFormField<String>(
                    value: _paymentMethod,
                    decoration: const InputDecoration(labelText: 'Payment Method'),
                    items: _methods.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _paymentMethod = val!;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Add Payment'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
