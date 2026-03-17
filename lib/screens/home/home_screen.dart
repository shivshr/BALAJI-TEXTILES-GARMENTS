// import 'package:fashion_app/core/constants/app_colors.dart';
// import 'package:fashion_app/core/constants/app_routes.dart';
// import 'package:fashion_app/providers/auth_provider.dart';
// import 'package:fashion_app/providers/product_provider.dart';
// import 'package:fashion_app/providers/location_provider.dart';
// import 'package:fashion_app/screens/home/widgets/banner_carousel.dart';
// import 'package:fashion_app/screens/home/widgets/category_grid.dart';
// import 'package:fashion_app/screens/home/widgets/featured_products.dart';
// import 'package:fashion_app/widgets/whatsapp_support_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {

//   bool showFullAddress = false;

//   /// =================================
//   /// WHATSAPP CHAT SUPPORT
//   /// =================================
//   Future<void> _openWhatsApp() async {

//     const phone = "918305771664";

//     const message =
//         "Hello Balaji Textile, I need help regarding a product.";

//     final url = Uri.parse(
//         "https://wa.me/$phone?text=${Uri.encodeComponent(message)}");

//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     }
//   }

//   /// =================================
//   /// TRY AT HOME POPUP
//   /// =================================
//   void _showTryAtHome(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(25),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [

//               const SizedBox(height: 10),

//               const Text(
//                 "Free Trial at home, Pay for what you love!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),

//               const SizedBox(height: 20),

//               _step(Icons.local_shipping,
//                   "Order & get it delivered to your doorstep"),

//               _step(Icons.home_work,
//                   "Try the clothes while our rider waits at your doorstep"),

//               _step(Icons.replay,
//                   "Don't like it? Return instantly to the delivery partner"),

//               const SizedBox(height: 20),

//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Continue Shopping"),
//                 ),
//               ),

//               const SizedBox(height: 10),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _step(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: const Color(0xFF0F6C5C)),
//           ),
//           const SizedBox(width: 12),
//           Expanded(child: Text(text)),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     final locationAsync = ref.watch(locationProvider);
//     final featured = ref.watch(featuredProductsProvider);

//     return Scaffold(
//       backgroundColor: AppColors.background,

//       /// STACK FOR FLOATING BUTTON
//       body: Stack(
//         children: [

//           CustomScrollView(
//             slivers: [

//               /// HEADER
//               SliverToBoxAdapter(
//                 child: Container(
//                   color: const Color(0xFFE6F7ED),
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 45, 16, 10),
//                     child: Column(
//                       children: [

//                         /// TOP ICON ROW
//                         Row(
//                           children: [

//                             /// WHATSAPP CHAT BUTTON
//                             GestureDetector(
//                               onTap: _openWhatsApp,
//                               child: Container(
//                                 height: 42,
//                                 width: 42,
//                                 decoration: const BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Padding(
//           padding: const EdgeInsets.all(9),
//           child: Image.asset(
//             "assets/images/whatsappp.png",
//           ),
//                                 ),
//                               ),
//                             ),

//                             const Spacer(),

//                             /// BALAJI LOGO
//                             SizedBox(
//                               height: 65,
//                               child: Image.asset(
//                                 "assets/images/balaji_logo_transparent.png",
//                                 fit: BoxFit.contain,
//                               ),
//                             ),

//                             const Spacer(),

//                             Container(
//                               height: 42,
//                               width: 42,
//                               decoration: const BoxDecoration(
//                                 color: Color(0xFF0F6C5C),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.person,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 8),

//                         /// LOCATION
//                         locationAsync.when(
//                           data: (address) {

//                             String shortAddress = address.split(',').first;

//                             return Column(
//                               children: [

