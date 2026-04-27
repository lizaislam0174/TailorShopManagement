class DashboardStats {
  final int totalCustomers;
  final int totalEmployees;
  final int totalOrders;
  final int pendingOrders;
  final int deliveredOrders;

  DashboardStats({
    required this.totalCustomers,
    required this.totalEmployees,
    required this.totalOrders,
    required this.pendingOrders,
    required this.deliveredOrders,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalCustomers: json['totalCustomers'] ?? 0,
      totalEmployees: json['totalEmployees'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0,
      pendingOrders: json['pendingOrders'] ?? 0,
      deliveredOrders: json['deliveredOrders'] ?? 0,
    );
  }
}
