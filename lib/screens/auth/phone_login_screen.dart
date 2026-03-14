// // import 'package:fashion_app/core/constants/app_colors.dart';
// // import 'package:fashion_app/core/constants/app_routes.dart';
// // import 'package:fashion_app/core/utils/validators.dart';
// // import 'package:fashion_app/providers/auth_provider.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:go_router/go_router.dart';

// // class PhoneLoginScreen extends ConsumerStatefulWidget {
// //   const PhoneLoginScreen({super.key});

// //   @override
// //   ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
// // }

// // class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {

// //   final _formKey = GlobalKey<FormState>();
// //   final _phoneController = TextEditingController(text: '+91');

// //   bool _loading = false;

// //   @override
// //   void dispose() {
// //     _phoneController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _sendOtp() async {

// //     if (!_formKey.currentState!.validate()) return;

// //     setState(() => _loading = true);

// //     await ref.read(authServiceProvider).sendOtp(
// //       phoneNumber: _phoneController.text.trim(),
// //       onCodeSent: (_) {
// //         setState(() => _loading = false);
// //         context.push(
// //           AppRoutes.otpVerify,
// //           extra: _phoneController.text.trim(),
// //         );
// //       },
// //       onError: (e) {
// //         setState(() => _loading = false);
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(e),
// //             backgroundColor: AppColors.error,
// //           ),
// //         );
// //       },
// //       onAutoVerified: () {
// //         setState(() => _loading = false);
// //         context.go(AppRoutes.home);
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {

// //     return Scaffold(
// //       backgroundColor: const Color(0xFFE6F7ED),

// //       body: Column(
// //         children: [

// //           /// TOP SPACE
// //           const SizedBox(height: 100),

// //           /// WHITE CARD
// //           Expanded(
// //             child: Container(
// //               width: double.infinity,
// //               padding: const EdgeInsets.all(24),

// //               decoration: const BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.only(
// //                   topLeft: Radius.circular(32),
// //                   topRight: Radius.circular(32),
// //                 ),
// //               ),

// //               child: SingleChildScrollView(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.center,
// //                   children: [

// //                     /// BIG BALAJI LOGO
// //                     SizedBox(
// //                       width: double.infinity,
// //                       child: Image.asset(
// //                         "assets/images/logo_transparent.png",
// //                         height: 230,
// //                         fit: BoxFit.contain,
// //                       ),
// //                     ),

// //                     const SizedBox(height: 10),

// //                     /// SLOGAN
// //                     const Text(
// //                       "15 Years of Trusted Quality",
// //                       style: TextStyle(
// //                         fontSize: 15,
// //                         fontWeight: FontWeight.w600,
// //                         color: Color(0xFF0F6C5C),
// //                         letterSpacing: 0.5,
// //                       ),
// //                     ),

// //                     const SizedBox(height: 28),

// //                     /// PHONE FIELD
// //                     Form(
// //                       key: _formKey,
// //                       child: TextFormField(
// //                         controller: _phoneController,
// //                         keyboardType: TextInputType.phone,
// //                         validator: Validators.phone,

// //                         style: const TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.w500,
// //                         ),

// //                         decoration: InputDecoration(
// //                           labelText: 'Phone Number',
// //                           prefixIcon: const Icon(Icons.phone_outlined),

// //                           enabledBorder: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(14),
// //                             borderSide: const BorderSide(
// //                               color: Color(0xFF0F6C5C),
// //                               width: 1.5,
// //                             ),
// //                           ),

// //                           focusedBorder: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(14),
// //                             borderSide: const BorderSide(
// //                               color: Color(0xFF0F6C5C),
// //                               width: 2,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),

// //                     const SizedBox(height: 26),

// //                     /// LOGIN BUTTON
// //                     SizedBox(
// //                       width: double.infinity,
// //                       height: 50,

// //                       child: ElevatedButton(
// //                         onPressed: _loading ? null : _sendOtp,

// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: const Color(0xFF4CAF50),
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(10),
// //                           ),
// //                         ),

// //                         child: _loading
// //                             ? const SizedBox(
// //                                 height: 22,
// //                                 width: 22,
// //                                 child: CircularProgressIndicator(
// //                                   color: Colors.white,
// //                                   strokeWidth: 2,
// //                                 ),
// //                               )
// //                             : const Text(
// //                                 'Login',
// //                                 style: TextStyle(fontSize: 16),
// //                               ),
// //                       ),
// //                     ),

// //                     const SizedBox(height: 14),

// //                     /// ADMIN LOGIN
// //                     SizedBox(
// //                       width: double.infinity,
// //                       height: 50,

// //                       child: Container(
// //                         decoration: BoxDecoration(
// //                           gradient: const LinearGradient(
// //                             colors: [
// //                               Color(0xFF0F6C5C),
// //                               Color(0xFF043B30),
// //                             ],
// //                           ),
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),

