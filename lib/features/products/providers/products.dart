import 'package:rearch/rearch.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' hide AsyncValue;

import '../../../services/api/api_service.dart';
import '../models/product.dart';

part 'products.g.dart';

@riverpod
Future<List<Product>> products(ProductsRef ref) =>
    ref.watch(apiServiceProvider).fetchProducts();

(AsyncValue<List<Product>>, void Function()) productsCapsule(
  CapsuleHandle use,
) {
  // TODO: Refresh function must return a future.
  // TODO: Implement auto dispose.
  final apiService = use(apiServiceCapsule);
  return use.refreshableFuture(() => apiService.fetchProducts());
}
