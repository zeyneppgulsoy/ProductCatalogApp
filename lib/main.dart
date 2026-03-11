import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> productsFuture;
  final ScrollController _scrollController = ScrollController();

  void _scrollBy(double offset) {
    if (!_scrollController.hasClients) return;
    final target = (_scrollController.offset + offset).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    productsFuture = fetchProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<Product>> fetchProducts() async {
    const laptopsUrl = 'https://dummyjson.com/products/category/laptops';
    const tabletsUrl = 'https://dummyjson.com/products/category/tablets';

    final responses = await Future.wait([
      http.get(Uri.parse(laptopsUrl)),
      http.get(Uri.parse(tabletsUrl)),
    ]);

    if (responses[0].statusCode != 200 || responses[1].statusCode != 200) {
      throw Exception('Failed to load products');
    }

    final laptopsData = jsonDecode(responses[0].body) as Map<String, dynamic>;
    final tabletsData = jsonDecode(responses[1].body) as Map<String, dynamic>;

    final laptops = (laptopsData['products'] as List)
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();

    final tablets = (tabletsData['products'] as List)
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();

    return [...laptops, ...tablets];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Catalog')),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'scroll_up',
            onPressed: () => _scrollBy(-320),
            child: const Icon(Icons.keyboard_arrow_up),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'scroll_down',
            onPressed: () => _scrollBy(320),
            child: const Icon(Icons.keyboard_arrow_down),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load products'));
          }

          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          return Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            thickness: 6,
            radius: const Radius.circular(10),
            interactive: true,
            child: GridView.builder(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              cacheExtent: 900,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.72,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
