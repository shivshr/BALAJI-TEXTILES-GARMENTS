import 'package:cached_network_image/cached_network_image.dart';
import 'package:balaji_textile_and_garments/core/constants/app_colors.dart';
import 'package:balaji_textile_and_garments/core/utils/extensions.dart';
import 'package:balaji_textile_and_garments/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ ADDED

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;
  const OrderDetailScreen({required this.orderId, super.key});

  // ✅ ADDED (NO EXISTING CODE MODIFIED)
  Future<void> _openMap(String address) async {
    final query = Uri.encodeComponent(address);

    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$query",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(singleOrderProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: orderAsync.when(
        data: (order) {
          if (order == null) return const Center(child: Text('Order not found'));
          final steps = ['pending', 'processing', 'shipped', 'delivered'];
          final currentStep = steps.indexOf(order.orderStatus);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (order.orderStatus != 'cancelled')
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Order Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 16),
                          Row(
                            children: List.generate(steps.length, (i) {
                              final isDone = i <= currentStep;
                              return Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        if (i > 0) Expanded(child: Container(height: 2, color: isDone ? AppColors.primary : AppColors.divider)),
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isDone ? AppColors.primary : AppColors.divider,
                                          ),
                                          child: Icon(steps[i].statusIcon, size: 14, color: Colors.white),
                                        ),
                                        if (i < steps.length - 1) Expanded(child: Container(height: 2, color: i < currentStep ? AppColors.primary : AppColors.divider)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(steps[i].capitalize,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: isDone ? FontWeight.w600 : FontWeight.normal,
                                          color: isDone ? AppColors.primary : AppColors.textHint,
                                        )),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Card(
                    color: AppColors.outOfStockBg,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.cancel_rounded, color: AppColors.error),
                          SizedBox(width: 12),
                          Text('This order was cancelled', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.error)),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order Info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        _InfoRow('Order ID', '#${order.orderId.substring(0, 8).toUpperCase()}'),
                        _InfoRow('Date', order.createdAt?.formatted ?? ''),
                        _InfoRow('Payment', order.paymentStatus.capitalize),
                        _InfoRow('Method', order.paymentMethod.capitalize),
                      ],
                    ),
                  ),
                ),

                if (order.orderStatus == 'pending' || order.orderStatus == 'processing')
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Cancel Order"),
                              content: const Text("Are you sure you want to cancel this order?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Yes"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await ref.read(orderServiceProvider).cancelOrder(order.orderId);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Order cancelled successfully")),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Cancel Order",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                else if (order.orderStatus == 'cancelled')
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Order Cancelled",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // ✅ ONLY CHANGE HERE (WRAPPED WITH CLICK)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Builder(
                      builder: (_) {
                        final address = order.shippingAddress;

                        final fullAddress =
                            "${address.addressLine}, ${address.city}, ${address.state}, ${address.pincode}";

                        return GestureDetector(
                          onTap: () {
                            _openMap(fullAddress);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Delivery Address',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              Text(address.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(
                                "${address.addressLine},\n"
                                "${address.city}, ${address.state} - ${address.pincode}\n"
                                "Phone: ${address.phone}",
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        ...order.items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: item.imageUrl,
                                      width: 56,
                                      height: 62,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.name),
                                        Text('Qty: ${item.quantity}'),
                                      ],
                                    ),
                                  ),
                                  Text(item.subtotal.inr),
                                ],
                              ),
                            )),
                        const Divider(),
                        _InfoRow('Subtotal', order.subtotal.inr),
                        _InfoRow('Shipping', order.shippingFee == 0 ? 'FREE' : order.shippingFee.inr),
                        _InfoRow('Total', order.totalPrice.inr, bold: true),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _InfoRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}