//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       showFullAddress = !showFullAddress;
//                                     });
//                                   },
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [

//                                       const Icon(
//                                         Icons.home,
//                                         color: Color(0xFF0F6C5C),
//                                         size: 18,
//                                       ),

//                                       const SizedBox(width: 6),

//                                       Expanded(
//                                         child: Text(
//                                           showFullAddress
//                                               ? "HOME - $address"
//                                               : "HOME - $shortAddress",
//                                           style: const TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                           overflow: TextOverflow.ellipsis,
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),

//                                       const SizedBox(width: 4),

//                                       Icon(
//                                         showFullAddress
//                                             ? Icons.keyboard_arrow_up
//                                             : Icons.keyboard_arrow_down,
//                                         size: 18,
//                                       ),
//                                     ],
//                                   ),
//                                 ),

//                                 if (showFullAddress)
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 6),
//                                     child: Container(
//                                       padding: const EdgeInsets.all(10),
//                                       margin: const EdgeInsets.symmetric(horizontal: 20),
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey.shade100,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Text(
//                                         address,
//                                         style: const TextStyle(fontSize: 13),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             );
//                           },
//                           loading: () => const Text("Fetching location..."),
//                           error: (e, _) => const Text("Location unavailable"),
//                         ),

//                         const SizedBox(height: 14),

//                         /// SEARCH BAR
//                         GestureDetector(
//                           onTap: () => context.push(AppRoutes.search),
//                           child: Container(
//                             height: 52,
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(30),
//                               border: Border.all(color: Colors.grey.shade300),
//                             ),
//                             child: Row(
//                               children: [

//                                 const Icon(Icons.search, color: Colors.grey),

//                                 const SizedBox(width: 8),

//                                 const Expanded(
//                                   child: Text(
//                                     "Search fashion & products",
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                 ),

//                                 /// TRY AT HOME BUTTON
//                                 GestureDetector(
//                                   onTap: () {
//                                     _showTryAtHome(context);
//                                   },
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 18,
//                                       vertical: 10,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(25),
//                                       border: Border.all(
//                                         color: const Color(0xFF0F6C5C),
//                                         width: 1.5,
//                                       ),
//                                     ),
//                                     child: const Row(
//                                       children: [
//                                         Icon(
//                                           Icons.home_outlined,
//                                           size: 18,
//                                           color: Color(0xFF0F6C5C),
//                                         ),
//                                         SizedBox(width: 6),
//                                         Text(
//                                           "TRY AT HOME",
//                                           style: TextStyle(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w600,
//                                             color: Color(0xFF0F6C5C),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               /// MAIN CONTENT
//               SliverToBoxAdapter(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [

//                     const SizedBox(height: 16),

//                     const BannerCarousel(),

//                     const SizedBox(height: 24),

//                     const _SectionHeader(title: '⭐ SHOP BY CATEGORY ⭐'),

//                     const SizedBox(height: 12),

//                     const CategoryGrid(),

//                     const SizedBox(height: 24),

//                     const _SectionHeader(title: '⭐ FEATURED PRODUCTS'),

//                     const SizedBox(height: 12),

//                     featured.when(
//                       data: (products) =>
//                           FeaturedProductsRow(products: products),
//                       loading: () =>
//                           const Center(child: CircularProgressIndicator()),
//                       error: (e, _) => Center(child: Text('Error: $e')),
//                     ),

//                     const SizedBox(height: 80),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           /// FLOATING WHATSAPP BUTTON
//          WhatsAppSupportButton(),

//         ],
//       ),
//     );
//   }
// }

// class _SectionHeader extends StatelessWidget {

//   final String title;

//   const _SectionHeader({required this.title});

//   @override
//   Widget build(BuildContext context) {

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 0.5,
//           color: AppColors.textPrimary,
//         ),
//       ),
//     );
//   }
// }


// import 'package:fashion_app/core/constants/app_colors.dart';
// import 'package:fashion_app/core/constants/app_routes.dart';
// import 'package:fashion_app/providers/auth_provider.dart';
// import 'package:fashion_app/providers/product_provider.dart';
// import 'package:fashion_app/providers/location_provider.dart';
// import 'package:fashion_app/screens/home/widgets/banner_carousel.dart';
// import 'package:fashion_app/screens/home/widgets/category_grid.dart';
// import 'package:fashion_app/screens/home/widgets/featured_products.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   bool showFullAddress = false;

