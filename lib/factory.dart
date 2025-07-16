import 'package:online_store/products/clothes/shirt.dart';
import 'package:online_store/products/clothes/shoe.dart';
import 'package:online_store/products/electronics/headphone.dart';
import 'package:online_store/products/electronics/keyboard.dart';
import 'package:online_store/products/product.dart';

/// A function that creates a [Product] instance interactively.
typedef ProductCreator = Product Function();

/// A factory that builds different [Product] subclasses based on a type key.
class ProductFactory {
  /// Registry mapping lowercase product type names to their creators.
  static final Map<String, ProductCreator> _creators = {
    'headphone': () => Headphone.create(),
    'keyboard': () => Keyboard.create(),
    'shirt': () => Shirt.create(),
    'shoe': () => Shoe.create(),
  };

  /// Creates a product of the given [type], using the registered creator.
  ///
  /// Throws [ArgumentError] if the type is not supported.
  static Product createProduct(String type) {
    final creator = _creators[type.toLowerCase()];
    if (creator == null) {
      throw ArgumentError('Unknown product type: $type');
    }
    return creator();
  }

  /// Returns the list of supported product types.
  static List<String> availableTypes() => _creators.keys.toList();
}
