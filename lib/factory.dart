import 'package:online_store/products/clothes/shirt.dart';
import 'package:online_store/products/clothes/shoe.dart';
import 'package:online_store/products/electronics/headphone.dart';
import 'package:online_store/products/electronics/keyboard.dart';
import 'package:online_store/products/product.dart';

typedef ProductCreator = Product Function();

class ProductFactory {
  static final Map<String, ProductCreator> _creators = {
    'headphone': () => Headphone.create(),
    'keyboard': () => Keyboard.create(),
    'shirt': () => Shirt.create(),
    'shoe': () => Shoe.create(),
  };

  static Product createProduct(String type) {
    final creator = _creators[type.toLowerCase()];
    if (creator == null) {
      throw ArgumentError('Unknown product type: $type');
    }
    return creator();
  }

  static List<String> availableTypes() => _creators.keys.toList();
}
