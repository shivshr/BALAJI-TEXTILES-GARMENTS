// import 'package:fashion_app/models/product_model.dart';
// import 'package:fashion_app/services/product_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final productServiceProvider = Provider<ProductService>((ref) => ProductService());

// final featuredProductsProvider = StreamProvider<List<ProductModel>>((ref) {
//   return ref.watch(productServiceProvider).streamFeaturedProducts();
// });

// final allProductsProvider = StreamProvider<List<ProductModel>>((ref) {
//   return ref.watch(productServiceProvider).streamAllProducts();
// });

// final productsByCategoryProvider = StreamProvider.family<List<ProductModel>, String>((ref, category) {
//   return ref.watch(productServiceProvider).streamProductsByCategory(category);
// });

// final singleProductProvider = FutureProvider.family<ProductModel?, String>((ref, productId) {
//   return ref.watch(productServiceProvider).getProduct(productId);
// });

// final searchQueryProvider = StateProvider<String>((ref) => '');
// final searchCategoryProvider = StateProvider<String?>((ref) => null);
// final searchInStockOnlyProvider = StateProvider<bool>((ref) => false);
// final searchMinPriceProvider = StateProvider<double?>((ref) => null);
// final searchMaxPriceProvider = StateProvider<double?>((ref) => null);

// final searchResultsProvider = FutureProvider<List<ProductModel>>((ref) async {
//   final query = ref.watch(searchQueryProvider);
//   final category = ref.watch(searchCategoryProvider);
//   final inStockOnly = ref.watch(searchInStockOnlyProvider);
//   final minPrice = ref.watch(searchMinPriceProvider);
//   final maxPrice = ref.watch(searchMaxPriceProvider);

//   if (query.isEmpty && category == null) return [];

//   return ref.watch(productServiceProvider).searchProducts(
//         query: query.isEmpty ? null : query,
//         category: category,
//         minPrice: minPrice,
//         maxPrice: maxPrice,
//         inStockOnly: inStockOnly,
//       );
// });

// // Admin
// final adminProductsProvider = StreamProvider<List<ProductModel>>((ref) {
//   return ref.watch(productServiceProvider).streamAdminProducts();
// });


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

// Kids filter by gender + age_group
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

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchCategoryProvider = StateProvider<String?>((ref) => null);
final searchInStockOnlyProvider = StateProvider<bool>((ref) => false);
final searchMinPriceProvider = StateProvider<double?>((ref) => null);
final searchMaxPriceProvider = StateProvider<double?>((ref) => null);

final searchResultsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final category = ref.watch(searchCategoryProvider);
  final inStockOnly = ref.watch(searchInStockOnlyProvider);
  final minPrice = ref.watch(searchMinPriceProvider);
  final maxPrice = ref.watch(searchMaxPriceProvider);

  if (query.isEmpty && category == null) return [];

  return ref.watch(productServiceProvider).searchProducts(
        query: query.isEmpty ? null : query,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        inStockOnly: inStockOnly,
      );
});

final adminProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  return ref.watch(productServiceProvider).streamAdminProducts();
});