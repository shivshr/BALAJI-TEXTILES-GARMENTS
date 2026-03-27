import 'package:balaji_textile_and_garments/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Image mapping for subcategories
const Map<String, String> subCategoryImages = {
  "Casual Shirt": "assets/images/subcategories/casual_shirt.jpg",
  "Formal Shirt": "assets/images/subcategories/formal_shirt.jpg",
  "T-Shirt": "assets/images/subcategories/tshirt.png",
  "Jeans": "assets/images/subcategories/jeans.jpg",
  "Formal Pant": "assets/images/subcategories/formal_pant.jpg",
  "Pant Shirt Fabric Gift Set": "assets/images/subcategories/gift_set.jpg",
  "Night Pant": "assets/images/subcategories/night_pant.jpg",
  "Underwear": "assets/images/subcategories/underwear.jpg",
  "Vest / Sandow": "assets/images/subcategories/vest.jpg",
  "Lungi / Loungy": "assets/images/subcategories/lungi.jpg",
  "Dhoti / Panchha": "assets/images/subcategories/dhoti.jpg",
  "Towel": "assets/images/subcategories/towel.jpg",

  // women examples
  "Saree": "assets/images/subcategories/saree.jpg",
  "Chudidar": "assets/images/subcategories/chudidar.jpg",
  "Long Gown": "assets/images/subcategories/long_gown.jpg",
  "Ghagra Set": "assets/images/subcategories/ghagra_set.jpg",
  "Sharara Set": "assets/images/subcategories/sharara_set.jpg",
  "Jeans Top": "assets/images/subcategories/jeans_top.jpg",
  "Kurtis": "assets/images/subcategories/kurtis.jpg",
  "Leggings": "assets/images/subcategories/leggings.jpg",
  "Plazo Pant": "assets/images/subcategories/plazo_pant.jpg",
  "Skirt": "assets/images/subcategories/skirt.jpg",
  "Patiala Pants": "assets/images/subcategories/patiala_pants.jpg",
  "Saree Petticoat": "assets/images/subcategories/petticoat.jpg",
  "Blouse": "assets/images/subcategories/blouse.jpg",
  "Nighty / Night Suit": "assets/images/subcategories/nighty.jpg",
  "Dupatta / Stole": "assets/images/subcategories/dupatta.jpg",
  "Bra / Panties / Slips / Tights": "assets/images/subcategories/innerwear.jpg",
};

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
          childAspectRatio: 1.1,
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
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [

                  /// IMAGE
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                      child: Image.asset(
                        subCategoryImages[sub] ??
                            "assets/images/categories/men.jpg",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  /// TEXT
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      sub,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
