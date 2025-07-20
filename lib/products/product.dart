abstract class Product {
  String name;
  String category;
  String? manufacturer;
  String? description;
  late double _price;
  late int _quantity;

  double get price => _price;
  set price(double value) {
    if (value < 0) throw ArgumentError('Price cannot be negative');
    _price = value;
  }

  int get quantity => _quantity;
  set quantity(int value) {
    if (value < 0) throw ArgumentError('Quantity cannot be negative');
    _quantity = value;
  }

  //initializer
  Product({
    required this.name,
    required double price,
    required int quantity,
    required this.category,
    this.manufacturer,
    this.description,
  }) {
    this._price = price;
    this._quantity = quantity;
  }
  //abstract methods
  double discount();
  String listingInfo();
  //concrete methods
  String listingInfoForStocking() {
    return '''
    Product: $name
    stock: $quantity''';
  }

  double finalPrice() {
    return price - discount();
  }

  decreaseQuantity(int amount) {
    if (amount < 0) {
      throw ArgumentError('Amount to decrease cannot be negative');
    }
    if (amount > quantity) {
      throw ArgumentError(
        'Cannot decrease quantity by more than available stock',
      );
    }
    quantity -= amount;
    print("Quantity decreased by $amount. New quantity: $quantity");
  }

  increaseQuantity(int amount) {
    if (amount < 0) {
      throw ArgumentError('Amount to increase cannot be negative');
    }
    quantity += amount;
    print('$name quantity increased by $amount. New quantity: $quantity');
  }
}
