import 'package:fashion_app/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubCategoryScreen extends StatelessWidget {
  final String category;

  const SubCategoryScreen({super.key, required this.category});

  static const Map<String, List<String>> _subcategories = {
    'men': [
      'Casual Shirt',
      'Formal Shirt',
      'T-Shirt',
      'Jeans',
      'Formal Pant',
      'Pant Shirt Fabric Gift Set',
      'Night Pant',
      'Shirts',
      'Underwear',
      'Vest / Sandow',
      'Lungi / Loungy',
      'Dhoti / Panchha',
      'Towel',
    ],
    'women': [
      'Saree',
      'Chudidar',
      'Long Gown',
      'Ghagra Set',
      'Sharara Set',
      'Jeans Top',
      'Kurtis',
      'Leggings',
      'Plazo Pant',
      'Skirt',
      'Patiala Pants',
      'Saree Petticoat',
      'Blouse',
      'Nighty / Night Suit',
      'Dupatta / Stole',
      'Bra / Panties / Slips / Tights',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final subs = _subcategories[category] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(category.toUpperCase()),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (_, i) {
          final sub = subs[i];

          return GestureDetector(
            onTap: () {
  context.push(
    AppRoutes.productList,
    extra: {
      "category": category,
      "subcategory": sub,
    },
  );
},
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
                 boxShadow: [
                  BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0,3),
                      )
                   ],
              ),
              child: Center(
                child: Text(
                  sub,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}