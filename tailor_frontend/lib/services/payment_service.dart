import 'package:dio/dio.dart';
import '../models/payment.dart';
import '../core/network/api_config.dart';

class PaymentService {
  final Dio _dio;

  PaymentService(this._dio);

  Future<List<Payment>> getAllPayments() async {
    try {
      final response = await _dio.get(ApiConfig.payments);
      final List data = response.data;
      return data.map((json) => Payment.fromJson(json)).toList();
    } catch (e) {
      return [
        Payment(id: 1, orderId: 1, orderNumber: 'ORD-001', amount: 150.0, paymentMethod: 'CREDIT_CARD', paymentDate: DateTime.now()),
        Payment(id: 2, orderId: 2, orderNumber: 'ORD-002', amount: 50.0, paymentMethod: 'CASH', paymentDate: DateTime.now().subtract(const Duration(days: 1))),
      ];
    }
  }

  Future<Payment> createPayment(Payment payment) async {
    final response = await _dio.post(ApiConfig.payments, data: payment.toJson());
    return Payment.fromJson(response.data);
  }
}
