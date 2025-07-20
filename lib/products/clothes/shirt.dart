import 'package:online_store/products/product.dart';
import 'package:online_store/prompt.dart';

enum ShirtSize { xs, s, m, l, xl, xxl }

enum ShirtSleeveType { shortSleeve, longSleeve }

enum ShirtFit { slim, regular, loose }

class Shirt extends Product {
  final ShirtSize size;
  final ShirtSleeveType sleeveType;
  final ShirtFit fit;
  final String? color;

  Shirt({
    required super.name,
    required super.price,
    required super.quantity,
    required this.size,
    required this.sleeveType,
    required this.fit,
    this.color,
    super.manufacturer,
    super.description,
  }) : super(category: 'clothes');

  @override
  double discount() {
    return fit == ShirtFit.slim ? price * 0.10 : 0.0;
  }

  @override
  String listingInfo() {
    return '''
Shirt: $name
- Price: \$${price.toStringAsFixed(2)} 
(After discount: \$${finalPrice().toStringAsFixed(2)})
- Size: ${size.name.toUpperCase()}
- Sleeve Type: ${sleeveType.name}
- Fit: ${fit.name}
- Color: ${color ?? 'Not specified'}
- Manufacturer: ${manufacturer ?? 'Not specified'}
- In stock: $quantity
${description != null ? '- Description: $description' : ''}
''';
  }

  static Shirt create() {
    print('\n=== Add New Shirt ===');
    final name = Prompt.enter('Shirt name: ');
    final price = double.parse(Prompt.enter('Price: '));
    final quantity = int.parse(Prompt.enter('Initial stock quantity: '));

    print('Select Size: 1) XS 2) S 3) M 4) L 5) XL 6) XXL');
    final sizeChoice = int.parse(Prompt.enter('Enter choice: '));
    final size = ShirtSize.values[sizeChoice - 1];

    print('Select Sleeve Type: 1) Short Sleeve 2) Long Sleeve');
    final sleeveChoice = int.parse(Prompt.enter('Enter choice: '));
    final sleeveType = ShirtSleeveType.values[sleeveChoice - 1];

    print('Select Fit: 1) Slim 2) Regular 3) Loose');
    final fitChoice = int.parse(Prompt.enter('Enter choice: '));
    final fit = ShirtFit.values[fitChoice - 1];

    final colorInput = Prompt.enter('Color (leave blank if none): ');
    final manufacturerInput = Prompt.enter(
      'Manufacturer (leave blank if none): ',
    );
    final descriptionInput = Prompt.enter(
      'Description (leave blank if none): ',
    );

    return Shirt(
      name: name,
      price: price,
      quantity: quantity,
      size: size,
      sleeveType: sleeveType,
      fit: fit,
      color: colorInput.isNotEmpty ? colorInput : null,
      manufacturer: manufacturerInput.isNotEmpty ? manufacturerInput : null,
      description: descriptionInput.isNotEmpty ? descriptionInput : null,
    );
  }
}
