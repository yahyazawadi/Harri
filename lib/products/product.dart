abstract class Product {
  String id;
  String name;
  double price;
  int quantity;
  String category;
  String? manufacturer;
  String? description;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
    this.manufacturer,
    this.description,
  }) {
    if (price < 0) {
      throw ArgumentError('Price cannot be negative');
    }
    if (quantity < 0) {
      throw ArgumentError('Quantity cannot be negative');
    }
  }

  String listingInfo();
  double discount();
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
