import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../providers/dashboard_provider.dart';
import '../providers/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardStatsProvider);
    final userState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back, ${userState.user?.username ?? 'Admin'}!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            dashboardState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Error loading dashboard: $error', style: const TextStyle(color: AppTheme.errorColor)),
              ),
              data: (stats) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 800;
                    final crossAxisCount = isDesktop ? 4 : (constraints.maxWidth > 500 ? 2 : 1);

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: isDesktop ? 2.5 : 2.0,
                      children: [
                        StatCard(
                          title: 'Total Customers',
                          value: stats.totalCustomers.toString(),
                          icon: Icons.people,
                          color: Colors.blue,
                        ),
                        StatCard(
                          title: 'Total Employees',
                          value: stats.totalEmployees.toString(),
                          icon: Icons.badge,
                          color: Colors.orange,
                        ),
                        StatCard(
                          title: 'Total Orders',
                          value: stats.totalOrders.toString(),
                          icon: Icons.shopping_cart,
                          color: Colors.purple,
                        ),
                        StatCard(
                          title: 'Pending Orders',
                          value: stats.pendingOrders.toString(),
                          icon: Icons.pending_actions,
                          color: Colors.red,
                        ),
                        StatCard(
                          title: 'Delivered Orders',
                          value: stats.deliveredOrders.toString(),
                          icon: Icons.local_shipping,
                          color: Colors.green,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
