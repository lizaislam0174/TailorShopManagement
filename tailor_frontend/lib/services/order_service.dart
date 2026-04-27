import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../core/network/api_config.dart';

class OrderService {
  final Dio _dio;

  OrderService(this._dio);

  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await _dio.get(ApiConfig.orders);
      debugPrint('Fetched orders: ${response.data}');
      
      if (response.data is List) {
        final List data = response.data;
        return data.map((json) => OrderModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      // Return empty list or throw to show error in UI instead of mock data
      rethrow; 
    }
  }

  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      debugPrint('Sending order data: ${order.toJson()}');
      final response = await _dio.post(ApiConfig.orders, data: order.toJson());
      debugPrint('Create order response: ${response.data}');
      
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return OrderModel.fromJson(data);
      }
      return order; 
    } on DioException catch (e) {
      debugPrint('Dio error creating order: ${e.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('General error creating order: $e');
      rethrow;
    }
  }

  Future<OrderModel> updateOrderStatus(int id, String status) async {
    final response = await _dio.put('${ApiConfig.orders}/$id/status', data: {'status': status});
    if (response.data is Map<String, dynamic>) {
      return OrderModel.fromJson(response.data);
    }
    throw Exception('Failed to update order status');
  }
}
