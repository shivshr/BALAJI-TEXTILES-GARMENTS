import 'package:balaji_textile_and_garments/core/constants/app_colors.dart';
import 'package:balaji_textile_and_garments/core/constants/app_routes.dart';
import 'package:balaji_textile_and_garments/core/utils/extensions.dart';
import 'package:balaji_textile_and_garments/providers/auth_provider.dart';
import 'package:balaji_textile_and_garments/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {

  // Default: current month start → today
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate   = now;
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2023),
      lastDate: _endDate,
      helpText: 'Select Start Date',
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
      helpText: 'Select End Date',
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {

    final range      = (start: _startDate, end: _endDate);
    final statsAsync = ref.watch(adminStatsProvider(range));
    final recentOrdersAsync = ref.watch(allOrdersProvider(null));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authServiceProvider).adminLogout();
              if (context.mounted) context.go(AppRoutes.phoneLogin);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Overview heading ─────────────────────────
            const Text(
              'Overview',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            // ── Date Range Picker ────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [

                  // Start Date
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickStartDate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'From',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                _fmt(_startDate),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Arrow
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.arrow_forward,
                        size: 18, color: AppColors.textSecondary),
                  ),

                  // End Date
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickEndDate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'To',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                _fmt(_endDate),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Refresh icon
                  IconButton(
                    icon: const Icon(Icons.refresh, color: AppColors.primary),
                    tooltip: 'Refresh',
                    onPressed: () => setState(() {}),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Stats Grid ───────────────────────────────
            statsAsync.when(
              data: (stats) => GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _StatCard('Total Orders',
                      '${stats['total_orders']}',
                      Icons.receipt_long_rounded, AppColors.primary),
                  _StatCard('Revenue',
                      (stats['total_revenue'] as double).inr,
                      Icons.currency_rupee_rounded, AppColors.success),
                  _StatCard('Paid Orders',
                      '${stats['paid_orders']}',
                      Icons.check_circle_rounded, AppColors.info),
                  _StatCard('Pending',
                      '${(stats['total_orders'] as int) - (stats['paid_orders'] as int)}',
                      Icons.hourglass_empty_rounded, AppColors.warning),
                ],
              ),
              loading: () => const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Error: $e'),
            ),

            const SizedBox(height: 24),

            // ── Quick Actions ────────────────────────────
            const Text('Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2,
              children: [
                _ActionCard('Add Product', Icons.add_box_outlined,
                    AppColors.primary, () => context.push(AppRoutes.addProduct)),
                _ActionCard('All Products', Icons.inventory_2_outlined,
                    AppColors.info, () => context.push(AppRoutes.manageProducts)),
                _ActionCard('All Orders', Icons.list_alt_rounded,
                    AppColors.warning, () => context.push(AppRoutes.orderManagement)),
                _ActionCard('Customer App', Icons.phone_android_rounded,
                    AppColors.success, () => context.go(AppRoutes.home)),
                _ActionCard('Manage Banners',Icons.image_outlined,
                    AppColors.success,() => context.push(AppRoutes.manageBanners),),
              ],
            ),

            const SizedBox(height: 24),

            // ── Recent Orders ────────────────────────────
            const Text('Recent Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

            recentOrdersAsync.when(
              data: (orders) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.take(5).length,
                itemBuilder: (_, i) {
                  final o = orders[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        '#${o.orderId.substring(0, 8).toUpperCase()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      subtitle: Text('${o.userPhone} • ${o.items.length} item(s)'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(o.totalPrice.inr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: o.orderStatus.statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              o.orderStatus.capitalize,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: o.orderStatus.statusColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      onTap: () => context.push('/order/${o.orderId}'),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Stat Card ────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: color)),
                Text(title,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Action Card ──────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard(this.label, this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}