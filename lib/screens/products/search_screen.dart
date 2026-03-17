// import 'package:fashion_app/core/constants/app_colors.dart';
// import 'package:fashion_app/providers/product_provider.dart';
// import 'package:fashion_app/widgets/product_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SearchScreen extends ConsumerStatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   ConsumerState<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends ConsumerState<SearchScreen> {
//   final _controller = TextEditingController();

//   static const _categories = ['All', 'men', 'women', 'kids', 'ethnic'];
//   String _selectedCat = 'All';

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final resultsAsync = ref.watch(searchResultsProvider);
//     final query        = ref.watch(searchQueryProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: TextFormField(
//           controller: _controller,
//           autofocus: true,
//           decoration: InputDecoration(
//             hintText: 'Search products...',
//             border: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             focusedBorder: InputBorder.none,
//             prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
//             suffixIcon: _controller.text.isNotEmpty
//                 ? IconButton(
//                     icon: const Icon(Icons.clear),
//                     onPressed: () {
//                       _controller.clear();
//                       ref.read(searchQueryProvider.notifier).state = '';
//                     },
//                   )
//                 : null,
//             filled: false,
//           ),
//           onChanged: (v) {
//             setState(() {});
//             ref.read(searchQueryProvider.notifier).state = v;
//           },
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [

//           // Category chips
//           SizedBox(
//             height: 44,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               children: _categories.map((cat) {
//                 final isSelected = _selectedCat == cat;
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8),
//                   child: FilterChip(
//                     label: Text(
//                       cat == 'All' ? 'All' : cat.toUpperCase(),
//                       style: TextStyle(
//                         color: isSelected ? Colors.white : const Color(0xFF0F6C5C),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     selected: isSelected,
//                     backgroundColor: const Color(0xFFE6F7ED),
//                     selectedColor: const Color(0xFF0F6C5C),
//                     checkmarkColor: Colors.white,
//                     side: const BorderSide(color: Color(0xFF0F6C5C), width: 1),
//                     onSelected: (_) {
//                       setState(() => _selectedCat = cat);
//                       ref.read(searchCategoryProvider.notifier).state =
//                           cat == 'All' ? null : cat;
//                     },
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),

//           const SizedBox(height: 4),

//           // Results
//           Expanded(
//             child: resultsAsync.when(
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (e, _) => Center(child: Text('Error: $e')),
//               data: (products) {
//                 // Empty state
//                 if (query.isEmpty && _selectedCat == 'All') {
//                   return const Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.search_outlined, size: 64, color: AppColors.textHint),
//                         SizedBox(height: 12),
//                         Text('Search for products',
//                         style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
//                         SizedBox(height: 6),
//                         Text('Type a name or choose a category',
//                         style: TextStyle(color: AppColors.textHint, fontSize: 13)),
//                       ],
//                     ),
//                   );
//                 }

//                 // No results
//                 if (products.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.search_off, size: 56, color: AppColors.textHint),
//                         const SizedBox(height: 12),
//                         Text(
//                           query.isEmpty
//                               ? 'No products in this category'
//                               : 'No products found for "$query"',
//                           style: const TextStyle(color: AppColors.textSecondary),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 // Grid
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       child: Text(
//                         '${products.length} product${products.length == 1 ? '' : 's'} found',
//                         style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
//                       ),
//                     ),
//                     Expanded(
//                       child: GridView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 12,
//                           mainAxisSpacing: 12,
//                           childAspectRatio: 0.65,
//                         ),
//                         itemCount: products.length,
//                         itemBuilder: (_, i) => ProductCard(product: products[i]),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:balaji_textile_and_garments/core/constants/app_colors.dart';
import 'package:balaji_textile_and_garments/providers/product_provider.dart';
import 'package:balaji_textile_and_garments/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  static const _categories = ['All', 'men', 'women', 'kids', 'ethnic'];
  String _selectedCat = 'All';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchResultsProvider);
    final query        = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                    },
                  )
                : null,
            filled: false,
          ),
          onChanged: (v) {
            setState(() {});
            ref.read(searchQueryProvider.notifier).state = v;
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Category chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _categories.map((cat) {
                final isSelected = _selectedCat == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      cat == 'All' ? 'All' : cat.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF0F6C5C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selected: isSelected,
                    backgroundColor: const Color(0xFFE6F7ED),
                    selectedColor: const Color(0xFF0F6C5C),
                    checkmarkColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF0F6C5C), width: 1),
                    onSelected: (_) {
                      setState(() => _selectedCat = cat);
                      ref.read(searchCategoryProvider.notifier).state =
                          cat == 'All' ? null : cat;
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 4),

          // Results
          Expanded(
            child: resultsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (products) {

                // Show hint only when nothing typed AND no category AND no products loaded yet
                if (query.isEmpty && _selectedCat == 'All' && products.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_outlined, size: 64, color: AppColors.textHint),
                        SizedBox(height: 12),
                        Text('Search for products',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                        SizedBox(height: 6),
                        Text('Type a name or choose a category',
                            style: TextStyle(color: AppColors.textHint, fontSize: 13)),
                      ],
                    ),
                  );
                }

                // No results after search/filter
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off, size: 56, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        Text(
                          query.isEmpty
                              ? 'No products in this category'
                              : 'No products found for "$query"',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                // Grid
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        '${products.length} product${products.length == 1 ? '' : 's'} found',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: products.length,
                        itemBuilder: (_, i) => ProductCard(product: products[i]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}