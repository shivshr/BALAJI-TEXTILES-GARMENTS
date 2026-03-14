import 'package:fashion_app/models/product_model.dart';
import 'package:fashion_app/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productServiceProvider = Provider<ProductService>((ref) => ProductService());

final featuredProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  return ref.watch(productServiceProvider).streamFeaturedProducts();
});

final allProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  return ref.watch(productServiceProvider).streamAllProducts();
});

final productsByCategoryProvider = StreamProvider.family<List<ProductModel>, String>((ref, category) {
  return ref.watch(productServiceProvider).streamProductsByCategory(category);
});

// Kids filter
class KidsFilter {
  final String gender;
  final String ageGroup;
  const KidsFilter({required this.gender, required this.ageGroup});

  @override
  bool operator ==(Object other) =>
      other is KidsFilter && other.gender == gender && other.ageGroup == ageGroup;

  @override
  int get hashCode => gender.hashCode ^ ageGroup.hashCode;
}

final productsByKidsFilterProvider = StreamProvider.family<List<ProductModel>, KidsFilter>((ref, filter) {
  return ref.watch(productServiceProvider).streamKidsProducts(
        gender: filter.gender,
        ageGroup: filter.ageGroup,
      );
});

final singleProductProvider = FutureProvider.family<ProductModel?, String>((ref, productId) {
  return ref.watch(productServiceProvider).getProduct(productId);
});

// ── Search providers ──────────────────────────────────────────────────────────
final searchQueryProvider       = StateProvider<String>((ref) => '');
final searchCategoryProvider    = StateProvider<String?>((ref) => null);
final searchInStockOnlyProvider = StateProvider<bool>((ref) => false);

// In-memory prefix search — uses allProductsProvider stream as base
final searchResultsProvider = Provider<AsyncValue<List<ProductModel>>>((ref) {
  final allAsync = ref.watch(allProductsProvider);
  final query    = ref.watch(searchQueryProvider).toLowerCase().trim();
  final category = ref.watch(searchCategoryProvider);

  return allAsync.whenData((all) {
    // Nothing selected — return empty
    if (query.isEmpty && category == null) return all;

    return all.where((p) {
      // Category filter
      final catMatch = category == null || p.category == category;

      // Prefix match on name words
      final nameMatch = query.isEmpty ||
          p.name.toLowerCase().startsWith(query) ||
          p.name.toLowerCase().split(' ').any((w) => w.startsWith(query));

      return catMatch && nameMatch;
    }).toList();
  });
});

// Admin
final adminProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  return ref.watch(productServiceProvider).streamAdminProducts();
});