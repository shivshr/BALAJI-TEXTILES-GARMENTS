import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/address_provider.dart';
import '../../models/address_model.dart';

class DeliveryAddressesScreen extends ConsumerWidget {
  const DeliveryAddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Addresses"),
      ),
      floatingActionButton: addresses.length < 4
          ? FloatingActionButton(
              onPressed: () {
                _showAddAddressDialog(context, ref);
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: addresses.isEmpty
          ? const Center(
              child: Text(
                "No delivery addresses yet.\nTap + to add one.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];

                return ListTile(
                  title: Text(address.name),
                  subtitle: Text(
                      "${address.addressLine}, ${address.city}, ${address.state} - ${address.pincode}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditAddressDialog(context, ref, index, address);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ref.read(addressProvider.notifier).removeAddress(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _showAddAddressDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Add Address"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
                TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
                TextField(controller: addressController, decoration: const InputDecoration(labelText: "Address")),
                TextField(controller: cityController, decoration: const InputDecoration(labelText: "City")),
                TextField(controller: stateController, decoration: const InputDecoration(labelText: "State")),
                TextField(controller: pinController, decoration: const InputDecoration(labelText: "Pincode")),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(addressProvider.notifier).addAddress(
                      AddressModel(
                        name: nameController.text,
                        phone: phoneController.text,
                        addressLine: addressController.text,
                        city: cityController.text,
                        state: stateController.text,
                        pincode: pinController.text,
                      ),
                    );

                Navigator.pop(dialogContext);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showEditAddressDialog(
      BuildContext context,
      WidgetRef ref,
      int index,
      AddressModel address) {

    final nameController = TextEditingController(text: address.name);
    final phoneController = TextEditingController(text: address.phone);
    final addressController = TextEditingController(text: address.addressLine);
    final cityController = TextEditingController(text: address.city);
    final stateController = TextEditingController(text: address.state);
    final pinController = TextEditingController(text: address.pincode);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Edit Address"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
                TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
                TextField(controller: addressController, decoration: const InputDecoration(labelText: "Address")),
                TextField(controller: cityController, decoration: const InputDecoration(labelText: "City")),
                TextField(controller: stateController, decoration: const InputDecoration(labelText: "State")),
                TextField(controller: pinController, decoration: const InputDecoration(labelText: "Pincode")),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(addressProvider.notifier).editAddress(
                      index,
                      AddressModel(
                        name: nameController.text,
                        phone: phoneController.text,
                        addressLine: addressController.text,
                        city: cityController.text,
                        state: stateController.text,
                        pincode: pinController.text,
                      ),
                    );

                Navigator.pop(dialogContext);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}