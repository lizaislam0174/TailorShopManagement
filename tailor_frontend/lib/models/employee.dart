class Employee {
  final int? id;
  final String formatId;
  final String name;
  final String phone;
  final String role;
  final double salary;

  Employee({
    this.id,
    this.formatId = '',
    required this.name,
    required this.phone,
    required this.role,
    this.salary = 0.0,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      formatId: json['formatId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      salary: (json['salary'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'salary': salary,
    };
  }
}
