import 'package:flutter/material.dart';
import '../models/product.dart';

// Cart page - Display and manage selected products
class CartPage extends StatefulWidget {
  final List<Product> initialItems;

  const CartPage({super.key, required this.initialItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Product> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = List<Product>.from(widget.initialItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.separated(
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: SizedBox(
                    width: 48,
                    height: 48,
                    child: item.image.isNotEmpty
                        ? Image.network(item.image, fit: BoxFit.contain)
                        : const Icon(Icons.image),
                  ),
                  title: Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('\$${item.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        cartItems.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, cartItems);
          },
          child: const Text('Back to Catalog'),
        ),
      ),
    );
  }
}
