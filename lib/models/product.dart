// Product model - Structure product data
class Product {
  final String name;
  final double price;
  final String image;

  Product({required this.name, required this.price, required this.image});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: (json['title'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      image: (json['thumbnail'] ?? '').toString(),
    );
  }
}
