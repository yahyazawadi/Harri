import 'package:online_store/products/product.dart';
import 'package:online_store/prompt.dart';
import 'package:online_store/factory.dart';

class InventoryManager<T extends Product> {
  final Map<String, T> _products = {};

  T? getProduct(String name) => _products[name];

  Map<String, T> get products => Map.unmodifiable(_products);

  bool containsProduct(String name) => _products.containsKey(name);

  //error if a product with the same name already exists.
  void addProduct(T product) {
    if (containsProduct(product.name)) {
      throw ArgumentError(
        'A product with name "${product.name}" already exists',
      );
    }
    _products[product.name] = product;
    print('Added: ${product.name} (${product.category})');
  }

  void addProductInteractive() {
    print('\n=== Add New Product ===');

    // Product type selection with retry
    String? productType;
    while (productType == null) {
      print('Available types: ${ProductFactory.availableTypes().join(', ')}');
      final input = Prompt.enter('Enter product type (or "back" to cancel): ');

      if (input.toLowerCase() == 'back') {
        print('Product creation cancelled.');
        return;
      }

      if (!ProductFactory.availableTypes().contains(input.toLowerCase())) {
        print('[Error] "$input" is not a valid product type');
        continue;
      }

      productType = input;
    }

    // Product creation with retry
    T? product;
    while (product == null) {
      try {
        final newProduct = ProductFactory.createProduct(productType) as T;

        // Handle potential duplicate names
        while (true) {
          try {
            addProduct(newProduct);
            product = newProduct; // Success - exit outer loop
            break;
          } on ArgumentError catch (e) {
            print('[Error] ${e.message}');
            final renameChoice =
                Prompt.enter(
                  'Would you like to rename it? (y/n): ',
                ).toLowerCase();

            if (renameChoice != 'y') {
              print('Product creation cancelled.');
              return;
            }

            final newName = Prompt.enter('Enter new product name: ');
            if (newName.isEmpty) {
              print('Product creation cancelled.');
              return;
            }
            newProduct.name = newName;
          }
        }
      } catch (e) {
        print('[Error] Failed to create product: $e');
        final retry =
            Prompt.enter('Would you like to try again? (y/n): ').toLowerCase();

        if (retry != 'y') {
          print('Product creation cancelled.');
          return;
        }
      }
    }
  }

  void removeProduct() {
    if (_products.isEmpty) {
      print('No products available to remove!');
      return;
    }
    final name = Prompt.enter('Enter product name to remove:');
    if (containsProduct(name)) {
      _products.remove(name);
      print('Removed: $name');
    } else {
      print('[Error] Product not found: $name');
    }
  }

  void listProducts() {
    if (_products.isEmpty) {
      print('Inventory is empty.');
      return;
    }
    print('\nInventory List:');
    for (var product in _products.values) {
      print(product.listingInfo());
    }
  }

  void listProductsForRestocking() {
    if (_products.isEmpty) {
      print('Inventory is empty.');
      return;
    }
    print('\nInventory List:');
    for (var product in _products.values) {
      print(product.listingInfoForStocking());
    }
  }

  void updateStock(String name, int amount, {bool increase = true}) {
    final product = getProduct(name);
    if (product == null) {
      print('[Error] Product not found: $name');
      return;
    }
    try {
      if (increase) {
        product.increaseQuantity(amount);
      } else {
        product.decreaseQuantity(amount);
      }
    } catch (e) {
      print('[Error] $e');
    }
  }

  void restockProduct() {
    if (_products.isEmpty) {
      print('No products to restock. Inventory is empty.');
      return;
    }
    listProductsForRestocking();
    final name = Prompt.enter('Enter product name to restock:');
    if (!containsProduct(name)) {
      print('[Error] Product not found: $name');
      return;
    }
    final amountInput = Prompt.enter('Enter amount to add:');
    final amount = int.tryParse(amountInput) ?? 0;
    if (amount <= 0) {
      print('[Error] Invalid amount');
      return;
    }
    updateStock(name, amount, increase: true);
  }

  void reduceStock() {
    if (_products.isEmpty) {
      print('No products to reduce. Inventory is empty.');
      return;
    }
    listProductsForRestocking();
    final name = Prompt.enter('Enter product name to reduce stock:');
    if (!containsProduct(name)) {
      print('[Error] Product not found: $name');
      return;
    }
    final amountInput = Prompt.enter('Enter amount to remove:');
    final amount = int.tryParse(amountInput) ?? 0;
    if (amount <= 0) {
      print('[Error] Invalid amount');
      return;
    }
    updateStock(name, amount, increase: false);
  }
}
