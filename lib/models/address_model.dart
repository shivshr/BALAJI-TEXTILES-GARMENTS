class AddressModel {
  final String name;
  final String phone;
  final String addressLine;
  final String city;
  final String state;
  final String pincode;

  AddressModel({
    required this.name,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.pincode,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "addressLine": addressLine,
      "city": city,
      "state": state,
      "pincode": pincode,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      name: json["name"],
      phone: json["phone"],
      addressLine: json["addressLine"],
      city: json["city"],
      state: json["state"],
      pincode: json["pincode"],
    );
  }
}