//   Future<void> _openWhatsApp() async {
//     const phone = "918305771664";
//     const message = "Hello Balaji Textile, I need help regarding a product.";
//     final url = Uri.parse(
//         "https://wa.me/$phone?text=${Uri.encodeComponent(message)}");
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     }
//   }

//   void _showTryAtHome(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 10),
//               const Text(
//                 "Free Trial at home, Pay for what you love!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
//               ),
//               const SizedBox(height: 20),
//               _step(Icons.local_shipping, "Order & get it delivered to your doorstep"),
//               _step(Icons.home_work, "Try the clothes while our rider waits at your doorstep"),
//               _step(Icons.replay, "Don't like it? Return instantly to the delivery partner"),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Continue Shopping"),
//                 ),
//               ),
//               const SizedBox(height: 10),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _step(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: const Color(0xFF0F6C5C)),
//           ),
//           const SizedBox(width: 12),
//           Expanded(child: Text(text)),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final locationAsync = ref.watch(locationProvider);
//     final featured = ref.watch(featuredProductsProvider);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Stack(
//         children: [
//           CustomScrollView(
//             slivers: [
//               // HEADER
//               SliverToBoxAdapter(
//                 child: Container(
//                   color: const Color(0xFFE6F7ED),
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 45, 16, 10),
//                     child: Column(
//                       children: [
//                         // TOP ROW
//                         Row(
//                           children: [
//                             // WhatsApp button in header
//                             GestureDetector(
//                               onTap: _openWhatsApp,
//                               child: Container(
//                                 height: 42,
//                                 width: 42,
//                                 decoration: const BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(9),
//                                   child: Image.asset("assets/images/whatsappp.png"),
//                                 ),
//                               ),
//                             ),
//                             const Spacer(),
//                             // Logo
//                             SizedBox(
//                               height: 65,
//                               child: Image.asset(
//                                 "assets/images/balaji_logo_transparent.png",
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                             const Spacer(),
//                             Container(
//                               height: 42,
//                               width: 42,
//                               decoration: const BoxDecoration(
//                                 color: Color(0xFF0F6C5C),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(Icons.person, color: Colors.white),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 8),

//                         // LOCATION
//                         locationAsync.when(
//                           data: (address) {
//                             String shortAddress = address.split(',').first;
//                             return Column(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () => setState(() => showFullAddress = !showFullAddress),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Icon(Icons.home, color: Color(0xFF0F6C5C), size: 18),
//                                       const SizedBox(width: 6),
//                                       Expanded(
//                                         child: Text(
//                                           showFullAddress ? "HOME - $address" : "HOME - $shortAddress",
//                                           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                                           overflow: TextOverflow.ellipsis,
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Icon(
//                                         showFullAddress ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                                         size: 18,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 if (showFullAddress)
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 6),
//                                     child: Container(
//                                       padding: const EdgeInsets.all(10),
//                                       margin: const EdgeInsets.symmetric(horizontal: 20),
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey.shade100,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Text(address, style: const TextStyle(fontSize: 13), textAlign: TextAlign.center),
//                                     ),
//                                   ),
//                               ],
//                             );
//                           },
//                           loading: () => const Text("Fetching location..."),
//                           error: (e, _) => Text("Location error: $e"),
//                         ),

//                         const SizedBox(height: 14),

