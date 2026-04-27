class Customer {
  final int? id;
  final String formatId;
  final String name;
  final String phone;
  final String email;
  final String address;

  Customer({
    this.id,
    this.formatId = '',
    required this.name,
    required this.phone,
    this.email = '',
    this.address = '',
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      formatId: json['formatId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }
}
