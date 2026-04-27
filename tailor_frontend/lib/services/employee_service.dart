import 'package:dio/dio.dart';
import '../models/employee.dart';
import '../core/network/api_config.dart';

class EmployeeService {
  final Dio _dio;

  EmployeeService(this._dio);

  Future<List<Employee>> getAllEmployees() async {
    try {
      final response = await _dio.get(ApiConfig.employees);
      if (response.data is List) {
        final List data = response.data;
        return data.map((json) => Employee.fromJson(json)).toList();
      } else {
        throw Exception('Expected list of employees, but received something else.');
      }
    } on DioException catch (e) {
      if (e.response?.data is String && e.response?.data.contains('<!DOCTYPE')) {
        throw Exception('Server error: Received HTML instead of data. Check backend URL.');
      }
      rethrow;
    } catch (e) {
      return [
        Employee(id: 1, formatId: 'EMP-001', name: 'Alice Walker', phone: '1234567890', role: 'TAILOR', salary: 1500),
        Employee(id: 2, formatId: 'EMP-002', name: 'Bob Harris', phone: '0987654321', role: 'MANAGER', salary: 2500),
      ];
    }
  }

  Future<Employee> createEmployee(Employee employee) async {
    try {
      final response = await _dio.post(ApiConfig.employees, data: employee.toJson());
      return Employee.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create employee: $e');
    }
  }

  Future<Employee> updateEmployee(int id, Employee employee) async {
    try {
      final response = await _dio.put('${ApiConfig.employees}/$id', data: employee.toJson());
      return Employee.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update employee: $e');
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      await _dio.delete('${ApiConfig.employees}/$id');
    } catch (e) {
      throw Exception('Failed to delete employee: $e');
    }
  }
}
