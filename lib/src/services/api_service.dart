// lib/src/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/category.dart'; // Import the Category model

class ApiService {
  // static const String _baseUrl = 'https://skysaint.woosonicpwa.com/api/products/all';
  static const String _categoriesUrl =
      'https://salesucre.woosonicpwa.com/api/shopCategories/all?lang=en';

  Future<List<Product>> fetchProducts(
      {String? categorySlug, String lang = 'en'}) async {
    final String url = 'https://skysaint.woosonicpwa.com/api/products/all';
    final Uri uri = Uri.parse(url).replace(queryParameters: {
      'lang': lang,
      'conditions[in_stock]': '1',
      if (categorySlug != null)
        'conditions[categories][]':
            categorySlug, // Add category filter if provided
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final dynamic decodedData = json.decode(response.body);

      if (decodedData is List<dynamic>) {
        return decodedData.map((json) => Product.fromJson(json)).toList();
      } else if (decodedData is Map<String, dynamic> &&
          decodedData['data'] is List<dynamic>) {
        return decodedData['data']
            .map((json) => Product.fromJson(json))
            .toList();
      } else {
        throw Exception('Invalid API Response');
      }
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(_categoriesUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
