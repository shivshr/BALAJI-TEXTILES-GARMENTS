import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BannerManagementScreen extends StatefulWidget {
  const BannerManagementScreen({super.key});

  @override
  State<BannerManagementScreen> createState() =>
      _BannerManagementScreenState();
}

class _BannerManagementScreenState extends State<BannerManagementScreen> {

  /// ADD BANNER USING URL
  void _addBannerUrl() {

    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text("Add Banner URL"),

          content: TextField(
            controller: urlController,
            decoration: const InputDecoration(
              hintText: "Paste banner image URL",
              border: OutlineInputBorder(),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                final url = urlController.text.trim();

                if (url.isEmpty) return;

                try {

                  await FirebaseFirestore.instance
                      .collection("banners")
                      .add({
                    "imageUrl": url,
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Banner added successfully")),
                  );

                } catch (e) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  /// DELETE BANNER
  Future<void> deleteBanner(String id) async {

    await FirebaseFirestore.instance
        .collection("banners")
        .doc(id)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Banner deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Banners"),
      ),

      /// ADD BANNER BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: _addBannerUrl,
        child: const Icon(Icons.add),
      ),

      /// BANNER LIST
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("banners")
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No banners added yet"),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {

              final banner = docs[i];

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                child: ListTile(

                  /// BANNER IMAGE
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      banner['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),

                  title: const Text("Banner"),

                  subtitle: Text(
                    banner['imageUrl'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  /// DELETE BUTTON
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteBanner(banner.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}