// //                         child: ElevatedButton(
// //                           onPressed: () =>
// //                               context.push(AppRoutes.adminLogin),

// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Colors.transparent,
// //                             shadowColor: Colors.transparent,
// //                           ),

// //                           child: const Text(
// //                             "Admin Login",
// //                             style: TextStyle(fontSize: 16),
// //                           ),
// //                         ),
// //                       ),
// //                     ),

// //                     const SizedBox(height: 30),

// //                     /// TERMS
// //                     const Text(
// //                       'By continuing, you agree to our\nTerms of Service & Privacy Policy',
// //                       textAlign: TextAlign.center,
// //                       style: TextStyle(
// //                         fontSize: 12,
// //                         color: AppColors.textHint,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'package:fashion_app/core/constants/app_colors.dart';
// import 'package:fashion_app/core/constants/app_routes.dart';
// import 'package:fashion_app/core/utils/validators.dart';
// import 'package:fashion_app/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// // ════════════════════════════════════════
// //  Set your admin phone numbers here
// // ════════════════════════════════════════
// const List<String> kAdminPhoneNumbers = [
//   '+916261668801',  // add more if needed
// ];

// class PhoneLoginScreen extends ConsumerStatefulWidget {
//   const PhoneLoginScreen({super.key});

//   @override
//   ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
// }

// class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneController = TextEditingController(text: '+91');
//   bool _loading = false;

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     super.dispose();
//   }

//   Future<void> _sendOtp() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _loading = true);

//     final phone = _phoneController.text.trim();
//     final isAdmin = kAdminPhoneNumbers.contains(phone);

//     await ref.read(authServiceProvider).sendOtp(
//       phoneNumber: phone,
//       onCodeSent: (_) {
//         setState(() => _loading = false);
//         context.push(
//           AppRoutes.otpVerify,
//           extra: {'phone': phone, 'isAdmin': isAdmin},
//         );
//       },
//       onError: (e) {
//         setState(() => _loading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e), backgroundColor: AppColors.error),
//         );
//       },
//       onAutoVerified: () {
//         setState(() => _loading = false);
//         context.go(isAdmin ? AppRoutes.adminDashboard : AppRoutes.home);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE6F7ED),
//       body: Column(
//         children: [
//           const SizedBox(height: 100),
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(24),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(32),
//                   topRight: Radius.circular(32),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // LOGO
//                     SizedBox(
//                       width: double.infinity,
//                       child: Image.asset(
//                         "assets/images/logo_transparent.png",
//                         height: 230,
//                         fit: BoxFit.contain,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     // SLOGAN
//                     const Text(
//                       "15 Years of Trusted Quality",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF0F6C5C),
//                         letterSpacing: 0.5,
//                       ),
//                     ),

//                     const SizedBox(height: 28),

//                     // PHONE FIELD
//                     Form(
//                       key: _formKey,
//                       child: TextFormField(
//                         controller: _phoneController,
//                         keyboardType: TextInputType.phone,
//                         validator: Validators.phone,
//                         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         decoration: InputDecoration(
//                           labelText: 'Phone Number',
//                           prefixIcon: const Icon(Icons.phone_outlined),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: const BorderSide(color: Color(0xFF0F6C5C), width: 1.5),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: const BorderSide(color: Color(0xFF0F6C5C), width: 2),
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 26),

//                     // LOGIN BUTTON
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: _loading ? null : _sendOtp,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF4CAF50),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: _loading
//                             ? const SizedBox(
//                                 height: 22,
//                                 width: 22,
//                                 child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                               )
//                             : const Text('Login', style: TextStyle(fontSize: 16)),
//                       ),
//                     ),

//                     const SizedBox(height: 30),

//                     // TERMS
//                     const Text(
//                       'By continuing, you agree to our\nTerms of Service & Privacy Policy',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12, color: AppColors.textHint),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:fashion_app/core/constants/app_colors.dart';
// import 'package:fashion_app/core/constants/app_routes.dart';
// import 'package:fashion_app/core/utils/validators.dart';
// import 'package:fashion_app/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:url_launcher/url_launcher.dart';

