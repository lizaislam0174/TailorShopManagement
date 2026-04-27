import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/order.dart';
import '../models/customer.dart';
import '../providers/order_provider.dart';
import '../providers/customer_provider.dart';

class OrderFormScreen extends ConsumerStatefulWidget {
  const OrderFormScreen({super.key});

  @override
  ConsumerState<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends ConsumerState<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _totalAmountController;
  Customer? _selectedCustomer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _totalAmountController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCustomer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a customer')),
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        final newOrder = OrderModel(
          customerId: _selectedCustomer!.id!,
          description: _descriptionController.text.trim(),
          totalAmount: double.tryParse(_totalAmountController.text) ?? 0.0,
        );

        // Debug print to check the payload
        debugPrint('Creating order with data: ${newOrder.toJson()}');

        await ref.read(orderServiceProvider).createOrder(newOrder);
        
        // Success! Refresh list and go back
        ref.invalidate(ordersProvider);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order created successfully!')),
          );
          context.pop();
        }
      } catch (e) {
        debugPrint('Order creation error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create order: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order'),
      ),
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
                  customersAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Error loading customers: $e', style: const TextStyle(color: Colors.red)),
                    ),
                    data: (customers) {
                      if (customers.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('No customers found. Please add a customer first.', style: TextStyle(color: Colors.orange)),
                        );
                      }
                      return DropdownButtonFormField<Customer>(
                        decoration: const InputDecoration(
                          labelText: 'Select Customer',
                          prefixIcon: Icon(Icons.person),
                        ),
                        value: _selectedCustomer,
                        items: customers.where((c) => c.id != null).map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(c.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedCustomer = val;
                          });
                        },
                        validator: (value) => value == null ? 'Please select a customer' : null,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Order Description',
                      hintText: 'e.g. 2 Piece Suit, Summer Dress',
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (v) => v!.isEmpty ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _totalAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Total Amount (\$)',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (v) {
                      if (v!.isEmpty) return 'Amount is required';
                      if (double.tryParse(v) == null) return 'Enter a valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _save,
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Create Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
