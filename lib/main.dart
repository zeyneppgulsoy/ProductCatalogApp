import 'package:flutter/material.dart';
import 'models/product.dart';
import 'widgets/product_card.dart';

void main() {
  runApp(const ProductCatalogApp());
}

// Application root configuration
class ProductCatalogApp extends StatelessWidget {
  const ProductCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Catalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomePage(),
    );
  }
}

// Home page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample products
    final products = [
      Product(name: 'Laptop Pro', price: 1299.99, image: ''),
      Product(name: 'Tablet Plus', price: 599.99, image: ''),
      Product(name: 'Smart Phone', price: 899.99, image: ''),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Product Catalog')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 200,
            child: ProductCard(product: products[index]),
          );
        },
      ),
    );
  }
}
