import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodService {
  static const String apiKey = '18ZMl1KKgqd5pKbXhohy4SCs3Ri0FJb2PPo6pgbv';

  static Future<List<dynamic>> searchFood(String query) async {
    final url = Uri.parse(
      'https://api.nal.usda.gov/fdc/v1/foods/search?query=$query&api_key=18ZMl1KKgqd5pKbXhohy4SCs3Ri0FJb2PPo6pgbv'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['foods'];
    } else {
      throw Exception('Failed to load foods');
    }
  }

  static Future<dynamic> searchByBarcode(String barcode) async {
    final url =
        "https://world.openfoodfacts.org/api/v0/product/$barcode.json";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 1) {
        return data['product'];
      }
    }

    return null;
  }
}

