import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:go_router/go_router.dart';
import 'package:rearch/rearch.dart';

import '../models/product.dart';
import '../providers/products.dart';

/// A screen showing all products in a list view.
class ProductsScreen extends RearchConsumer {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final products = use(productsCapsule);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement pull-to-refresh.
        },
        child: switch (products) {
          AsyncLoading() => const Center(child: CircularProgressIndicator()),
          AsyncError() => const Center(child: Text('An error occured')),
          AsyncData(:final data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, index) => _ProductListTile(data[index]),
            ),
        },
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  const _ProductListTile(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.go('/products/${product.id}'),
      title: Text(product.title),
      subtitle: Text(product.brand),
    );
  }
}
