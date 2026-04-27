import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboard_stats.dart';
import '../services/dashboard_service.dart';
import '../providers/auth_provider.dart';

final dashboardServiceProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DashboardService(dioClient.dio);
});

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  return await service.fetchDashboardStats();
});
