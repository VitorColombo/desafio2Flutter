import 'product.dart';

class ShoppingList {
  final String id;
  final String name;
  final List<Product> products;

  ShoppingList({
    required this.id,
    required this.name,
    List<Product>? products,
  }) : products = products ?? [];

  double get totalPurchased {
    return products
        .where((p) => p.isPurchased)
        .fold(0.0, (sum, p) => sum + p.value);
  }

  double get totalNotPurchased {
    return products
        .where((p) => !p.isPurchased)
        .fold(0.0, (sum, p) => sum + p.value);
  }
}
