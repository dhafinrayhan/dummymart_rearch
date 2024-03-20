import 'package:rearch/rearch.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' hide AsyncValue;

import '../../../services/api/api_service.dart';
import '../models/product.dart';

part 'products.g.dart';

@riverpod
Future<List<Product>> products(ProductsRef ref) =>
    ref.watch(apiServiceProvider).fetchProducts();

Future<List<Product>> _asyncProductsCapsule(CapsuleHandle use) =>
    use(apiServiceCapsule).fetchProducts();

AsyncValue<List<Product>> productsCapsule(CapsuleHandle use) {
  final delayed = use(_asyncProductsCapsule);
  return use.future(delayed);
}
