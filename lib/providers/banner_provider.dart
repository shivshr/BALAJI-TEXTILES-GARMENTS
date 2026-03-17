import 'package:flutter/material.dart';
import '../models/banner_model.dart';
import '../services/banner_service.dart';

class BannerProvider extends ChangeNotifier {

  List<BannerModel> banners = [];

  Future<void> loadBanners() async {
    banners = await BannerService().getBanners();
    notifyListeners();
  }
}