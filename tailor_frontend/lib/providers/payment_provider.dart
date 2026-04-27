import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment.dart';
import '../services/payment_service.dart';
import '../providers/auth_provider.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PaymentService(dioClient.dio);
});

final paymentsProvider = FutureProvider<List<Payment>>((ref) async {
  final service = ref.watch(paymentServiceProvider);
  return await service.getAllPayments();
});
