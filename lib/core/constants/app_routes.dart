import 'package:balaji_textile_and_garments/providers/auth_provider.dart';
import 'package:balaji_textile_and_garments/screens/admin/admin_dashboard_screen.dart';
import 'package:balaji_textile_and_garments/screens/admin/admin_login_screen.dart';
import 'package:balaji_textile_and_garments/screens/admin/add_product_screen.dart';
import 'package:balaji_textile_and_garments/screens/admin/manage_products_screen.dart';
import 'package:balaji_textile_and_garments/screens/admin/order_management_screen.dart';
import 'package:balaji_textile_and_garments/screens/auth/otp_verify_screen.dart';
import 'package:balaji_textile_and_garments/screens/auth/phone_login_screen.dart';
import 'package:balaji_textile_and_garments/screens/cart/cart_screen.dart';
import 'package:balaji_textile_and_garments/screens/checkout/checkout_screen.dart';
import 'package:balaji_textile_and_garments/screens/checkout/order_confirmation_screen.dart';
import 'package:balaji_textile_and_garments/screens/checkout/payment_screen.dart';
import 'package:balaji_textile_and_garments/screens/home/home_screen.dart';
import 'package:balaji_textile_and_garments/screens/orders/my_orders_screen.dart';
import 'package:balaji_textile_and_garments/screens/orders/order_detail_screen.dart';
import 'package:balaji_textile_and_garments/screens/products/product_detail_screen.dart';
import 'package:balaji_textile_and_garments/screens/products/product_list_screen.dart';
import 'package:balaji_textile_and_garments/screens/products/search_screen.dart';
import 'package:balaji_textile_and_garments/screens/profile/profile_screen.dart';
import 'package:balaji_textile_and_garments/screens/splash/splash_screen.dart';
import 'package:balaji_textile_and_garments/screens/wishlist/wishlist_screen.dart';
import 'package:balaji_textile_and_garments/screens/kids/kids_category_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:balaji_textile_and_garments/screens/profile/delivery_addresses_screen.dart';
import 'package:balaji_textile_and_garments/screens/profile/notifications_screen.dart';
import 'package:balaji_textile_and_garments/screens/admin/banner_management_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const phoneLogin = '/login';
  static const otpVerify = '/otp';

  static const home = '/home';
  static const search = '/search';
  static const cart = '/cart';
  static const wishlist = '/wishlist';
  static const profile = '/profile';
  static const deliveryAddresses = '/delivery-addresses';

  static const productList = '/products';
  static const productDetail = '/product/:id';

  static const checkout = '/checkout';
  static const payment = '/payment';
  static const orderConfirmation = '/order-confirmation';

  static const myOrders = '/orders';
  static const orderDetail = '/order/:id';

  static const adminLogin = '/admin/login';
  static const adminDashboard = '/admin/dashboard';
  static const addProduct = '/admin/add-product';
  static const manageProducts = '/admin/products';
  static const orderManagement = '/admin/orders';

  static const kidsCategory = '/kids-category';
  static const notifications = '/notifications';
  static const manageBanners = '/admin/banners';
  
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    // NO redirect — navigation is handled directly by each screen
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.phoneLogin,
        builder: (_, __) => const PhoneLoginScreen(),
      ),
      GoRoute(
  path: AppRoutes.manageBanners,
  builder: (context, state) => const BannerManagementScreen(),
),
      GoRoute(
        path: AppRoutes.otpVerify,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OtpVerifyScreen(
            phone: extra['phone'] as String,
            isAdmin: extra['isAdmin'] as bool? ?? false,
          );
        },
      ),

      // Admin routes
      GoRoute(path: AppRoutes.adminLogin,      builder: (_, __) => const AdminLoginScreen()),
      GoRoute(path: AppRoutes.adminDashboard,  builder: (_, __) => const AdminDashboardScreen()),
      GoRoute(path: AppRoutes.manageProducts,  builder: (_, __) => const ManageProductsScreen()),
      GoRoute(path: AppRoutes.orderManagement, builder: (_, __) => const OrderManagementScreen()),
      GoRoute(
        path: AppRoutes.addProduct,
        builder: (_, state) => AddProductScreen(product: state.extra),
      ),

      // Customer routes with bottom nav
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(path: AppRoutes.home,         builder: (_, __) => const HomeScreen()),
          GoRoute(path: AppRoutes.search,       builder: (_, __) => const SearchScreen()),
          GoRoute(path: AppRoutes.cart,         builder: (_, __) => const CartScreen()),
          GoRoute(path: AppRoutes.wishlist,     builder: (_, __) => const WishlistScreen()),
          GoRoute(path: AppRoutes.profile,      builder: (_, __) => const ProfileScreen()),
          GoRoute(path: AppRoutes.kidsCategory, builder: (_, __) => const KidsCategoryScreen()),
          GoRoute(path: AppRoutes.deliveryAddresses, builder: (_, __) => const DeliveryAddressesScreen(),),
          GoRoute(path: AppRoutes.notifications,builder: (_, __) => const NotificationsScreen(),),
        ],
      ),

      GoRoute(
  path: AppRoutes.productList,
  builder: (_, state) {
    final extra = state.extra;

    // Kids filters (existing functionality)
    if (extra is Map<String, dynamic> && extra.containsKey('gender')) {
      return ProductListScreen(filters: extra);
    }

    // Subcategory navigation (NEW)
    if (extra is Map<String, dynamic> &&
        extra.containsKey('category') &&
        extra.containsKey('subcategory')) {
      return ProductListScreen(
        category: extra['category'],
        subcategory: extra['subcategory'],
      );
    }

    // Normal category navigation (existing functionality)
    if (extra is String) {
      return ProductListScreen(category: extra);
    }

    return const ProductListScreen();
  },
),
      GoRoute(
        path: AppRoutes.productDetail,
        builder: (_, state) => ProductDetailScreen(
          productId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(path: AppRoutes.checkout, builder: (_, __) => const CheckoutScreen()),
      GoRoute(
        path: AppRoutes.payment,
        builder: (_, state) => PaymentScreen(extra: state.extra as Map<String, dynamic>),
      ),
      GoRoute(
        path: AppRoutes.orderConfirmation,
        builder: (_, state) => OrderConfirmationScreen(orderId: state.extra as String),
      ),
      GoRoute(path: AppRoutes.myOrders, builder: (_, __) => const MyOrdersScreen()),
      GoRoute(
        path: AppRoutes.orderDetail,
        builder: (_, state) => OrderDetailScreen(orderId: state.pathParameters['id']!),
      ),
    ],
  );
});