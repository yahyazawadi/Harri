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
  bool get hasActiveOrder => _items.isNotEmpty;

  // PTIVATE METHODS
  void _addToOrder(Product product, int quantity) {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be positive');
    }

    if (quantity > product.quantity) {
      throw ArgumentError(
        'Only ${product.quantity} ${product.name}(s) available (tried to add $quantity)',
      );
    }

    _inventory.decreaseStockForOrder(product.name, quantity);
    _items.add(OrderItem(product, quantity));
    _createdAt ??= DateTime.now();
  }

  OrderItem _removeAt(int index) {
    if (index < 0 || index >= _items.length) {
      throw RangeError('Index $index out of bounds (0-${_items.length - 1})');
    }

    final removed = _items.removeAt(index);
    _inventory.increaseStockForOrder(removed.product.name, removed.quantity);
    return removed;
  }

  void _checkout() {
    if (_items.isEmpty) {
      throw StateError('Cannot checkout an empty order');
    }
    _items.clear();
    _createdAt = null;
  }

  void _cancelOrder() {
    for (var item in _items) {
      _inventory.increaseStockForOrder(item.product.name, item.quantity);
    }
    _items.clear();
    _createdAt = null;
  }

  // INTERACTIVE Methods
  void addToOrderInteractive() {
    if (_inventory.products.isEmpty) {
      print('! No products available');
      return;
    }

    print('\n=== Add to Order ===');
    _inventory.listProducts();

    try {
      String? productName;
      while (productName == null) {
        final input = Prompt.enter(
          'Enter product name (or "back" to cancel): ',
        );

        if (input.toLowerCase() == 'back') {
          print('Operation cancelled.');
          return;
        }

        if (_inventory.containsProduct(input)) {
          productName = input;
        } else {
          print('error: Product not found: $input');
        }
      }

      final product = _inventory.getProduct(productName)!;

      int? quantity;
      while (quantity == null) {
        final input = Prompt.enter(
          'Enter quantity (${product.quantity} available): ',
        );

        if (input.toLowerCase() == 'back') {
          print('Operation cancelled.');
          return;
        }

        final value = int.tryParse(input);
        if (value == null || value <= 0) {
          print('error: Must be a positive integer');
          continue;
        }

        if (value > product.quantity) {
          print('error: Only ${product.quantity} available');
          continue;
        }

        quantity = value;
      }

      _addToOrder(product, quantity);
      print('✓ Added $quantity x ${product.name} to order');
    } catch (e) {
      print('error: $e');
    }
  }

  void removeAtInteractive() {
    if (_items.isEmpty) {
      print('! No items in order');
      return;
    }

    print('\n=== Remove from Order ===');
    print('Current Order Items:');
    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      print('${i + 1}. ${item.quantity}x ${item.product.name}');
    }

    try {
      int? selectedIndex;
      while (selectedIndex == null) {
        final input = Prompt.enter(
          'Enter item number (1-${_items.length}) or "back" to cancel: ',
        );

        if (input.toLowerCase() == 'back') {
          print('Operation cancelled.');
          return;
        }

        final index = int.tryParse(input);
        if (index == null || index < 1 || index > _items.length) {
          print('[Error] Enter a number between 1 and ${_items.length}');
          continue;
        }

        selectedIndex = index - 1;
      }

      final removed = _removeAt(selectedIndex);
      print('✓ Removed ${removed.quantity}x ${removed.product.name}');
    } catch (e) {
      print('[Error] $e');
    }
  }

  void checkoutInteractive() {
    if (_items.isEmpty) {
      print('! No items in order');
      return;
    }

    print('\n=== Checkout ===');
    _printOrderSummary();

    final confirm = Prompt.enter('Confirm checkout? (y/n): ').toLowerCase();

    if (confirm != 'y') {
      print('Checkout cancelled');
      return;
    }

    try {
      _checkout();
      print('✓ Order placed successfully!');
    } catch (e) {
      print('error: Checkout failed: $e');
    }
  }

  void cancelOrderInteractive() {
    if (_items.isEmpty) {
      print('! No active order');
      return;
    }

    print('\n=== Cancel Order ===');
    print('This will restore ${_items.length} items to inventory');

    final confirm = Prompt.enter('Confirm cancellation? (y/n): ').toLowerCase();

    if (confirm != 'y') {
      print('Cancellation aborted');
      return;
    }

    try {
      _cancelOrder();
      print('✓ Order cancelled - inventory restored');
    } catch (e) {
      print('error: Cancellation failed: $e');
    }
  }

  // UTILITY METHODS
  double get orderTotal =>
      _items.fold(0.0, (sum, item) => sum + item.itemTotal);

  void _printOrderSummary() {
    print('=== ORDER SUMMARY ===');
    print('Created At: ${_createdAt?.toString() ?? 'N/A'}');
    print('─' * 40);

    double totalSavings = 0.0;
    double subtotal = 0.0;

    for (var item in _items) {
      final discount = item.product.discount();
      final lineTotal = item.itemTotal;
      final savings = discount * item.quantity;
      totalSavings += savings;
      subtotal += item.product.price * item.quantity;

      print('${item.quantity} x ${item.product.name}');
      print('  Price:      \$${item.product.price.toStringAsFixed(2)}');
      print('  Discount:   \$${discount.toStringAsFixed(2)} per item');
      print('  Line Total: \$${lineTotal.toStringAsFixed(2)}');
      print('─' * 40);
    }

    print('SUBTOTAL:    \$${subtotal.toStringAsFixed(2)}');
    print('DISCOUNTS:   \$${totalSavings.toStringAsFixed(2)}');
    print('TOTAL:       \$${orderTotal.toStringAsFixed(2)}');
    print('─' * 40);
  }
}