// const List<String> kAdminPhoneNumbers = [
//   '+916261668801',
// ];

// class PhoneLoginScreen extends ConsumerStatefulWidget {
//   const PhoneLoginScreen({super.key});

//   @override
//   ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
// }

// class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneController = TextEditingController(text: '+91');
//   bool _loading = false;

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     super.dispose();
//   }

//   Future<void> _sendOtp() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _loading = true);

//     final phone = _phoneController.text.trim();
//     final isAdmin = kAdminPhoneNumbers.contains(phone);

//     await ref.read(authServiceProvider).sendOtp(
//       phoneNumber: phone,
//       onCodeSent: (_) {
//         setState(() => _loading = false);
//         context.push(
//           AppRoutes.otpVerify,
//           extra: {'phone': phone, 'isAdmin': isAdmin},
//         );
//       },
//       onError: (e) {
//         setState(() => _loading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e), backgroundColor: AppColors.error),
//         );
//       },
//       onAutoVerified: () {
//         setState(() => _loading = false);
//         context.go(isAdmin ? AppRoutes.adminDashboard : AppRoutes.home);
//       },
//     );
//   }

//   Future<void> _openWhatsApp() async {
//     const phone = "918305771664";
//     const message = "Hello Balaji Textile, I need help regarding a product.";
//     final url = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     }
//   }

//   Future<void> _openUrl(String urlStr) async {
//     final url = Uri.parse(urlStr);
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE6F7ED),
//       body: Column(
//         children: [
//           const SizedBox(height: 60),

//           // WHITE CARD
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(32),
//                   topRight: Radius.circular(32),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [

//                     // LOGO
//                     Image.asset(
//                       "assets/images/logo_transparent.png",
//                       height: 160,
//                       fit: BoxFit.contain,
//                     ),

                    
//                     const SizedBox(height: 12),

//                     // SLOGAN
//                     const Text(
//                       "15 Years of Trusted Quality",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF0F6C5C),
//                         letterSpacing: 0.5,
//                       ),
//                     ),

//                     const SizedBox(height: 32),

//                     // PHONE FIELD
//                     Form(
//                       key: _formKey,
//                       child: TextFormField(
//                         controller: _phoneController,
//                         keyboardType: TextInputType.phone,
//                         validator: Validators.phone,
//                         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                         decoration: InputDecoration(
//                           labelText: 'Phone Number',
//                           prefixIcon: const Icon(Icons.phone_outlined),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: const BorderSide(color: Color(0xFF0F6C5C), width: 1.5),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: const BorderSide(color: Color(0xFF0F6C5C), width: 2),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: const BorderSide(color: AppColors.error, width: 1.5),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: const BorderSide(color: AppColors.error, width: 2),
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // LOGIN BUTTON
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: _loading ? null : _sendOtp,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF4CAF50),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: _loading
//                             ? const SizedBox(
//                                 height: 22,
//                                 width: 22,
//                                 child: CircularProgressIndicator(
//                                     color: Colors.white, strokeWidth: 2),
//                               )
//                             : const Text(
//                                 'Login',
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w600),
//                               ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // TERMS & PRIVACY
//                     RichText(
//                       textAlign: TextAlign.center,
//                       text: TextSpan(
//                         style: const TextStyle(
//                             fontSize: 12, color: AppColors.textHint),
//                         children: [
//                           const TextSpan(text: 'By continuing, you agree to our\n'),
//                           TextSpan(
//                             text: 'Terms of Service & Privacy Policy',
//                             style: const TextStyle(
//                               color: Color(0xFF0F6C5C),
//                               decoration: TextDecoration.underline,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = () => _openUrl(
//                                   'https://sites.google.com/d/1wkUi5NM36RXBYzxjhD4nwGlb_SOn3j86/p/1OL3pLCG_gC-6T3-WfaLwceX3hVX4E4_5/edit'),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 32),

//                     // DIVIDER
//                     const Divider(height: 1, color: Color(0xFFE0E0E0)),

//                     const SizedBox(height: 20),

