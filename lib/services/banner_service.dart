import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/banner_model.dart';

class BannerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<BannerModel>> getBanners() async {
    final snapshot = await _firestore.collection('banners').get();

    return snapshot.docs.map((doc) {
      return BannerModel.fromFirestore(doc.data(), doc.id);
    }).toList();
  }
}