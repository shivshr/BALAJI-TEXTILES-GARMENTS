// // import 'package:flutter/material.dart';
// // import '../../core/constants/app_routes.dart';
// // import 'package:go_router/go_router.dart';

// // class KidsCategoryScreen extends StatelessWidget {
// //   const KidsCategoryScreen({super.key});

// //   final List<Map<String, String>> girls = const [
// //     {"title": "Girl 0-3M", "image": "assets/kids/g1.webp"},
// //     {"title": "Girl 3-6M", "image": "assets/kids/g2.webp"},
// //     {"title": "Girl 6-12M", "image": "assets/kids/g3.webp"},
// //     {"title": "Girl 1-2Y", "image": "assets/kids/g4.webp"},
// //     {"title": "Girl 2-3Y", "image": "assets/kids/g5.jpeg"},
// //     {"title": "Girl 3-4Y", "image": "assets/kids/g6.jpeg"},
// //     {"title": "Girl 4-5Y", "image": "assets/kids/g7.png"},
// //     {"title": "Girl 5-6Y", "image": "assets/kids/g8.png"},
// //   ];

// //   final List<Map<String, String>> boys = const [
// //     {"title": "Boy 0-3M", "image": "assets/kids/b1.jpg"},
// //     {"title": "Boy 3-6M", "image": "assets/kids/b2.webp"},
// //     {"title": "Boy 6-12M", "image": "assets/kids/b4.webp"},
// //     {"title": "Boy 1-2Y", "image": "assets/kids/b4.webp"},
// //     {"title": "Boy 2-3Y", "image": "assets/kids/b5.jpeg"},
// //     {"title": "Boy 3-4Y", "image": "assets/kids/b6.webp"},
// //     {"title": "Boy 4-5Y", "image": "assets/kids/b7.webp"},
// //     {"title": "Boy 5-6Y", "image": "assets/kids/b8.webp"},
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("KIDS")),
// //       body: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             _section("Girl's Fashion", girls, context),
// //             _section("Boy's Fashion", boys, context),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _section(String title, List data, BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(12),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(title,
// //               style: const TextStyle(
// //                   fontSize: 20, fontWeight: FontWeight.bold)),
// //           const SizedBox(height: 12),
// //           GridView.builder(
// //             shrinkWrap: true,
// //             physics: const NeverScrollableScrollPhysics(),
// //             itemCount: data.length,
// //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //               crossAxisCount: 4,
// //               mainAxisSpacing: 10,
// //               crossAxisSpacing: 10,
// //               childAspectRatio: .8,
// //             ),
// //             itemBuilder: (context, index) {
// //               final item = data[index];

// //               return GestureDetector(
// //                 onTap: () {
// //                   context.push(
// //   AppRoutes.productList,
// //   extra: item["title"],
// // );
// //                 },
// //                 child: Column(
// //                   children: [
// //                     Container(
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(16),
// //                         color: Colors.grey.shade100,
// //                       ),
// //                       padding: const EdgeInsets.all(8),
// //                       child: Image.asset(item["image"]!, height: 70),
// //                     ),
// //                     const SizedBox(height: 6),
// //                     Text(
// //                       item["title"]!,
// //                       textAlign: TextAlign.center,
// //                       style: const TextStyle(fontSize: 12),
// //                     )
// //                   ],
// //                 ),
// //               );
// //             },
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }



// import 'package:flutter/material.dart';
// import '../../core/constants/app_routes.dart';
// import 'package:go_router/go_router.dart';

// class KidsCategoryScreen extends StatelessWidget {
//   const KidsCategoryScreen({super.key});

//   final List<Map<String, String>> girls = const [
//     {"title": "Girl 0-3M",  "image": "assets/kids/g1.webp", "key": "Girl 0-3M"},
//     {"title": "Girl 3-6M",  "image": "assets/kids/g2.webp", "key": "Girl 3-6M"},
//     {"title": "Girl 6-12M", "image": "assets/kids/g3.webp", "key": "Girl 6-12M"},
//     {"title": "Girl 1-2Y",  "image": "assets/kids/g4.webp", "key": "Girl 1-2Y"},
//     {"title": "Girl 2-3Y",  "image": "assets/kids/g5.jpeg", "key": "Girl 2-3Y"},
//     {"title": "Girl 3-4Y",  "image": "assets/kids/g6.jpeg", "key": "Girl 3-4Y"},
//     {"title": "Girl 4-5Y",  "image": "assets/kids/g7.png",  "key": "Girl 4-5Y"},
//     {"title": "Girl 5-6Y",  "image": "assets/kids/g8.png",  "key": "Girl 5-6Y"},
//   ];

