import 'dart:convert';
import 'package:http/http.dart' as http;

class PincodeService {
  static Future<Map<String, String>?> getLocation(String pincode) async {
    try {
      final res = await http.get(
        Uri.parse('https://api.postalpincode.in/pincode/$pincode'),
      );

      final data = jsonDecode(res.body);

      if (data[0]['Status'] == 'Success') {
        final postOffice = data[0]['PostOffice'][0];

        return {
          'city': postOffice['District'],
          'state': postOffice['State'],
        };
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}