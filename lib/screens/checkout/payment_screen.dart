import 'package:balaji_textile_and_garments/core/constants/app_colors.dart';
import 'package:balaji_textile_and_garments/core/constants/app_routes.dart';
import 'package:balaji_textile_and_garments/core/utils/extensions.dart';
import 'package:balaji_textile_and_garments/models/order_model.dart';
import 'package:balaji_textile_and_garments/models/user_model.dart';
import 'package:balaji_textile_and_garments/models/cart_item_model.dart';
import 'package:balaji_textile_and_garments/providers/auth_provider.dart';
import 'package:balaji_textile_and_garments/providers/cart_provider.dart';
import 'package:balaji_textile_and_garments/providers/order_provider.dart';
import 'package:balaji_textile_and_garments/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> extra;
  const PaymentScreen({required this.extra, super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  late final PaymentService _paymentService;
  bool _processing = false;

  late final CartItemModel? buyNowItem;
  late final double passedTotal;

  @override
  void initState() {
    super.initState();

    _paymentService = PaymentService();
    _paymentService.initialize(
      onSuccess: _onPaymentSuccess,
      onError: _onPaymentError,
    );

    buyNowItem  = widget.extra['buyNowItem'] as CartItemModel?;
    passedTotal = (widget.extra['total'] ?? 0).toDouble();
  }

  // ── Item list — BuyNow or Cart ───────────────────────────
  List<CartItemModel> _getItems() {
    if (buyNowItem != null) return [buyNowItem!];
    return ref.read(cartProvider);
  }

  // ── Total — passed from checkout ─────────────────────────
  double _getTotal() {
    if (buyNowItem != null) return passedTotal;
    return ref.read(cartTotalProvider);
  }

  // ── Payment success ──────────────────────────────────────
  Future<void> _onPaymentSuccess(
      String paymentId, String orderId, String signature) async {
    setState(() => _processing = true);

    try {
      final user        = ref.read(authStateProvider).value!;
      final userProfile = await ref.read(authServiceProvider).getUserProfile(user.uid);
      final address     = widget.extra['address'] as AddressModel;
      final items       = _getItems();

      // Use passedTotal — do NOT recalculate (avoids duplicate issue)
      final total    = _getTotal();
      final subtotal = items.fold<double>(0, (sum, item) => sum + item.subtotal);
      final shipping = (total - subtotal).clamp(0.0, double.infinity);

      final order = OrderModel(
        orderId:         '',
        userId:          user.uid,
        userPhone:       user.phoneNumber ?? '',
        userName:        widget.extra['name'] ?? userProfile?.name ?? '',
        items:           items,
        shippingAddress: address,
        subtotal:        subtotal,
        shippingFee:     shipping,
        totalPrice:      total,
        paymentId:       paymentId,
        paymentStatus:   'paid',
        orderStatus:     'pending',
      );

      final createdOrderId =
          await ref.read(orderServiceProvider).createOrder(order);

      // Clear cart only for normal cart flow
      if (buyNowItem == null) {
        ref.read(cartProvider.notifier).clearCart();
      }

      if (mounted) {
        context.go(AppRoutes.orderConfirmation, extra: createdOrderId);
      }
    } catch (e) {
      setState(() => _processing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order creation failed: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // ── Payment error ────────────────────────────────────────
  void _onPaymentError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: $message'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  // ── Open Razorpay ────────────────────────────────────────
  void _openRazorpay() {
    final user  = ref.read(authStateProvider).value;
    final total = _getTotal();

    _paymentService.openCheckout(
      amount: total,
      phone:  user?.phoneNumber ?? '',
      name:   widget.extra['name'] ?? '',
    );
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = buyNowItem != null
        ? [buyNowItem!]
        : ref.watch(cartProvider);

    final total = buyNowItem != null
        ? passedTotal
        : ref.watch(cartTotalProvider);

    final subtotal = items.fold<double>(0, (sum, item) => sum + item.subtotal);
    final shipping = (total - subtotal).clamp(0.0, double.infinity);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: _processing
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing your order...'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Heading ────────────────────────────
                  const Text(
                    'Payment Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),

                  // ── Order Summary Card ─────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      children: [

                        // Items
                        ...items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.name} × ${item.quantity}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Text(
                                    item.subtotal.inr,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )),

                        const Divider(height: 20),

                        // Subtotal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal',
                                style: TextStyle(color: AppColors.textSecondary)),
                            Text(subtotal.inr),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Shipping
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Shipping',
                                style: TextStyle(color: AppColors.textSecondary)),
                            Text(
                              shipping == 0 ? 'FREE' : shipping.inr,
                              style: TextStyle(
                                color: shipping == 0
                                    ? AppColors.success
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 20),

                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              total.inr,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Razorpay badge ─────────────────────
                  const Text(
                    'Powered by',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.security, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Secure payment via Razorpay',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // ── Pay Button ─────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _openRazorpay,
                      icon: const Icon(Icons.payment),
                      label: Text(
                        'Pay ${total.inr}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Center(
                    child: Text(
                      'UPI • Cards • Net Banking • Wallets',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textHint),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}