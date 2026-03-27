import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:balaji_textile_and_garments/models/order_model.dart';
import 'package:balaji_textile_and_garments/services/notification_service.dart';
import 'package:balaji_textile_and_garments/services/product_service.dart';
import 'package:balaji_textile_and_garments/models/address_model.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _productService = ProductService();
  final _notifService = NotificationService();

  CollectionReference get _col => _db.collection('orders');

  Future<void> _saveUserAddress(String userId, AddressModel address) async {
    final ref = _db
        .collection('users')
        .doc(userId)
        .collection('addresses');

    final existing = await ref
        .where('phone', isEqualTo: address.phone)
        .where('addressLine', isEqualTo: address.addressLine)
        .get();

    if (existing.docs.isEmpty) {
      await ref.add(address.toJson());
    }
  }

  Future<String> createOrder(OrderModel order) async {
    final doc = _col.doc();
    final map = order.toMap();
    map['order_id'] = doc.id;

    await _saveUserAddress(order.userId, order.shippingAddress);

    await doc.set(map);

    for (final item in order.items) {
      await _productService.decrementStock(item.productId, item.quantity);
    }

    await _notifService.sendOrderConfirmation(doc.id, order.userId);

    return doc.id;
  }

  Stream<List<OrderModel>> streamUserOrders(String userId) {
    return _col
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => OrderModel.fromDoc(d)).toList());
  }

  // ✅ FIXED: single order stream
  Stream<OrderModel?> streamSingleOrder(String orderId) {
    return _col.doc(orderId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return OrderModel.fromDoc(doc);
    });
  }

  // ✅ FIXED: correct field name
  Future<void> cancelOrder(String orderId) async {
    await _col.doc(orderId).update({
      'order_status': 'cancelled',
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<OrderModel?> getOrder(String orderId) async {
    final doc = await _col.doc(orderId).get();
    if (!doc.exists) return null;
    return OrderModel.fromDoc(doc);
  }

  // Admin
  Stream<List<OrderModel>> streamAllOrders({String? status}) {
    Query q = _col.orderBy('created_at', descending: true);
    if (status != null) {
      q = q.where('order_status', isEqualTo: status);
    }
    return q.snapshots()
        .map((s) => s.docs.map((d) => OrderModel.fromDoc(d)).toList());
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _col.doc(orderId).update({
      'order_status': status,
      'updated_at': FieldValue.serverTimestamp(),
    });

    final order = await getOrder(orderId);
    if (order != null) {
      await _notifService.sendOrderStatusUpdate(
          orderId, order.userId, status);
    }
  }

  Future<void> updatePaymentStatus(
      String orderId, String paymentId, String status) async {
    await _col.doc(orderId).update({
      'payment_id': paymentId,
      'payment_status': status,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>> getAdminStats(
      DateTime start, DateTime end) async {
    final endPlusOne = end.add(const Duration(days: 1));

    final snap = await _col
        .where('created_at',
            isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('created_at',
            isLessThan: Timestamp.fromDate(endPlusOne))
        .get();

    double total = 0;
    int paid = 0;

    for (final doc in snap.docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data['payment_status'] == 'paid') {
        total += (data['total_price'] ?? 0).toDouble();
        paid++;
      }
    }

    return {
      'total_orders': snap.docs.length,
      'paid_orders': paid,
      'total_revenue': total,
    };
  }
}