//                         // SEARCH BAR
//                         GestureDetector(
//                           onTap: () => context.push(AppRoutes.search),
//                           child: Container(
//                             height: 52,
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(30),
//                               border: Border.all(color: Colors.grey.shade300),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(Icons.search, color: Colors.grey),
//                                 const SizedBox(width: 8),
//                                 const Expanded(
//                                   child: Text("Search fashion & products",
//                                       style: TextStyle(color: Colors.grey)),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () => _showTryAtHome(context),
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(25),
//                                       border: Border.all(color: const Color(0xFF0F6C5C), width: 1.5),
//                                     ),
//                                     child: const Row(
//                                       children: [
//                                         Icon(Icons.home_outlined, size: 18, color: Color(0xFF0F6C5C)),
//                                         SizedBox(width: 6),
//                                         Text("TRY AT HOME",
//                                             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F6C5C))),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               // MAIN CONTENT
//               SliverToBoxAdapter(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 16),
//                     const BannerCarousel(),
//                     const SizedBox(height: 24),
//                     const _SectionHeader(title: '⭐ SHOP BY CATEGORY ⭐'),
//                     const SizedBox(height: 12),
//                     const CategoryGrid(),
//                     const SizedBox(height: 24),
//                     const _SectionHeader(title: '⭐ FEATURED PRODUCTS'),
//                     const SizedBox(height: 12),
//                     featured.when(
//                       data: (products) => FeaturedProductsRow(products: products),
//                       loading: () => const Center(child: CircularProgressIndicator()),
//                       error: (e, _) => Center(child: Text('Error: $e')),
//                     ),
//                     const SizedBox(height: 100),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           // FLOATING WHATSAPP BUTTON (bottom right)
//           Positioned(
//             bottom: 90,
//             right: 16,
//             child: GestureDetector(
//               onTap: _openWhatsApp,
//               child: Container(
//                 height: 55,
//                 width: 55,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF25D366),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 8,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(Icons.chat, color: Colors.white, size: 28),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SectionHeader extends StatelessWidget {
//   final String title;
//   const _SectionHeader({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w700,
//           letterSpacing: 0.5,
//           color: AppColors.textPrimary,
//         ),
//       ),
//     );
//   }
// }


