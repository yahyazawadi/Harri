import 'package:online_store/products/product.dart';

class OrderItem {
  final Product product;
  final int quantity;
  final DateTime addedAt;

  OrderItem(this.product, this.quantity) : addedAt = DateTime.now() {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be positive');
    }
  }

  double get itemTotal => (product.price - product.discount()) * quantity;

  String get timeAdded =>
      '${addedAt.hour}:${addedAt.minute.toString().padLeft(2, '0')}';
}
