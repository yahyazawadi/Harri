import 'package:online_store/products/product.dart';
import 'package:online_store/prompt.dart';

enum ConnectivityType { wired, wireless, hybrid }

class Headphone extends Product {
  final ConnectivityType connectivityType;
  final bool hasNoiseCancellation;
  final double driverSize;
  final String? color;

  Headphone({
    required super.id,
    required super.name,
    required super.price,
    required super.quantity,
    required this.connectivityType,
    required this.hasNoiseCancellation,
    required this.driverSize,
    this.color,
    super.manufacturer,
    super.description,
  }) : super(category: 'Electronics');

  @override
  double discount() {
    double discountAmount = 0.0;

    if (hasNoiseCancellation) {
      discountAmount += price * 0.10;
    }
    if (connectivityType == ConnectivityType.wireless) {
      discountAmount += price * 0.05;
    } else {
      discountAmount += price * 0.05;
    }
    return discountAmount;
  }

  @override
  String listingInfo() {
    return '''
Headphone: $name (ID: $id)
- Connectivity: ${connectivityType.toString().split('.').last}
  (After discount: \$${finalPrice().toStringAsFixed(2)})
- Connectivity: $connectivityType
- Noise Cancellation: ${hasNoiseCancellation ? 'Yes' : 'No'}
- Driver Size: ${driverSize}mm
- Color: ${color ?? 'Not specified'}
- Manufacturer: ${manufacturer ?? 'Not specified'}
- In stock: $quantity
${description != null ? '- Description: $description' : ''}
''';
  }

  static Headphone create() {
    print('\n=== Add New Headphone ===');

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final name = Prompt.enter('Product name: ');
    final price = double.parse(Prompt.enter('Price: '));
    final quantity = int.parse(Prompt.enter('Initial stock quantity: '));

    print('Connectivity type (1: Wired, 2: Wireless, 3: Hybrid): ');
    final connectivityChoice = int.parse(Prompt.enter('Enter choice: '));
    ConnectivityType connectivityType;
    switch (connectivityChoice) {
      case 1:
        connectivityType = ConnectivityType.wired;
        break;
      case 2:
        connectivityType = ConnectivityType.wireless;
        break;
      case 3:
        connectivityType = ConnectivityType.hybrid;
        break;
      default:
        connectivityType = ConnectivityType.wired;
        print('Invalid choice, defaulting to Wired.');
    }

    final noiseInput =
        Prompt.enter('Has noise cancellation? (y/n): ').toLowerCase();
    final hasNoiseCancellation = noiseInput == 'y';

    final driverSize = double.parse(Prompt.enter('Driver size (in mm): '));

    final color = Prompt.enter('Color (leave blank if none): ');
    final manufacturer = Prompt.enter('Manufacturer (leave blank if none): ');
    final description = Prompt.enter('Description (leave blank if none): ');

    return Headphone(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
      connectivityType: connectivityType,
      hasNoiseCancellation: hasNoiseCancellation,
      driverSize: driverSize,
      color: color.isNotEmpty ? color : null,
      manufacturer: manufacturer.isNotEmpty ? manufacturer : null,
      description: description.isNotEmpty ? description : null,
    );
  }
}
