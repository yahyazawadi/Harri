import 'package:online_store/products/product.dart';
import 'package:online_store/prompt.dart';

enum SwitchType { mechanical, membrane, optical }

class Keyboard extends Product {
  final SwitchType switchType;
  final bool isBacklit;
  final String layout;
  final int keyCount;
  final String? languages;

  Keyboard({
    required super.id,
    required super.name,
    required super.price,
    required super.quantity,
    required this.switchType,
    required this.isBacklit,
    required this.layout,
    required this.keyCount,
    required this.languages,
    super.manufacturer,
    super.description,
  }) : super(category: 'Electronics');

  @override
  double discount() {
    double discount = 0.0;
    if (switchType == SwitchType.mechanical) {
      discount += price * 0.15;
    }

    if (isBacklit) {
      discount += price * 0.03;
    }

    return discount;
  }

  @override
  String listingInfo() {
    return '''
Keyboard: $name (ID: $id)
- Price: \$${price.toStringAsFixed(2)} 
  (After discount: \$${finalPrice().toStringAsFixed(2)})
- Switch Type: $switchType
- Backlit: ${isBacklit ? 'Yes' : 'No'}
- Layout: $layout
- Key Count: $keyCount
- Manufacturer: ${manufacturer ?? 'Not specified'}
- In stock: $quantity
${description != null ? '- Description: $description' : ''}
''';
  }

  static Keyboard create() {
    print('\n=== Add New Keyboard ===');

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final name = Prompt.enter('Product name: ');
    final price = double.parse(Prompt.enter('Price: '));
    final quantity = int.parse(Prompt.enter('Initial stock quantity: '));

    final switchTypeInput =
        Prompt.enter(
          'Switch type (mechanical, membrane, optical): ',
        ).toLowerCase();
    final SwitchType switchType;
    if (switchTypeInput == 'mechanical') {
      switchType = SwitchType.mechanical;
    } else if (switchTypeInput == 'membrane') {
      switchType = SwitchType.membrane;
    } else if (switchTypeInput == 'optical') {
      switchType = SwitchType.optical;
    } else {
      // Default to mechanical if input doesn't match
      switchType = SwitchType.mechanical;
    }

    final backlitInput = Prompt.enter('Is it backlit? (y/n): ').toLowerCase();
    final isBacklit = backlitInput == 'y';

    final layout = Prompt.enter('Keyboard layout (e.g., QWERTY, AZERTY): ');

    final keyCount = int.parse(Prompt.enter('Number of keys: '));

    final language = Prompt.enter('Language (leave blank if none): ');

    final manufacturer = Prompt.enter('Manufacturer (leave blank if none): ');
    final description = Prompt.enter('Description (leave blank if none): ');

    return Keyboard(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
      switchType: switchType,
      isBacklit: isBacklit,
      layout: layout,
      keyCount: keyCount,
      languages: language.isNotEmpty ? language : null,
      manufacturer: manufacturer.isNotEmpty ? manufacturer : null,
      description: description.isNotEmpty ? description : null,
    );
  }
}
