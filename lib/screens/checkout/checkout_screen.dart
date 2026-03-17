import 'package:balaji_textile_and_garments/core/constants/app_colors.dart';
import 'package:balaji_textile_and_garments/core/constants/app_routes.dart';
import 'package:balaji_textile_and_garments/core/utils/extensions.dart';
import 'package:balaji_textile_and_garments/core/utils/validators.dart';
import 'package:balaji_textile_and_garments/models/cart_item_model.dart';
import 'package:balaji_textile_and_garments/providers/auth_provider.dart';
import 'package:balaji_textile_and_garments/providers/cart_provider.dart';
import 'package:balaji_textile_and_garments/providers/location_provider.dart';
import 'package:balaji_textile_and_garments/providers/address_provider.dart';
import 'package:balaji_textile_and_garments/models/address_model.dart' as addr;

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
        final pinRegex = RegExp(r'\d{5,6}');
        final match    = pinRegex.firstMatch(parts[3]);
        if (match != null) _pincodeCtrl.text = match.group(0)!;
      }
    });

    final user = ref.read(currentUserProfileProvider).value;

    if (user?.address != null) {
      _nameCtrl.text = user?.name ?? '';
      if (_streetCtrl.text.isEmpty)  _streetCtrl.text  = user!.address!.street;
      if (_cityCtrl.text.isEmpty)    _cityCtrl.text    = user!.address!.city;
      if (_stateCtrl.text.isEmpty)   _stateCtrl.text   = user!.address!.state;
      if (_pincodeCtrl.text.isEmpty) _pincodeCtrl.text = user!.address!.pincode;
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

  // ── Helper: get buyNowItem safely cast ───────────────────
  CartItemModel? _getBuyNowItem(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    if (extra is Map && extra['buyNowItem'] != null) {
      return extra['buyNowItem'] as CartItemModel;
    }
    return null;
  }

  void _proceed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final address = addr.AddressModel(
      name:        _nameCtrl.text.trim(),
      phone:       '',
      addressLine: _streetCtrl.text.trim(),
      city:        _cityCtrl.text.trim(),
      state:       _stateCtrl.text.trim(),
      pincode:     _pincodeCtrl.text.trim(),
    );

    final CartItemModel? buyNowItem = _getBuyNowItem(context);
    final List<CartItemModel> cartItems = ref.read(cartProvider);
    final List<CartItemModel> items = buyNowItem != null
        ? [buyNowItem]
        : cartItems;

    final double subtotal = items.fold(0.0, (sum, item) => sum + item.subtotal);
    final double shipping  = subtotal > 999 ? 0.0 : 99.0;
    final double total     = subtotal + shipping;

    context.push(
      AppRoutes.payment,
      extra: {
        'address': address,
        'name':    _nameCtrl.text.trim(),
        'total':   total,
        if (buyNowItem != null) 'buyNowItem': buyNowItem,
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    // ✅ Explicit cast — fixes 'double has no getter inr' error
    final CartItemModel? buyNowItem = _getBuyNowItem(context);
    final List<CartItemModel> cartItems = ref.watch(cartProvider);
    final List<CartItemModel> items = buyNowItem != null
        ? [buyNowItem]
        : cartItems;

    final double subtotal = items.fold(0.0, (sum, item) => sum + item.subtotal);
    final double shipping  = subtotal > 999 ? 0.0 : 99.0;
    final double total     = subtotal + shipping;

    final savedAddresses = ref.watch(addressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Saved Addresses ──────────────────────────
              const Text('Saved Addresses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),

              if (savedAddresses.isNotEmpty)
                ...savedAddresses.map((addrItem) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(addrItem.name),
                        subtitle: Text(
                          '${addrItem.addressLine}, ${addrItem.city}, '
                          '${addrItem.state} - ${addrItem.pincode}',
                        ),
                        onTap: () => setState(() {
                          _nameCtrl.text    = addrItem.name;
                          _streetCtrl.text  = addrItem.addressLine;
                          _cityCtrl.text    = addrItem.city;
                          _stateCtrl.text   = addrItem.state;
                          _pincodeCtrl.text = addrItem.pincode;
                        }),
                      ),
                    )),

              const SizedBox(height: 20),

              // ── New Address ──────────────────────────────
              const Text('Or Enter New Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameCtrl,
                validator: Validators.required,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _streetCtrl,
                validator: Validators.required,
                decoration: const InputDecoration(labelText: 'Street Address'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityCtrl,
                      validator: Validators.required,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stateCtrl,
                      validator: Validators.required,
                      decoration: const InputDecoration(labelText: 'State'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _pincodeCtrl,
                validator: Validators.pincode,
                keyboardType: TextInputType.number,
                maxLength: 6,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 24),

              // ── Order Summary ────────────────────────────
              const Text('Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),

              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.name} (x${item.quantity})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        item.subtotal.inr,  // ✅ works — CartItemModel, not dynamic
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(height: 24),

              _SummaryRow('Subtotal', subtotal.inr),
              _SummaryRow(
                'Shipping',
                shipping == 0.0 ? 'FREE' : shipping.inr,
              ),

              const Divider(height: 16),

              _SummaryRow('Total', total.inr, bold: true),

              const SizedBox(height: 24),

              // ── Proceed Button ───────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _proceed(context),
                  child: Text(
                    'Pay ${total.inr}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Summary Row ───────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool   bold;

  const _SummaryRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight:
                      bold ? FontWeight.w700 : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  color: bold ? AppColors.primary : null)),
        ],
      ),
    );
  }
}