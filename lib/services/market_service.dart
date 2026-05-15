import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketService {
  static const String _apiKey = '4ef6b0d1a609c9faac4c16011b60cba2a4c2c467b4d560c1a79c8778357445b5';

  static Future<Map<String, dynamic>> getPrices() async {
    final url = Uri.parse('https://www.goldapi.io/api/XAU/USD');

    final response = await http.get(
      url,
      headers: {
        'x-access-token': _apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      double pricePerOunce = data['price'];
      double pricePerGram = pricePerOunce / 31.1035;

      return {
        'oro_usd': pricePerGram,
        'oro_pen': pricePerGram * 3.7,
        'timestamp': data['timestamp'],
      };
    } else {
      throw Exception('Error obteniendo datos');
    }
  }
}