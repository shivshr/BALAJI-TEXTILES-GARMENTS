import 'package:balaji_textile_and_garments/core/constants/app_colors.dart';
import 'package:balaji_textile_and_garments/core/constants/app_routes.dart';
import 'package:balaji_textile_and_garments/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileProvider);
    final authUser  = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettings(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_rounded, size: 48, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  userAsync.when(
                    data: (u) => Column(
                      children: [
                        Text(
                          u?.name ?? 'User',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authUser?.phoneNumber ?? '',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    loading: () => const CircularProgressIndicator(color: Colors.white),
                    error: (_, __) => const Text('Error loading profile',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 12),
                  // Edit Profile button
                  OutlinedButton.icon(
                    onPressed: () => _showEditProfile(context, ref),
                    icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                    label: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Menu items ───────────────────────────────────
            _MenuItem(
              icon: Icons.shopping_bag_outlined,
              label: 'My Orders',
              onTap: () => context.push(AppRoutes.myOrders),
            ),
            _MenuItem(
              icon: Icons.favorite_outline,
              label: 'Wishlist',
              onTap: () => context.push(AppRoutes.wishlist),
            ),
            _MenuItem(
              icon: Icons.location_on_outlined,
              label: 'Delivery Addresses',
              onTap: () => context.push(AppRoutes.deliveryAddresses),
            ),
            // _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () => context.push(AppRoutes.notifications)),
            // _MenuItem(icon: Icons.help_outline, label: 'Help & Support', onTap: () {}),

            const Divider(height: 1),

            _MenuItem(
              icon: Icons.logout,
              label: 'Sign Out',
              color: AppColors.error,
              onTap: () async {
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) context.go(AppRoutes.phoneLogin);
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context, WidgetRef ref) {
    final authUser = ref.read(authStateProvider).value;
    final user     = ref.read(currentUserProfileProvider).value;
    final nameCtrl = TextEditingController(text: user?.name ?? '');
    final formKey  = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Edit Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),

                // Name
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
                ),

                const SizedBox(height: 14),

                // Phone (read-only)
                TextFormField(
                  initialValue: authUser?.phoneNumber ?? '',
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    helperText: 'Primary number cannot be changed',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),

                const SizedBox(height: 24),

                // Save button
                StatefulBuilder(
                  builder: (ctx, setSaving) {
                    bool saving = false;
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: saving
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;
                                setSaving(() => saving = true);
                                try {
                                  final uid = authUser?.uid ?? '';
                                  await ref.read(authServiceProvider).updateUserProfile(
                                    uid,
                                    {'name': nameCtrl.text.trim()},
                                  );
                                  ref.invalidate(currentUserProfileProvider);
                                  if (ctx.mounted) Navigator.pop(ctx);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Profile updated!'),
                                        backgroundColor: AppColors.primary,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  setSaving(() => saving = false);
                                  if (ctx.mounted) {
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: saving
                            ? const SizedBox(
                                height: 22, width: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Text('Save Changes',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Consumer(
        builder: (_, ref, __) {
          final mode = ref.watch(themeModeProvider);
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: mode == ThemeMode.dark,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) {
                    ref.read(themeModeProvider.notifier).state =
                        v ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(label,
          style: TextStyle(fontWeight: FontWeight.w500, color: color ?? AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
      onTap: onTap,
    );
  }
}