import 'package:balaji_textile_and_garments/core/constants/app_colors.dart';
import 'package:balaji_textile_and_garments/core/constants/app_routes.dart';
import 'package:balaji_textile_and_garments/providers/auth_provider.dart';
import 'package:balaji_textile_and_garments/providers/product_provider.dart';
import 'package:balaji_textile_and_garments/providers/location_provider.dart';
import 'package:balaji_textile_and_garments/screens/home/widgets/banner_carousel.dart';
import 'package:balaji_textile_and_garments/screens/home/widgets/category_grid.dart';
import 'package:balaji_textile_and_garments/screens/home/widgets/featured_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool showFullAddress = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _openWhatsApp() async {
    const phone = "918305771664";
    const message = "Hello Balaji Textile, I need help regarding a product.";
    final url = Uri.parse(
        "https://wa.me/$phone?text=${Uri.encodeComponent(message)}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showTryAtHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Free Trial at home, Pay for what you love!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            _step(Icons.local_shipping, "Order & get it delivered to your doorstep"),
            _step(Icons.home_work, "Try the clothes while our rider waits at your doorstep"),
            _step(Icons.replay, "Don't like it? Return instantly to the delivery partner"),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Continue Shopping"),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _step(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF0F6C5C)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(locationProvider);
    final featured = ref.watch(featuredProductsProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,

      // ── DRAWER ──────────────────────────────────────────
      endDrawer: _AppDrawer(openWhatsApp: _openWhatsApp),

      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: const Color(0xFFE6F7ED),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 45, 16, 10),
                    child: Column(
                      children: [
                        // TOP ROW
                        Row(
                          children: [
                            // WhatsApp
                            GestureDetector(
                              onTap: _openWhatsApp,
                              child: Container(
                                height: 42,
                                width: 42,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: Image.asset("assets/images/whatsappp.png"),
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Logo
                            SizedBox(
                              height: 65,
                              child: Image.asset(
                                "assets/images/balaji_logo_transparent.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            const Spacer(),
                            // HAMBURGER MENU
                            GestureDetector(
                              onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                              child: Container(
                                height: 42,
                                width: 42,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0F6C5C),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.menu, color: Colors.white, size: 22),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // LOCATION
                        locationAsync.when(
                          data: (address) {
                            String shortAddress = address.split(',').first;
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => showFullAddress = !showFullAddress),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.home, color: Color(0xFF0F6C5C), size: 18),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          showFullAddress ? "HOME - $address" : "HOME - $shortAddress",
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        showFullAddress ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                                if (showFullAddress)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(address,
                                          style: const TextStyle(fontSize: 13),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                              ],
                            );
                          },
                          loading: () => const Text("Fetching location..."),
                          error: (e, _) => Text("Location error: $e"),
                        ),

                        const SizedBox(height: 14),

                        // SEARCH BAR
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.search),
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.grey),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text("Search fashion & products",
                                      style: TextStyle(color: Colors.grey)),
                                ),
                                GestureDetector(
                                  onTap: () => _showTryAtHome(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          color: const Color(0xFF0F6C5C), width: 1.5),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.home_outlined,
                                            size: 18, color: Color(0xFF0F6C5C)),
                                        SizedBox(width: 6),
                                        Text("TRY AT HOME",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF0F6C5C))),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const BannerCarousel(),
                    const SizedBox(height: 24),
                    const _SectionHeader(title: '⭐ SHOP BY CATEGORY ⭐'),
                    const SizedBox(height: 12),
                    const CategoryGrid(),
                    const SizedBox(height: 24),
                    const _SectionHeader(title: '⭐ FEATURED PRODUCTS'),
                    const SizedBox(height: 12),
                    featured.when(
                      data: (products) => FeaturedProductsRow(products: products),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // FLOATING WHATSAPP
          Positioned(
            bottom: 90,
            right: 16,
            child: GestureDetector(
              onTap: _openWhatsApp,
              child: Container(
                height: 55,
                width: 55,
                decoration: const BoxDecoration(
                  color: Color(0xFF25D366),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset("assets/images/whatsappp.png"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  END DRAWER
// ═══════════════════════════════════════════════
class _AppDrawer extends StatelessWidget {
  final Future<void> Function() openWhatsApp;
  const _AppDrawer({required this.openWhatsApp});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              color: const Color(0xFFE6F7ED),
              child: Row(
                children: [
                  Image.asset("assets/images/balaji_logo_transparent.png", height: 50),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Balaji Garments",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF0F6C5C))),
                      Text("Quality You Can Trust",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // CONTACT US
            ListTile(
              leading: const Icon(Icons.contact_support_outlined, color: Color(0xFF0F6C5C)),
              title: const Text("Contact Us", style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _showContactForm(context);
              },
            ),

            const Divider(indent: 16, endIndent: 16),

            // ABOUT US
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF0F6C5C)),
              title: const Text("About Us", style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _showAboutUs(context);
              },
            ),

            const Spacer(),

            // VERSION
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text("v1.0.0", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ContactFormSheet(),
    );
  }

  void _showAboutUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _AboutUsScreen()),
    );
  }
}

// ═══════════════════════════════════════════════
//  CONTACT FORM BOTTOM SHEET
// ═══════════════════════════════════════════════
class _ContactFormSheet extends StatefulWidget {
  const _ContactFormSheet();

  @override
  State<_ContactFormSheet> createState() => _ContactFormSheetState();
}

class _ContactFormSheetState extends State<_ContactFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _loading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirebaseFirestore.instance.collection('contact_requests').add({
        'name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'message': _messageCtrl.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
      });
      setState(() { _loading = false; _submitted = true; });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _submitted ? _successView() : _formView(),
      ),
    );
  }

  Widget _successView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF0F6C5C), size: 64),
        const SizedBox(height: 16),
        const Text("Message Sent!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text("We'll get back to you soon.",
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ),
      ],
    );
  }

  Widget _formView() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF0F6C5C), width: 1.5),
    );
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Contact Us",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text("We'll get back to you shortly.",
              style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: 'Your Name',
              prefixIcon: const Icon(Icons.person_outline),
              enabledBorder: border,
              focusedBorder: border.copyWith(
                  borderSide: const BorderSide(color: Color(0xFF0F6C5C), width: 2)),
            ),
            validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone_outlined),
              enabledBorder: border,
              focusedBorder: border.copyWith(
                  borderSide: const BorderSide(color: Color(0xFF0F6C5C), width: 2)),
            ),
            validator: (v) => v == null || v.isEmpty ? 'Enter phone number' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _messageCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Message',
              prefixIcon: const Icon(Icons.message_outlined),
              enabledBorder: border,
              focusedBorder: border.copyWith(
                  borderSide: const BorderSide(color: Color(0xFF0F6C5C), width: 2)),
            ),
            validator: (v) => v == null || v.isEmpty ? 'Enter a message' : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F6C5C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _loading
                  ? const SizedBox(
                      height: 22, width: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Send Message",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  ABOUT US SCREEN
// ═══════════════════════════════════════════════
class _AboutUsScreen extends StatelessWidget {
  const _AboutUsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: const Color(0xFFE6F7ED),
        foregroundColor: const Color(0xFF0F6C5C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HERO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7ED),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Image.asset("assets/images/balaji_logo_transparent.png", height: 80),
                  const SizedBox(height: 12),
                  const Text("Balaji Garments",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F6C5C))),
                  const SizedBox(height: 4),
                  const Text("A Legacy of Style & Trust",
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _aboutParagraph(
              "Balaji Garments stands as a symbol of quality, reliability, and style in India's growing garment industry. Established with the vision of delivering fashionable and high-quality clothing, we have grown from a small local business into a trusted name for garments and apparel.",
            ),
            const SizedBox(height: 12),
            _aboutParagraph(
              "Our journey began with a simple idea — to provide stylish, comfortable, and affordable clothing to customers while maintaining high standards of quality and service. Over the years, we have expanded our collection and built strong relationships with suppliers, manufacturers, and customers across the region.",
            ),
            const SizedBox(height: 12),
            _aboutParagraph(
              "Located in Surat, one of India's major hubs for textile and garment production, our store connects modern fashion trends with reliable craftsmanship.",
            ),

            const SizedBox(height: 28),

            // CORE VALUES
            const Text("Our Core Values",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            _valueCard(Icons.verified, "Quality First",
                "We ensure every garment meets our standards of durability, comfort, and design."),
            _valueCard(Icons.favorite_outline, "Customer Satisfaction",
                "Our customers are at the center of everything we do."),
            _valueCard(Icons.sell_outlined, "Affordable Fashion",
                "Stylish clothing accessible to everyone without compromising quality."),
            _valueCard(Icons.handshake_outlined, "Trust & Reliability",
                "Building long-term relationships through honesty and dependable service."),

            const SizedBox(height: 28),

            // MILESTONES
            const Text("Our Journey",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            _milestone("🏁", "Foundation", "Started as a small garment business with the goal of bringing quality clothing to local customers."),
            _milestone("📈", "Growth", "Gradually expanded our range of garments to include various styles, fabrics, and fashion choices."),
            _milestone("🤝", "Expansion", "Built a growing customer base and strengthened partnerships with trusted suppliers."),
            _milestone("📱", "Today", "Now embracing online platforms to bring our garments closer to customers everywhere."),

            const SizedBox(height: 28),

            // LOCATION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7ED),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Color(0xFF0F6C5C)),
                      SizedBox(width: 8),
                      Text("Visit Us",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F6C5C))),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "D/32/33, Diamond Textile Park/3\nNear Kanav Ashram, Kanav Gaon Road\nPalsana, Surat, IN 394315",
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _aboutParagraph(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 14, height: 1.7, color: Color(0xFF444444)));
  }

  Widget _valueCard(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7ED),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF0F6C5C), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 4),
                Text(desc,
                    style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _milestone(String emoji, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 4),
                Text(desc,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 13, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}