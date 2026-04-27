class Payment {
  final int? id;
  final int orderId;
  final String orderNumber;
  final double amount;
  final String paymentMethod;
  final DateTime? paymentDate;

  Payment({
    this.id,
    required this.orderId,
    this.orderNumber = '',
    required this.amount,
    required this.paymentMethod,
    this.paymentDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      orderId: json['orderId'] ?? 0,
      orderNumber: json['orderNumber'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? 'CASH',
      paymentDate: json['paymentDate'] != null ? DateTime.parse(json['paymentDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'orderId': orderId,
      'amount': amount,
      'paymentMethod': paymentMethod,
    };
  }
}
