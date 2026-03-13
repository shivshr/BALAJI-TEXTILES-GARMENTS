import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

final locationProvider = FutureProvider<String>((ref) async {

  // 1️⃣ Check if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    throw Exception("Location services are disabled.");
  }

  // 2️⃣ Check current permission
  LocationPermission permission = await Geolocator.checkPermission();

  // 3️⃣ Request permission if denied
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  // 4️⃣ If still denied
  if (permission == LocationPermission.denied) {
    throw Exception("Location permission denied");
  }

  // 5️⃣ If permanently denied
  if (permission == LocationPermission.deniedForever) {
    throw Exception(
        "Location permissions permanently denied. Enable from settings.");
  }

  // 6️⃣ Fetch address
  return await LocationService.getFullAddress();
});