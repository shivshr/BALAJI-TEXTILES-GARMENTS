import 'package:balaji_textile_and_garments/core/constants/app_colors.dart';
import 'package:balaji_textile_and_garments/core/constants/app_routes.dart';
import 'package:balaji_textile_and_garments/core/utils/extensions.dart';
import 'package:balaji_textile_and_garments/core/utils/validators.dart';
import 'package:balaji_textile_and_garments/models/cart_item_model.dart';
import 'package:balaji_textile_and_garments/models/address_model.dart' as addr;
import 'package:balaji_textile_and_garments/providers/auth_provider.dart';
import 'package:balaji_textile_and_garments/providers/cart_provider.dart';
import 'package:balaji_textile_and_garments/providers/location_provider.dart';
import 'package:balaji_textile_and_garments/providers/address_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {

  final _formKey     = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _streetCtrl  = TextEditingController();
  final _cityCtrl    = TextEditingController();
  final _stateCtrl   = TextEditingController();
  final _pincodeCtrl = TextEditingController();

  int? _selectedAddressIndex;

  @override
  void initState() {
    super.initState();
    _prefillAddress();
  }

  Future<void> _prefillAddress() async {
    final locationAsync = ref.read(locationProvider);

    locationAsync.whenData((addressString) {
      final parts = addressString.split(',').map((e) => e.trim()).toList();
      if (parts.isNotEmpty) _streetCtrl.text = parts[0];
      if (parts.length > 1) _cityCtrl.text   = parts[1];
      if (parts.length > 2) {
        final statePin = parts[2];
        final pinRegex = RegExp(r'\d{5,6}');
        final match    = pinRegex.firstMatch(statePin);
        if (match != null) {
          _pincodeCtrl.text = match.group(0)!;
          _stateCtrl.text   = statePin.replaceAll(match.group(0)!, '').trim();
        } else {
          _stateCtrl.text = statePin;
        }
      }
      if (parts.length > 3 && _pincodeCtrl.text.isEmpty) {
        final match = RegExp(r'\d{5,6}').firstMatch(parts[3]);
        if (match != null) _pincodeCtrl.text = match.group(0)!;
      }
    });

    final user = ref.read(currentUserProfileProvider).value;
    if (user != null) {
      _nameCtrl.text = user.name ?? '';
      // ✅ user.address is now UserAddressModel — no conflict
      if (user.address != null) {
        if (_streetCtrl.text.isEmpty)  _streetCtrl.text  = user.address!.street;
        if (_cityCtrl.text.isEmpty)    _cityCtrl.text    = user.address!.city;
        if (_stateCtrl.text.isEmpty)   _stateCtrl.text   = user.address!.state;
        if (_pincodeCtrl.text.isEmpty) _pincodeCtrl.text = user.address!.pincode;
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pincodeCtrl.dispose();
    super.dispose();
  }

  CartItemModel? _getBuyNowItem(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    if (extra is Map && extra['buyNowItem'] != null) {
      return extra['buyNowItem'] as CartItemModel;
    }
    return null;
  }

  void _proceed(BuildContext context) async {
  if (!_formKey.currentState!.validate()) return;

  final address = addr.AddressModel(
    name:        _nameCtrl.text.trim(),
    phone:       '',
    addressLine: _streetCtrl.text.trim(),
    city:        _cityCtrl.text.trim(),
    state:       _stateCtrl.text.trim(),
    pincode:     _pincodeCtrl.text.trim(),
  );

  final userId = ref.read(authStateProvider).value!.uid;

  // ✅ SAVE ADDRESS IN FIRESTORE
  final refCol = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('addresses');

  final existing = await refCol
      .where('addressLine', isEqualTo: address.addressLine)
      .where('pincode', isEqualTo: address.pincode)
      .get();

  if (existing.docs.isEmpty) {
    await refCol.add(address.toJson());
  }

  // 🔥 NORMAL FLOW SAME
  final CartItemModel? buyNowItem = _getBuyNowItem(context);
  final List<CartItemModel> cartItems = ref.read(cartProvider);
  final List<CartItemModel> items =
      buyNowItem != null ? [buyNowItem] : cartItems;

  final double subtotal =
      items.fold(0.0, (sum, item) => sum + item.subtotal);
  final double shipping = subtotal > 999 ? 0.0 : 99.0;
  final double total = subtotal + shipping;

  context.push(
    AppRoutes.payment,
    extra: {
      'address': address,
      'name': _nameCtrl.text.trim(),
      'total': total,
      if (buyNowItem != null) 'buyNowItem': buyNowItem,
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final CartItemModel? buyNowItem     = _getBuyNowItem(context);
    final List<CartItemModel> cartItems = ref.watch(cartProvider);
    final List<CartItemModel> items     = buyNowItem != null ? [buyNowItem] : cartItems;
    final double subtotal               = items.fold(0.0, (sum, item) => sum + item.subtotal);
    final double shipping               = subtotal > 999 ? 0.0 : 99.0;
    final double total                  = subtotal + shipping;
    final savedAddresses                = ref.watch(addressProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: _BottomPayBar(
        total: total,
        onPay: () => _proceed(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Saved Addresses ──────────────────────────
              if (savedAddresses.isNotEmpty) ...[
                _SectionHeader(
                    icon: Icons.bookmark_rounded, title: 'Saved Addresses'),
                const SizedBox(height: 10),
                ...savedAddresses.asMap().entries.map((entry) {
                  final i        = entry.key;
                  final addrItem = entry.value;
                  final selected = _selectedAddressIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedAddressIndex = i;
                      _nameCtrl.text    = addrItem.name;
                      _streetCtrl.text  = addrItem.addressLine;
                      _cityCtrl.text    = addrItem.city;
                      _stateCtrl.text   = addrItem.state;
                      _pincodeCtrl.text = addrItem.pincode;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withOpacity(0.06)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : Colors.grey.shade200,
                          width: selected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              selected
                                  ? Icons.check_rounded
                                  : Icons.location_on_outlined,
                              color: selected
                                  ? Colors.white
                                  : Colors.grey.shade500,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(addrItem.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                    )),
                                const SizedBox(height: 2),
                                Text(
                                  '${addrItem.addressLine}, ${addrItem.city}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${addrItem.state} - ${addrItem.pincode}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
              ],

              // ── New Address Form ─────────────────────────
              _SectionHeader(
                icon: Icons.edit_location_alt_rounded,
                title: savedAddresses.isEmpty
                    ? 'Delivery Address'
                    : 'Or Enter New Address',
              ),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _StyledField(
                      controller: _nameCtrl,
                      label: 'Full Name',
                      icon: Icons.person_outline_rounded,
                      validator: Validators.required,
                    ),
                    const SizedBox(height: 14),
                    _StyledField(
                      controller: _streetCtrl,
                      label: 'Street Address',
                      icon: Icons.home_outlined,
                      validator: Validators.required,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _StyledField(
                            controller: _cityCtrl,
                            label: 'City',
                            icon: Icons.location_city_outlined,
                            validator: Validators.required,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StyledField(
                            controller: _stateCtrl,
                            label: 'State',
                            icon: Icons.map_outlined,
                            validator: Validators.required,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _StyledField(
                      controller: _pincodeCtrl,
                      label: 'Pincode',
                      icon: Icons.pin_outlined,
                      validator: Validators.pincode,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Order Summary ────────────────────────────
              _SectionHeader(
                  icon: Icons.receipt_long_rounded, title: 'Order Summary'),
              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ...items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text('×${item.quantity}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      )),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(item.name,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text(item.subtotal.inr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                            ],
                          ),
                        )),

                    const Divider(height: 20, color: Colors.black12),

                    _SummaryRow('Subtotal', subtotal.inr),
                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping',
                            style:
                                TextStyle(color: Colors.grey.shade600)),
                        shipping == 0.0
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text('FREE',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    )),
                              )
                            : Text(shipping.inr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                      ],
                    ),

                    if (subtotal <= 999) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_shipping_outlined,
                                size: 14, color: Colors.orange.shade700),
                            const SizedBox(width: 6),
                            Text(
                              'Add ₹${(1000 - subtotal).toStringAsFixed(0)} more for FREE shipping!',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const Divider(height: 20, color: Colors.black12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                        Text(total.inr,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            )),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bottom Pay Bar ────────────────────────────────────────────
class _BottomPayBar extends StatelessWidget {
  final double total;
  final VoidCallback onPay;
  const _BottomPayBar({required this.total, required this.onPay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onPay,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'Proceed to Pay ${total.inr}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

// ── Styled Field ──────────────────────────────────────────────
class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;

  const _StyledField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.maxLength,
    this.maxLines = 1,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        counterText: '',
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14),
      ),
    );
  }
}

// ── Summary Row ───────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight:
                    bold ? FontWeight.w700 : FontWeight.normal)),
        Text(value,
            style: TextStyle(
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                color: bold ? AppColors.primary : null)),
      ],
    );
  }
}