//                     // CONTACT US & ABOUT US
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // CONTACT US → WhatsApp
//                         GestureDetector(
//                           onTap: _openWhatsApp,
//                           child: const Row(
//                             children: [
//                               Icon(Icons.headset_mic_outlined,
//                                   size: 18, color: Color(0xFF555555)),
//                               SizedBox(width: 6),
//                               Text(
//                                 'Contact Us',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF555555),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         // VERTICAL DIVIDER
//                         Container(
//                           height: 20,
//                           width: 1,
//                           color: const Color(0xFFCCCCCC),
//                           margin: const EdgeInsets.symmetric(horizontal: 50),
//                         ),

//                         // ABOUT US → Google Site
//                         GestureDetector(
//                           onTap: () => _openUrl(
//                               'https://sites.google.com/d/1wkUi5NM36RXBYzxjhD4nwGlb_SOn3j86/p/1gizDWnRFuRd2H431RReZA0i2jZmPzlGs/edit'),
//                           child: const Row(
//                             children: [
//                               Icon(Icons.info_outline,
//                                   size: 18, color: Color(0xFF555555)),
//                               SizedBox(width: 6),
//                               Text(
//                                 'About Us',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF555555),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:fashion_app/core/constants/app_colors.dart';
import 'package:fashion_app/core/constants/app_routes.dart';
import 'package:fashion_app/core/utils/validators.dart';
import 'package:fashion_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

const List<String> kAdminPhoneNumbers = [
  '+916261668801',
];

const String _playStoreUrl =
    'https://play.google.com/store/apps/details?id=co.lazarus.mjarn&hl=en_IN';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '+91');
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final phone = _phoneController.text.trim();
    final isAdmin = kAdminPhoneNumbers.contains(phone);

    await ref.read(authServiceProvider).sendOtp(
      phoneNumber: phone,
      onCodeSent: (_) {
        setState(() => _loading = false);
        context.push(
          AppRoutes.otpVerify,
          extra: {'phone': phone, 'isAdmin': isAdmin},
        );
      },
      onError: (e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e), backgroundColor: AppColors.error),
        );
      },
      onAutoVerified: () {
        setState(() => _loading = false);
        context.go(isAdmin ? AppRoutes.adminDashboard : AppRoutes.home);
      },
    );
  }

  Future<void> _shareOnWhatsApp() async {
    const message =
        '👗 Shop the latest fashion at Balaji Textile & Garments!\n'
        'Quality clothes at the best prices.\n\n'
        '📲 Download now: $_playStoreUrl';

    final url = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openPlayStore() async {
    final url = Uri.parse(_playStoreUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openUrl(String urlStr) async {
    final url = Uri.parse(urlStr);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildTermsText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(fontSize: 12, color: AppColors.textHint),
        children: [
          const TextSpan(text: 'By continuing, you agree to our\n'),
          TextSpan(
            text: 'Terms of Service',
            style: const TextStyle(
              color: Color(0xFF0F6C5C),
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _openUrl(
                  'https://sites.google.com/d/1wkUi5NM36RXBYzxjhD4nwGlb_SOn3j86/p/1OL3pLCG_gC-6T3-WfaLwceX3hVX4E4_5/edit'),
          ),
          const TextSpan(text: ' & '),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(
              color: Color(0xFF0F6C5C),
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _openUrl(
                  'https://sites.google.com/d/1wkUi5NM36RXBYzxjhD4nwGlb_SOn3j86/p/1OL3pLCG_gC-6T3-WfaLwceX3hVX4E4_5/edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildShareRateSection() {
    return Column(
      children: [
        const Divider(height: 1, color: Color(0xFFE0E0E0)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _shareOnWhatsApp,
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F7ED),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.share_outlined,
                      color: Color(0xFF0F6C5C),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF555555),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 60),
            GestureDetector(
              onTap: _openPlayStore,
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.star_outline_rounded,
                      color: Color(0xFFFFA000),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Rate Us',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF555555),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        Image.asset(
          "assets/images/logo_transparent.png",
          height: 250,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        const Text(
          "15 Years of Trusted Quality",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F6C5C),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 32),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: Validators.phone,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone_outlined),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xFF0F6C5C), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xFF0F6C5C), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: AppColors.error, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: AppColors.error, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _loading ? null : _sendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F7ED),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Expanded(
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
  children: [

    Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [

            _buildLoginForm(),

            const SizedBox(height: 30),

            _buildShareRateSection(), // 👈 now below login button

          ],
        ),
      ),
    ),

    const SizedBox(height: 10),

    _buildTermsText(), // 👈 stays at bottom

    const SizedBox(height: 20),

  ],
),
            ),
          ),
        ],
      ),
    );
  }
}