import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address_model.dart';

class AddressNotifier extends StateNotifier<List<AddressModel>> {
  AddressNotifier() : super([]) {
    loadAddresses();
  }

  static const storageKey = "saved_addresses";

  Future<void> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(storageKey);

    if (data != null) {
      state = data
          .map((e) => AddressModel.fromJson(jsonDecode(e)))
          .toList();
    }
  }

  Future<void> saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        state.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList(storageKey, encoded);
  }

  void addAddress(AddressModel address) {
    if (state.length >= 4) return;

    state = [...state, address];
    saveAddresses();
  }

  void removeAddress(int index) {
    final updated = [...state];
    updated.removeAt(index);
    state = updated;
    saveAddresses();
  }

  void editAddress(int index, AddressModel updatedAddress) {
    final updated = [...state];
    updated[index] = updatedAddress;
    state = updated;
    saveAddresses();
  }
}

final addressProvider =
    StateNotifierProvider<AddressNotifier, List<AddressModel>>(
  (ref) => AddressNotifier(),
);