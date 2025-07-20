import 'package:online_store/products/product.dart';
import 'package:online_store/prompt.dart';
import 'package:online_store/factory.dart';

class InventoryManager<T extends Product> {
  final Map<String, T> _products = {};

  T? getProduct(String name) => _products[name];
  Map<String, T> get products => Map.unmodifiable(_products);
  bool containsProduct(String name) => _products.containsKey(name);

  //PRIVATE METHODS
  void _addProduct(T product) {
    if (containsProduct(product.name)) {
      throw ArgumentError(
        'A product with name "${product.name}" already exists',
      );
    }
    _products[product.name] = product;
    print('Added: ${product.name} (${product.category})');
  }

  void _removeProduct(String name) {
    if (!containsProduct(name)) {
      throw ArgumentError('Product not found: $name');
    }
    _products.remove(name);
    print('Removed: $name');
  }

  void _updateStock(String name, int amount, {bool increase = true}) {
    final product = getProduct(name);
    if (product == null) {
      throw ArgumentError('Product not found: $name');
    }

    if (increase) {
      product.increaseQuantity(amount);
    } else {
      product.decreaseQuantity(amount);
    }
  }

  //Data handling methods
  void decreaseStockForOrder(String productName, int amount) {
    final product = getProduct(productName);
    if (product == null) {
      throw ArgumentError('Product not found: $productName');
    }

    if (amount <= 0) {
      throw ArgumentError('Decrease amount must be positive');
    }

    if (amount > product.quantity) {
      throw ArgumentError(
        'Only ${product.quantity} ${product.name}(s) available (tried to decrease by $amount)',
      );
    }

    product.decreaseQuantity(amount);
  }

  void increaseStockForOrder(String productName, int amount) {
    final product = getProduct(productName);
    if (product == null) {
      throw ArgumentError('Product not found: $productName');
    }

    if (amount <= 0) {
      throw ArgumentError('Increase amount must be positive');
    }

    product.increaseQuantity(amount);
  }

  // INTERACTIVE METHODS

  void addProductInteractive() {
    print('\n=== Add New Product ===');

    try {
      String? productType;
      while (productType == null) {
        print('Available types: ${ProductFactory.availableTypes().join(', ')}');
        final input = Prompt.enter(
          'Enter product type (or "back" to cancel): ',
        );

        if (input.toLowerCase() == 'back') {
          print('Operation cancelled.');
          return;
        }

        if (ProductFactory.availableTypes().contains(input.toLowerCase())) {
          productType = input;
        } else {
          print('error: Invalid product type: $input');
        }
      }

      T? product;
      while (product == null) {
        try {
          final newProduct = ProductFactory.createProduct(productType) as T;

          while (true) {
            try {
              _addProduct(newProduct);
              product = newProduct;
              return;
            } on ArgumentError catch (e) {
              print('error: ${e.message}');
              final rename =
                  Prompt.enter('Rename this product? (y/n): ').toLowerCase();

              if (rename != 'y') {
                throw Exception('Product creation cancelled');
              }

              newProduct.name = Prompt.enter('Enter new name: ');
            }
          }
        } catch (e) {
          print('error: $e');
          final retry = Prompt.enter('Try again? (y/n): ').toLowerCase();

          if (retry != 'y') {
            throw Exception('Product creation cancelled');
          }
        }
      }
    } catch (e) {
      print(
        '[Operation Failed] ${e.toString().replaceFirst('Exception: ', '')}',
      );
    }
  }

  void removeProductInteractive() {
    if (_products.isEmpty) {
      print('! No products available to remove');
      return;
    }

    print('\n=== Remove Product ===');
    listProducts();

    try {
      String? productName;
      while (productName == null) {
        final input = Prompt.enter(
          'Enter product name to remove (or "back" to cancel): ',
        );

        if (input.toLowerCase() == 'back') {
          print('Operation cancelled.');
          return;
        }

        if (containsProduct(input)) {
          productName = input;
        } else {
          print('error: Product not found: $input');
        }
      }

      _removeProduct(productName);
    } catch (e) {
      print('error: $e');
    }
  }

  void restockProductInteractive() {
    if (_products.isEmpty) {
      print('! No products available to restock');
      return;
    }

    print('\n=== Restock Product ===');
    listProductsForRestocking();

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

        if (containsProduct(input)) {
          productName = input;
        } else {
          print('error: Product not found: $input');
        }
      }

      int? amount;
      while (amount == null) {
        final input = Prompt.enter('Enter amount to add: ');

        if (input.toLowerCase() == 'back') {
          print('Operation cancelled.');
          return;
        }

        final value = int.tryParse(input);
        if (value == null || value <= 0) {
          print('error: Must be a positive integer');
          continue;
        }

        amount = value;
      }

      _updateStock(productName, amount, increase: true);
      print('Restocked $productName with $amount items');
    } catch (e) {
      print('error: $e');
    }
  }

  void reduceStockInteractive() {
    if (_products.isEmpty) {
      print('No products available to reduce');
      return;
    }

    print('\n=== Reduce Stock ===');
    listProductsForRestocking();

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

        if (containsProduct(input)) {
          productName = input;
        } else {
          print('error: Product not found: $input');
        }
      }

      int? amount;
      while (amount == null) {
        final input = Prompt.enter('Enter amount to remove: ');

        if (input.toLowerCase() == 'back') {
          print('Operation cancelled.');
          return;
        }

        final value = int.tryParse(input);
        if (value == null || value <= 0) {
          print('error: the quantity entered must be a positive integer');
          continue;
        }

        final product = getProduct(productName)!;
        if (value > product.quantity) {
          print('error: Only ${product.quantity} available');
          continue;
        }

        amount = value;
      }

      _updateStock(productName, amount, increase: false);
      print('Reduced $productName stock by $amount');
    } catch (e) {
      print('error: $e');
    }
  }

  // LISTING METHODS

  void listProducts() {
    if (_products.isEmpty) {
      print('Inventory is empty.');
      return;
    }
    print('\n=== INVENTORY ===');
    for (var product in _products.values) {
      print(product.listingInfo());
      print('─' * 40);
    }
  }

  void listProductsForRestocking() {
    if (_products.isEmpty) {
      print('Inventory is empty.');
      return;
    }
    print('\n=== STOCK LEVELS ===');
    for (var product in _products.values) {
      print('${product.name}: ${product.quantity} available');
    }
  }
}
