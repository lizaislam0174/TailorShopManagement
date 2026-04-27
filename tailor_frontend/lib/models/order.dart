class OrderModel {
  final int? id;
  final String orderNumber;
  final int customerId;
  final String customerName;
  final String description;
  final double totalAmount;
  final double amountPaid;
  final String status;
  final DateTime? deliveryDate;

  OrderModel({
    this.id,
    this.orderNumber = '',
    required this.customerId,
    this.customerName = '',
    required this.description,
    required this.totalAmount,
    this.amountPaid = 0.0,
    this.status = 'PENDING',
    this.deliveryDate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderNumber: json['orderNumber'] ?? '',
      customerId: json['customerId'] ?? 0,
      customerName: json['customerName'] ?? 'Unknown Customer',
      description: json['description'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      amountPaid: (json['amountPaid'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'PENDING',
      deliveryDate: json['deliveryDate'] != null ? DateTime.parse(json['deliveryDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'customerId': customerId,
      'description': description,
      'totalAmount': totalAmount,
      'amountPaid': amountPaid,
      'status': status,
      if (deliveryDate != null) 'deliveryDate': deliveryDate!.toIso8601String(),
    };
  }
}
