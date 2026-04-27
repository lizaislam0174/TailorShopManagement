import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer.dart';
import '../services/customer_service.dart';
import '../providers/auth_provider.dart';

final customerServiceProvider = Provider<CustomerService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CustomerService(dioClient.dio);
});

final customersProvider = FutureProvider<List<Customer>>((ref) async {
  final service = ref.watch(customerServiceProvider);
  return await service.getAllCustomers();
});

class CustomerNotifier {
  final Ref ref;
  CustomerNotifier(this.ref);

  Future<bool> deleteCustomer(int id) async {
    try {
      await ref.read(customerServiceProvider).deleteCustomer(id);
      ref.invalidate(customersProvider);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final customerNotifierProvider = Provider<CustomerNotifier>((ref) {
  return CustomerNotifier(ref);
});
