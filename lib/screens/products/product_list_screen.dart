// import 'package:fashion_app/core/constants/app_colors.dart';
// import 'package:fashion_app/providers/product_provider.dart';
// import 'package:fashion_app/widgets/product_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ProductListScreen extends ConsumerWidget {
//   final String? category;
//   const ProductListScreen({this.category, super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final productsAsync = category != null
//         ? ref.watch(productsByCategoryProvider(category!))
//         : ref.watch(allProductsProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(category != null ? category!.toUpperCase() : 'All Products'),
//         actions: [
//           IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () => _showFilter(context, ref)),
//         ],
//       ),
//       body: productsAsync.when(
//         data: (products) {
//           if (products.isEmpty) {
//             return const Center(child: Text('No products found'));
//           }
//           return GridView.builder(
//             padding: const EdgeInsets.all(12),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               mainAxisExtent: 300,
//             ),
//             itemCount: products.length,
//             itemBuilder: (_, i) => ProductCard(product: products[i]),
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text('Error: $e')),
//       ),
//     );
//   }

//   void _showFilter(BuildContext context, WidgetRef ref) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Filter Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
//             const SizedBox(height: 20),
//             SwitchListTile(
//               title: const Text('In Stock Only'),
//               value: ref.read(searchInStockOnlyProvider),
//               activeThumbColor: AppColors.primary,
//               onChanged: (v) => ref.read(searchInStockOnlyProvider.notifier).state = v,
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:fashion_app/core/constants/app_colors.dart';
import 'package:fashion_app/providers/product_provider.dart';
import 'package:fashion_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListScreen extends ConsumerWidget {
  final String? category;
  final Map<String, dynamic>? filters;

  const ProductListScreen({this.category, this.filters, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kids subcategory filter (gender + age_group)
    final isKidsFilter = filters != null && filters!.containsKey('gender');

    final productsAsync = isKidsFilter
        ? ref.watch(productsByKidsFilterProvider(KidsFilter(
            gender: filters!['gender'] as String,
            ageGroup: filters!['age_group'] as String,
          )))
        : category != null
            ? ref.watch(productsByCategoryProvider(category!))
            : ref.watch(allProductsProvider);

    final title = filters?['title'] as String? ??
        (category != null ? category!.toUpperCase() : 'All Products');

    return Scaffold(
      appBar: AppBar(
        title: Text(title.toUpperCase()),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => _showFilter(context, ref),
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No products found', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 300,
            ),
            itemCount: products.length,
            itemBuilder: (_, i) => ProductCard(product: products[i]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showFilter(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('In Stock Only'),
              value: ref.read(searchInStockOnlyProvider),
              activeThumbColor: AppColors.primary,
              onChanged: (v) =>
                  ref.read(searchInStockOnlyProvider.notifier).state = v,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}