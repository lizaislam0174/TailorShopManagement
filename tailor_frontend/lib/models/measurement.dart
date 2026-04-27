class Measurement {
  final int? id;
  final int customerId;
  final double chest;
  final double waist;
  final double hips;
  final double length;
  final String notes;

  Measurement({
    this.id,
    required this.customerId,
    this.chest = 0.0,
    this.waist = 0.0,
    this.hips = 0.0,
    this.length = 0.0,
    this.notes = '',
  });

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'],
      customerId: json['customerId'] ?? 0,
      chest: (json['chest'] ?? 0.0).toDouble(),
      waist: (json['waist'] ?? 0.0).toDouble(),
      hips: (json['hips'] ?? 0.0).toDouble(),
      length: (json['length'] ?? 0.0).toDouble(),
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'customerId': customerId,
      'chest': chest,
      'waist': waist,
      'hips': hips,
      'length': length,
      'notes': notes,
    };
  }
}
