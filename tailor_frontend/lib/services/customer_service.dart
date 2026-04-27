import 'package:dio/dio.dart';
import '../models/customer.dart';
import '../core/network/api_config.dart';

class CustomerService {
  final Dio _dio;

  CustomerService(this._dio);

  Future<List<Customer>> getAllCustomers() async {
    try {
      final response = await _dio.get(ApiConfig.customers);
      if (response.data is List) {
        final List data = response.data;
        return data.map((json) => Customer.fromJson(json)).toList();
      } else {
         throw Exception('Expected list of customers, but received something else.');
      }
    } on DioException catch (e) {
      if (e.response?.data is String && e.response?.data.contains('<!DOCTYPE')) {
         throw Exception('Server error: Received HTML instead of data. Check backend URL.');
      }
      rethrow;
    } catch (e) {
      return [];
    }
  }

  Future<Customer> createCustomer(Customer customer) async {
    final response = await _dio.post(ApiConfig.customers, data: customer.toJson());
    return Customer.fromJson(response.data);
  }

  Future<Customer> updateCustomer(int id, Customer customer) async {
    final response = await _dio.put('${ApiConfig.customers}/$id', data: customer.toJson());
    return Customer.fromJson(response.data);
  }

  Future<void> deleteCustomer(int id) async {
    await _dio.delete('${ApiConfig.customers}/$id');
  }
}
