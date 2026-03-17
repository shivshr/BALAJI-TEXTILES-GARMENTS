import 'package:carousel_slider/carousel_slider.dart';
import 'package:balaji_textile_and_garments/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _current = 0;

  /// 🔹 EXISTING LOCAL BANNERS (FALLBACK)
  final List<Map<String, dynamic>> _banners = [
    {
      'title': "Men's Special\nCollection",
      'subtitle': 'Men Special Collection',
      'discount': '10% OFF',
      'gradient': [Color(0xFF1A1A2E), Color(0xFF16213E)],
    },
    {
      'title': "Women's\nTrending",
      'subtitle': 'New Arrivals',
      'discount': '15% OFF',
      'gradient': [Color(0xFF6B2737), Color(0xFF9B4DCA)],
    },
    {
      'title': "Kids Festive\nCollection",
      'subtitle': 'Cute Styles',
      'discount': '20% OFF',
      'gradient': [Color(0xFF005C5C), Color(0xFF008080)],
    },
    {
      'image': 'assets/images/categories/banner1.png',
    },
    {
      'image': 'assets/images/categories/banner2.png',
    },
    {
      'image': 'assets/images/categories/banner3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('banners').snapshots(),
      builder: (context, snapshot) {

        /// 🔹 IF ADMIN BANNERS EXIST → USE THEM
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final firestoreBanners = snapshot.data!.docs;

          return _buildCarousel(
            firestoreBanners.map((doc) {
              return {
                "image": doc['imageUrl'],
                "network": true
              };
            }).toList(),
          );
        }

        /// 🔹 OTHERWISE USE EXISTING LOCAL BANNERS
        return _buildCarousel(_banners);
      },
    );
  }

  Widget _buildCarousel(List banners) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            height: 220,
            viewportFraction: 0.92,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: false,
            onPageChanged: (i, _) => setState(() => _current = i),
          ),
          itemBuilder: (context, index, _) {

            final b = banners[index];

            /// 🔹 IMAGE BANNER
            if (b.containsKey('image')) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: b['network'] == true
                      ? Image.network(
                          b['image'],
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        )
                      : Image.asset(
                          b['image'],
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                ),
              );
            }

            /// 🔹 GRADIENT BANNER (UNCHANGED)
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: List<Color>.from(b['gradient']),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: 180,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            b['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          b['subtitle'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          b['discount'],
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _current ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == _current
                    ? AppColors.primary
                    : AppColors.divider,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}