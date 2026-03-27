import 'package:balaji_textile_and_garments/models/order_model.dart';
import 'package:balaji_textile_and_garments/providers/auth_provider.dart';
import 'package:balaji_textile_and_garments/services/order_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderServiceProvider = Provider<OrderService>((ref) => OrderService());

final userOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();
  return ref.watch(orderServiceProvider).streamUserOrders(user.uid);
});

final allOrdersProvider = StreamProvider.family<List<OrderModel>, String?>((ref, status) {
  return ref.watch(orderServiceProvider).streamAllOrders(status: status);
});

final singleOrderProvider = StreamProvider.family<OrderModel?, String>((ref, orderId) {
  return ref.watch(orderServiceProvider).streamSingleOrder(orderId);
});

// ── Date range record type ──
typedef DateRange = ({DateTime start, DateTime end});

final adminStatsProvider =
    FutureProvider.family<Map<String, dynamic>, DateRange>((ref, range) {
  return ref.watch(orderServiceProvider).getAdminStats(range.start, range.end);
});