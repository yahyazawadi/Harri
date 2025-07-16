import 'package:online_store/products/product.dart';
import 'package:online_store/products/prompt.dart';

enum ShoeType { sneakers, boots, sandals, formal }

class Shoe extends Product {
  final int size;
  final ShoeType type;
  final String? color;

  Shoe({
    required super.id,
    required super.name,
    required super.price,
    required super.quantity,
    required this.size,
    required this.type,
    this.color,
    super.manufacturer,
    super.description,
  }) : super(category: 'Footwear');

  @override
  double discount() {
    return type == ShoeType.sneakers ? price * 0.05 : 0.0;
  }

  @override
  String listingInfo() {
    return '''
Shoe: $name (ID: $id)
- Price: \$${price.toStringAsFixed(2)} (After discount: \$${finalPrice().toStringAsFixed(2)})
- Size: $size
- Type: ${type.name}
- Color: ${color ?? 'Not specified'}
- Manufacturer: ${manufacturer ?? 'Not specified'}
- In stock: $quantity
${description != null ? '- Description: $description' : ''}
''';
  }

  @override
  Shoe create() {
    print('\n=== Add New Shoe ===');
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final name = Prompt.enter('Shoe name: ');
    final price = double.parse(Prompt.enter('Price: '));
    final quantity = int.parse(Prompt.enter('Initial stock quantity: '));

    print('Select Size (38-45): ');
    final size = int.parse(Prompt.enter('Enter size: '));

    print('Select Type: 1) Sneakers 2) Boots 3) Sandals 4) Formal');
    final typeChoice = int.parse(Prompt.enter('Enter choice: '));
    final type = ShoeType.values[typeChoice - 1];

    final colorInput = Prompt.enter('Color (leave blank if none): ');
    final manufacturerInput = Prompt.enter(
      'Manufacturer (leave blank if none): ',
    );
    final descriptionInput = Prompt.enter(
      'Description (leave blank if none): ',
    );

    return Shoe(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
      size: size,
      type: type,
      color: colorInput.isNotEmpty ? colorInput : null,
      manufacturer: manufacturerInput.isNotEmpty ? manufacturerInput : null,
      description: descriptionInput.isNotEmpty ? descriptionInput : null,
    );
  }
}