//   final List<Map<String, String>> boys = const [
//     {"title": "Boy 0-3M",  "image": "assets/kids/b1.jpg",  "key": "Boy 0-3M"},
//     {"title": "Boy 3-6M",  "image": "assets/kids/b2.webp", "key": "Boy 3-6M"},
//     {"title": "Boy 6-12M", "image": "assets/kids/b4.webp", "key": "Boy 6-12M"},
//     {"title": "Boy 1-2Y",  "image": "assets/kids/b4.webp", "key": "Boy 1-2Y"},
//     {"title": "Boy 2-3Y",  "image": "assets/kids/b5.jpeg", "key": "Boy 2-3Y"},
//     {"title": "Boy 3-4Y",  "image": "assets/kids/b6.webp", "key": "Boy 3-4Y"},
//     {"title": "Boy 4-5Y",  "image": "assets/kids/b7.webp", "key": "Boy 4-5Y"},
//     {"title": "Boy 5-6Y",  "image": "assets/kids/b8.webp", "key": "Boy 5-6Y"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("KIDS")),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _section("Girl's Fashion", girls, context),
//             _section("Boy's Fashion", boys, context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _section(String title, List<Map<String, String>> data, BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: data.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4,
//               mainAxisSpacing: 10,
//               crossAxisSpacing: 10,
//               childAspectRatio: .8,
//             ),
//             itemBuilder: (context, index) {
//               final item = data[index];
//               return GestureDetector(
//                 onTap: () {
//                   context.push(
//                     AppRoutes.productList,
//                     extra: item["key"],
//                   );
//                 },
//                 child: Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         color: Colors.grey.shade100,
//                       ),
//                       padding: const EdgeInsets.all(8),
//                       child: Image.asset(item["image"]!, height: 70),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       item["title"]!,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 12),
//                     )
//                   ],
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../core/constants/app_routes.dart';
import 'package:go_router/go_router.dart';

class KidsCategoryScreen extends StatelessWidget {
  const KidsCategoryScreen({super.key});

  final List<Map<String, String>> girls = const [
    {"title": "Girl 0-3M",  "image": "assets/kids/g1.webp", "gender": "girl", "age_group": "0-3M"},
    {"title": "Girl 3-6M",  "image": "assets/kids/g2.webp", "gender": "girl", "age_group": "3-6M"},
    {"title": "Girl 6-12M", "image": "assets/kids/g3.webp", "gender": "girl", "age_group": "6-12M"},
    {"title": "Girl 1-2Y",  "image": "assets/kids/g4.webp", "gender": "girl", "age_group": "1-2Y"},
    {"title": "Girl 2-3Y",  "image": "assets/kids/g5.jpeg", "gender": "girl", "age_group": "2-3Y"},
    {"title": "Girl 3-4Y",  "image": "assets/kids/g6.jpeg", "gender": "girl", "age_group": "3-4Y"},
    {"title": "Girl 4-5Y",  "image": "assets/kids/g7.png",  "gender": "girl", "age_group": "4-5Y"},
    {"title": "Girl 5-6Y",  "image": "assets/kids/g8.png",  "gender": "girl", "age_group": "5-6Y"},
  ];

  final List<Map<String, String>> boys = const [
    {"title": "Boy 0-3M",  "image": "assets/kids/b1.jpg",  "gender": "boy", "age_group": "0-3M"},
    {"title": "Boy 3-6M",  "image": "assets/kids/b2.webp", "gender": "boy", "age_group": "3-6M"},
    {"title": "Boy 6-12M", "image": "assets/kids/b4.webp", "gender": "boy", "age_group": "6-12M"},
    {"title": "Boy 1-2Y",  "image": "assets/kids/b4.webp", "gender": "boy", "age_group": "1-2Y"},
    {"title": "Boy 2-3Y",  "image": "assets/kids/b5.jpeg", "gender": "boy", "age_group": "2-3Y"},
    {"title": "Boy 3-4Y",  "image": "assets/kids/b6.webp", "gender": "boy", "age_group": "3-4Y"},
    {"title": "Boy 4-5Y",  "image": "assets/kids/b7.webp", "gender": "boy", "age_group": "4-5Y"},
    {"title": "Boy 5-6Y",  "image": "assets/kids/b8.webp", "gender": "boy", "age_group": "5-6Y"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("KIDS")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _section("Girl's Fashion", girls, context),
            _section("Boy's Fashion", boys, context),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Map<String, String>> data, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: .8,
            ),
            itemBuilder: (context, index) {
              final item = data[index];
              return GestureDetector(
                onTap: () {
                  // Pass gender and age_group as extra map
                  context.push(
                    AppRoutes.productList,
                    extra: {
                      'category': 'kids',
                      'gender': item['gender'],
                      'age_group': item['age_group'],
                      'title': item['title'],
                    },
                  );
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade100,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(item["image"]!, height: 70),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item["title"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}