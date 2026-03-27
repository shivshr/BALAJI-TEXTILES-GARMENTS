// import 'package:balaji_textile_and_garments/models/cart_item_model.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CartNotifier extends StateNotifier<List<CartItemModel>> {
//   CartNotifier() : super([]);

//   /// ADD ITEM
//   void addItem(CartItemModel item) {
//     final idx = state.indexWhere(
//       (e) =>
//           e.productId == item.productId &&
//           e.selectedSize == item.selectedSize,
//     );

//     if (idx >= 0) {
//       final existing = state[idx];
//       final newQty = existing.quantity + item.quantity;

//       if (newQty <= existing.availableStock) {
//         state = [
//           ...state.sublist(0, idx),
//           existing.copyWith(quantity: newQty),
//           ...state.sublist(idx + 1),
//         ];
//       }
//     } else {
//       state = [...state, item];
//     }
//   }

//   /// REMOVE ITEM
//   void removeItem(String productId, String size) {
//     state = state
//         .where((e) =>
//             !(e.productId == productId && e.selectedSize == size))
//         .toList();
//   }

//   /// UPDATE QUANTITY
//   void updateQuantity(String productId, String size, int qty) {
//     if (qty <= 0) {
//       removeItem(productId, size);
//       return;
//     }

//     state = state.map((e) {
//       if (e.productId == productId && e.selectedSize == size) {
//         return e.copyWith(
//           quantity: qty.clamp(1, e.availableStock),
//         );
//       }
//       return e;
//     }).toList();
//   }

//   /// CLEAR CART
//   void clearCart() {
//     state = [];
//   }
// }

// final cartProvider =
//     StateNotifierProvider<CartNotifier, List<CartItemModel>>(
//   (ref) => CartNotifier(),
// );

// /// ================================
// /// DERIVED PROVIDERS (AUTO UPDATE)
// /// ================================

// /// SUBTOTAL
// final cartSubtotalProvider = Provider<double>((ref) {
//   final cart = ref.watch(cartProvider);

//   return cart.fold(
//     0,
//     (sum, item) => sum + (item.price * item.quantity),
//   );
// });

// /// SHIPPING
// final cartShippingFeeProvider = Provider<double>((ref) {
//   final subtotal = ref.watch(cartSubtotalProvider);

//   return subtotal >= 999 ? 0 : 99;
// });

// /// TOTAL
// final cartTotalProvider = Provider<double>((ref) {
//   final subtotal = ref.watch(cartSubtotalProvider);
//   final shipping = ref.watch(cartShippingFeeProvider);

//   return subtotal + shipping;
// });

// /// ITEM COUNT
// final cartItemCountProvider = Provider<int>((ref) {
//   final cart = ref.watch(cartProvider);

//   return cart.fold(
//     0,
//     (sum, item) => sum + item.quantity,
//   );
// });

import 'dart:convert';
import 'package:balaji_textile_and_garments/models/cart_item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartNotifier extends StateNotifier<List<CartItemModel>> {
CartNotifier() : super([]) {
_loadCart();
}

/// 🔥 LOAD CART FROM LOCAL STORAGE
Future<void> _loadCart() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString('cart');

  if (data != null) {
    final List decoded = jsonDecode(data);
    state = decoded.map((e) => CartItemModel.fromMap(e)).toList();
  }
}

/// 🔥 SAVE CART TO LOCAL STORAGE
Future<void> _saveCart() async {
  final prefs = await SharedPreferences.getInstance();
  final encoded =
      jsonEncode(state.map((e) => e.toMap()).toList());
  await prefs.setString('cart', encoded);
}

/// 🔥 GET ITEM
CartItemModel? getItem(String productId, String size) {
try {
return state.firstWhere(
(e) => e.productId == productId && e.selectedSize == size,
);
} catch (_) {
return null;
}
}

/// ADD ITEM
void addItem(CartItemModel item) {
final idx = state.indexWhere(
(e) =>
e.productId == item.productId &&
e.selectedSize == item.selectedSize,
);

if (idx >= 0) {
  final existing = state[idx];
  final newQty = existing.quantity + item.quantity;

  if (newQty <= existing.availableStock) {
    state = [
      ...state.sublist(0, idx),
      existing.copyWith(quantity: newQty),
      ...state.sublist(idx + 1),
    ];
  }
} else {
  state = [...state, item];
}

_saveCart(); // 🔥 persist

}

/// REMOVE ITEM
void removeItem(String productId, String size) {
state = state
.where((e) =>
!(e.productId == productId && e.selectedSize == size))
.toList();

_saveCart(); // 🔥 persist

}

/// UPDATE QUANTITY
void updateQuantity(String productId, String size, int qty) {
if (qty <= 0) {
removeItem(productId, size);
return;
}

state = state.map((e) {
  if (e.productId == productId && e.selectedSize == size) {
    return e.copyWith(
      quantity: qty.clamp(1, e.availableStock),
    );
  }
  return e;
}).toList();

_saveCart(); // 🔥 persist


}

/// CLEAR CART
void clearCart() {
state = [];
_saveCart(); // 🔥 persist
}
}

final cartProvider =
StateNotifierProvider<CartNotifier, List<CartItemModel>>(
(ref) => CartNotifier(),
);

/// ================================
/// DERIVED PROVIDERS
/// ================================

final cartSubtotalProvider = Provider<double>((ref) {
final cart = ref.watch(cartProvider);
return cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
});

final cartShippingFeeProvider = Provider<double>((ref) {
final subtotal = ref.watch(cartSubtotalProvider);
return subtotal >= 999 ? 0 : 99;
});

final cartTotalProvider = Provider<double>((ref) {
final subtotal = ref.watch(cartSubtotalProvider);
final shipping = ref.watch(cartShippingFeeProvider);
return subtotal + shipping;
});

final cartItemCountProvider = Provider<int>((ref) {
final cart = ref.watch(cartProvider);
return cart.fold(0, (sum, item) => sum + item.quantity);
});
