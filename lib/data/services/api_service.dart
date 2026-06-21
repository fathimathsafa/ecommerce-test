import 'package:ewire/data/model/product_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://dummyjson.com/products';

  Future<ProductsModel> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        return productsModelFromJson(response.body);
      } else {
        throw Exception('Failed to load products: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network connection error: $e');
    }
  }
}
