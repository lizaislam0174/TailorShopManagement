import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../services/order_service.dart';
import '../providers/auth_provider.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return OrderService(dioClient.dio);
});

final ordersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final service = ref.watch(orderServiceProvider);
  return await service.getAllOrders();
});

class OrderNotifier extends StateNotifier<AsyncValue<List<OrderModel>>> {
  final OrderService _service;
  final Ref ref;

  OrderNotifier(this._service, this.ref) : super(const AsyncValue.loading());

  Future<void> updateOrderStatus(int id, String status) async {
    try {
      await _service.updateOrderStatus(id, status);
      ref.invalidate(ordersProvider);
    } catch (e, stack) {
      // Handle error if needed
    }
  }

  Future<void> refresh() async {
    ref.invalidate(ordersProvider);
  }
}

final orderNotifierProvider = Provider<OrderNotifier>((ref) {
  final service = ref.watch(orderServiceProvider);
  return OrderNotifier(service, ref);
});
