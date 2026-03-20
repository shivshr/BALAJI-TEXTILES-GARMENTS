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


import 'package:balaji_textile_and_garments/core/constants/app_colors.dart';
import 'package:balaji_textile_and_garments/providers/product_provider.dart';
import 'package:balaji_textile_and_garments/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  final String? category;
  final String? subcategory;
  final Map<String, dynamic>? filters;

  const ProductListScreen({
    this.category,
    this.subcategory,
    this.filters,
    super.key,
  });

  @override
  ConsumerState<ProductListScreen> createState() =>
      _ProductListScreenState();
}

class _ProductListScreenState
    extends ConsumerState<ProductListScreen> {

  String _selectedGenderFilter = 'all';
  String? _selectedAgeFilter;

  final List<String> _ageOptions = [
  '0-3 Months',
  '4-6 Months',
  '7-9 Months',
  '10-12 Months',
  '1-2 Years',
  '3-5 Years',
  '6-8 Years',
  '9-11 Years',
  '12-14 Years',
];

  @override
  Widget build(BuildContext context) {
    final isKidsFilter =
        widget.filters != null && widget.filters!.containsKey('gender');

    final productsAsync = isKidsFilter
        ? ref.watch(productsByKidsFilterProvider(KidsFilter(
            gender: widget.filters!['gender'] as String,
            ageGroup: widget.filters!['age_group'] as String,
          )))
        : (widget.category != null && widget.subcategory != null)
            ? ref.watch(productsBySubCategoryProvider(
                CategoryFilter(
                  category: widget.category!,
                  subcategory: widget.subcategory!,
                ),
              ))
            : widget.category != null
                ? ref.watch(productsByCategoryProvider(widget.category!))
                : ref.watch(allProductsProvider);

    final title = widget.filters?['title'] as String? ??
        (widget.category != null
            ? widget.category!.toUpperCase()
            : 'All Products');

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

          // 🔥 APPLY FILTER LOGIC
          final filteredProducts = products.where((p) {

            // Gender filter
            if (widget.category == 'ethnic' &&
                _selectedGenderFilter != 'all' &&
                p.gender != _selectedGenderFilter) {
              return false;
            }

            // Age filter (only boys/girls)
            if ((_selectedGenderFilter == 'boys' ||
                    _selectedGenderFilter == 'girls') &&
                _selectedAgeFilter != null) {
              return (p.ageGroup ?? '').toLowerCase() ==
       (_selectedAgeFilter ?? '').toLowerCase();
            }

            return true;
          }).toList();

          return Column(
            children: [

              // 🔥 GENDER FILTER BAR
              if (widget.category == 'ethnic')
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      'all',
                      'men',
                      'women',
                      'boys',
                      'girls'
                    ].map((filter) {
                      final isSelected =
                          _selectedGenderFilter == filter;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGenderFilter = filter;
                            _selectedAgeFilter = null; // reset age
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF0F6C5C)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            filter.toUpperCase(),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              // 🔥 AGE FILTER (ONLY FOR BOYS/GIRLS)
             if (_selectedGenderFilter == 'boys' ||
    _selectedGenderFilter == 'girls')
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _ageOptions.map((age) {
        final isSelected = _selectedAgeFilter == age;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedAgeFilter = age;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF0F6C5C)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              age,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    ),
  ),

              // 🔥 PRODUCT GRID / EMPTY STATE
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 60, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('No products found',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 300,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (_, i) =>
                            ProductCard(product: filteredProducts[i]),
                      ),
              ),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showFilter(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Products',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('In Stock Only'),
              value: ref.read(searchInStockOnlyProvider),
              activeThumbColor: AppColors.primary,
              onChanged: (v) => ref
                  .read(searchInStockOnlyProvider.notifier)
                  .state = v,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}