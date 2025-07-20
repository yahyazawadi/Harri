import 'package:online_store/prompt.dart';
import 'package:online_store/factory.dart';
import 'package:online_store/inventory_manager.dart';
import 'package:online_store/orders/order_item.dart';
import 'package:online_store/orders/orders_manager.dart';
import 'package:online_store/products/product.dart';

void main() {
  final InventoryManager<Product> inventory = InventoryManager<Product>();
  final OrderManager orderManager = OrderManager(inventory);

  void showMainMenu() {
    print('''
=== Online Store ===
1. Inventory Management
2. Order Management
0. Exit
''');
  }

  void inventoryMenu() {
    while (true) {
      print('''
=== Inventory Management ===
1. Add Product
2. List Products
3. Restock Product
4. Reduce Stock
5. Remove Product
0. Back to Main Menu
''');
      final choice = Prompt.enter('Select: ');

      switch (choice) {
        case '1':
          inventory.addProductInteractive();
          break;
        case '2':
          inventory.listProducts();
          break;
        case '3':
          inventory.restockProduct();
          break;
        case '4':
          inventory.reduceStock();
          break;
        case '5':
          inventory.removeProduct();
          break;
        case '0':
          return;
        default:
          print('Error: Invalid selection');
      }
    }
  }

  void orderMenu() {
    while (true) {
      final hasItems = orderManager.items.isNotEmpty;

      print('''
=== Order Management ===
${hasItems ? 'Current Order:' : 'No items in order'}
${hasItems ? orderManager.items.map((item) => "- ${item.quantity}x ${item.product.name}").join('\n') : ''}
${hasItems ? 'Total: \$${orderManager.orderTotal.toStringAsFixed(2)}\n' : ''}
1. Add Item
2. Remove Item
3. Checkout
4. Cancel Order
0. Back to Main Menu
''');
      final choice = Prompt.enter('Select: ');

      switch (choice) {
        case '1':
          orderManager.addToOrderInteractive();
          break;
        case '2':
          orderManager.removeAtInteractive();
          break;
        case '3':
          orderManager.checkout();
          break;
        case '4':
          orderManager.cancelOrder();
          break;
        case '0':
          return;
        default:
          print('Error: Invalid selection');
      }
    }
  }

  while (true) {
    showMainMenu();
    switch (Prompt.enter('Select: ')) {
      case '1':
        inventoryMenu();
        break;
      case '2':
        orderMenu();
        break;
      case '0':
        print('Exiting...');
        return;
      default:
        print('Error: Invalid selection');
    }
  }
}
