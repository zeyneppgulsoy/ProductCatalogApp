import 'package:flutter/material.dart';
import '../models/product.dart';

// Product card widget - Display single product
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image area
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey[200],
                child: product.image.isNotEmpty
                    ? Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.low,
                        cacheWidth: 320,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 42);
                        },
                      )
                    : const Icon(Icons.image, size: 42),
              ),
            ),
            // Product info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
