import 'package:fashion_app/providers/auth_provider.dart';
import 'package:fashion_app/screens/admin/admin_dashboard_screen.dart';
import 'package:fashion_app/screens/admin/admin_login_screen.dart';
import 'package:fashion_app/screens/admin/add_product_screen.dart';
import 'package:fashion_app/screens/admin/manage_products_screen.dart';
import 'package:fashion_app/screens/admin/order_management_screen.dart';
import 'package:fashion_app/screens/auth/otp_verify_screen.dart';
import 'package:fashion_app/screens/auth/phone_login_screen.dart';
import 'package:fashion_app/screens/cart/cart_screen.dart';
import 'package:fashion_app/screens/checkout/checkout_screen.dart';
import 'package:fashion_app/screens/checkout/order_confirmation_screen.dart';
import 'package:fashion_app/screens/checkout/payment_screen.dart';
import 'package:fashion_app/screens/home/home_screen.dart';
import 'package:fashion_app/screens/orders/my_orders_screen.dart';
import 'package:fashion_app/screens/orders/order_detail_screen.dart';
import 'package:fashion_app/screens/products/product_detail_screen.dart';
import 'package:fashion_app/screens/products/product_list_screen.dart';
import 'package:fashion_app/screens/products/search_screen.dart';
import 'package:fashion_app/screens/profile/profile_screen.dart';
import 'package:fashion_app/screens/splash/splash_screen.dart';
import 'package:fashion_app/screens/wishlist/wishlist_screen.dart';
import 'package:fashion_app/screens/kids/kids_category_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const splash = '/';
  static const phoneLogin = '/login';
  static const otpVerify = '/otp';

  static const home = '/home';
  static const search = '/search';
  static const cart = '/cart';
  static const wishlist = '/wishlist';
  static const profile = '/profile';

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
        ],
      ),

      GoRoute(
        path: AppRoutes.productList,
        builder: (_, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic> && extra.containsKey('gender')) {
            return ProductListScreen(filters: extra);
          }
          return ProductListScreen(category: extra as String?);
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