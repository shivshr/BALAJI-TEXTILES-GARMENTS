import 'package:fashion_app/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fashion_app/screens/home/subcategory_screen.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  static const List<Map<String, dynamic>> _categories = [
  {
    'label': 'MEN',
    'sub': 'Top Wear',
    'key': 'men',
    'image': 'assets/images/categories/men.jpg'
  },
  {
    'label': 'WOMEN',
    'sub': 'Trending',
    'key': 'women',
    'image': 'assets/images/categories/women.jpg'
  },
  {
    'label': 'KIDS',
    'sub': 'Cute Styles',
    'key': 'kids',
    'image': 'assets/images/categories/kids.jpg'
  },
  {
    'label': 'ETHNIC',
    'sub': 'Festive Wear',
    'key': 'ethnic',
    'image': 'assets/images/categories/ethnic.jpg'
  },
];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final cat = _categories[i];
          return GestureDetector(
            onTap: () {
  if (cat['key'] == 'kids') {
  context.push(AppRoutes.kidsCategory);
} else if (cat['key'] == 'men' || cat['key'] == 'women') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => SubCategoryScreen(category: cat['key']),
    ),
  );
} else {
  context.push(AppRoutes.productList, extra: cat['key']);
}
},
            child: Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    image: DecorationImage(
      image: AssetImage(cat['image']),
      fit: BoxFit.cover,
    ),
  ),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [
          Colors.black.withOpacity(0.5),
          Colors.transparent
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
    ),
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          cat['label'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          cat['sub'],
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    ),
  ),
)
          );
        },
      ),
    );
  }
}
