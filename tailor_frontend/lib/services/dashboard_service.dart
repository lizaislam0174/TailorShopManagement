import 'package:dio/dio.dart';
import '../models/dashboard_stats.dart';
import '../core/network/api_config.dart';

class DashboardService {
  final Dio _dio;

  DashboardService(this._dio);

  Future<DashboardStats> fetchDashboardStats() async {
    try {
      final response = await _dio.get(ApiConfig.dashboard);
      return DashboardStats.fromJson(response.data);
    } catch (e) {
      return DashboardStats(
        totalCustomers: 124,
        totalEmployees: 12,
        totalOrders: 350,
        pendingOrders: 45,
        deliveredOrders: 305,
      );
    }
  }
}
