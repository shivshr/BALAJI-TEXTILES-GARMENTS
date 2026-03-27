// class AddressModel {
//   final String name;
//   final String phone;
//   final String addressLine;
//   final String city;
//   final String state;
//   final String pincode;

//   AddressModel({
//     required this.name,
//     required this.phone,
//     required this.addressLine,
//     required this.city,
//     required this.state,
//     required this.pincode,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       "name": name,
//       "phone": phone,
//       "addressLine": addressLine,
//       "city": city,
//       "state": state,
//       "pincode": pincode,
//     };
//   }

//   factory AddressModel.fromJson(Map<String, dynamic> json) {
//     return AddressModel(
//       name: json["name"],
//       phone: json["phone"],
//       addressLine: json["addressLine"],
//       city: json["city"],
//       state: json["state"],
//       pincode: json["pincode"],
//     );
//   }
// }


class AddressModel {
  final String name;
  final String phone;
  final String addressLine;
  final String city;
  final String state;
  final String pincode;

  const AddressModel({
    required this.name,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.pincode,
  });

  /// 🔥 Safe JSON parsing (null-safe + type-safe)
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      name: json["name"]?.toString() ?? '',
      phone: json["phone"]?.toString() ?? '',
      addressLine: json["addressLine"]?.toString() ?? '',
      city: json["city"]?.toString() ?? '',
      state: json["state"]?.toString() ?? '',
      pincode: json["pincode"]?.toString() ?? '',
    );
  }

  /// 🔥 Empty fallback (important for safety)
  factory AddressModel.empty() {
    return const AddressModel(
      name: '',
      phone: '',
      addressLine: '',
      city: '',
      state: '',
      pincode: '',
    );
  }

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
}