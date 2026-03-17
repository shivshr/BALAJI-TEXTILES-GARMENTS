class BannerModel {
  final String id;
  final String imageUrl;

  BannerModel({
    required this.id,
    required this.imageUrl,
  });

  factory BannerModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BannerModel(
      id: id,
      imageUrl: data['imageUrl'],
    );
  }
}