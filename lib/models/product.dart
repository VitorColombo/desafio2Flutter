class Product {
  final String id;
  final String name;
  final double value;
  bool isPurchased;

  Product({
    required this.id,
    required this.name,
    required this.value,
    this.isPurchased = false,
  });

  Product copyWith({
    String? id,
    String? name,
    double? value,
    bool? isPurchased,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}
