import 'package:online_store/orders/order_item.dart';
import 'package:online_store/products/product.dart';
import 'package:online_store/inventory_manager.dart';
import 'package:online_store/prompt.dart';

class OrderManager {
  final InventoryManager<Product> _inventory;
  final List<OrderItem> _items = [];
  DateTime? _createdAt;

  OrderManager(this._inventory);

  List<OrderItem> get items => List.unmodifiable(_items);

  DateTime? get createdAt => _createdAt;

  void addToOrder(Product product, int quantity) {
    if (quantity <= 0) {
      print('[Error] Quantity must be positive');
      return;
    }
    if (quantity > product.quantity) {
      throw ArgumentError(
        'Cannot add $quantity ${product.name}(s). Only ${product.quantity} available.',
      );
    }

    try {
      _createdAt ??= DateTime.now();
      _inventory.updateStock(product.name, quantity, increase: false);
      _items.add(OrderItem(product, quantity));
      print('✓ Added $quantity x ${product.name}');
    } catch (e) {
      print('[Error] Failed to add to order: $e');
      rethrow;
    }
  }

  void addToOrderInteractive() {
    if (_inventory.products.isEmpty) {
      print('No products available!');
      return;
    }

    _inventory.listProducts();

    while (true) {
      // Loop until success or escape
      final productName = Prompt.enter(
        'Enter product name (or "back" to cancel): ',
      );
      if (productName.toLowerCase() == 'back') return;

      final product = _inventory.getProduct(productName);
      if (product == null) {
        print('[Error] Product not found');
        continue;
      }

      final qtyInput = Prompt.enter(
        'Enter quantity (${product.quantity} available): ',
      );
      final quantity = int.tryParse(qtyInput) ?? 0;

      try {
        addToOrder(product, quantity);
        return; // Success - exit loop
      } catch (e) {
        print('[Error] $e');
        // Loop will continue and re-prompt
      }
    }
  }

  double get orderTotal =>
      _items.fold(0.0, (sum, item) => sum + item.itemTotal);

  void checkout() {
    if (_items.isEmpty) {
      print('No items in order.');
      return;
    }

    print('\n=== ORDER SUMMARY ===');
    print('Created At: $_createdAt');
    print('---------------------------------');

    var totalSavings = 0.0;
    for (var item in _items) {
      final discountPerUnit = item.product.discount();
      final lineTotal = item.itemTotal;
      final savings = discountPerUnit * item.quantity;
      totalSavings += savings;

      print(
        '${item.quantity} x ${item.product.name} @ '
        '\\${item.product.price.toStringAsFixed(2)} each',
      );
      print('  Discount: \$${discountPerUnit.toStringAsFixed(2)} each');
      print('  Line Total: \$${lineTotal.toStringAsFixed(2)}');
      print('  You Saved: \$${savings.toStringAsFixed(2)}');
      print('---------------------------------');
    }

    print('TOTAL: \$${orderTotal.toStringAsFixed(2)}');
    print('TOTAL SAVINGS: \$${totalSavings.toStringAsFixed(2)}');

    _items.clear();
    _createdAt = null;
    print('\nOrder placed successfully! Inventory updated.');
  }

  void removeAt(int index) {
    if (index < 0 || index >= _items.length) {
      print('[Error] Invalid item index');
      return;
    }
    final removed = _items.removeAt(index);
    _inventory.updateStock(
      removed.product.name,
      removed.quantity,
      increase: true,
    );
    print('Removed ${removed.product.name} x${removed.quantity}');
  }

  void removeAtInteractive() {
    if (_items.isEmpty) {
      print('No items in order to remove!');
      return;
    }

    print('\n=== Current Order ===');
    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      print('${i + 1}. ${item.quantity}x ${item.product.name}');
    }

    while (true) {
      final input = Prompt.enter(
        'Enter item number to remove (1-${_items.length}) or "back" to cancel: ',
      );

      if (input.toLowerCase() == 'back') {
        return;
      }

      final index = int.tryParse(input) ?? -1;
      final adjustedIndex = index - 1;

      if (adjustedIndex < 0 || adjustedIndex >= _items.length) {
        print('[Error] Please enter a number between 1 and ${_items.length}');
        continue;
      }

      try {
        removeAt(adjustedIndex);
        return;
      } catch (e) {
        print('[Error] Failed to remove item: $e');
      }
    }
  }

  void cancelOrder() {
    for (var item in _items) {
      _inventory.updateStock(item.product.name, item.quantity, increase: true);
    }
    _items.clear();
    _createdAt = null;
    print('Order cancelled and inventory restored.');
  }

  String get _timestamp {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }
}
