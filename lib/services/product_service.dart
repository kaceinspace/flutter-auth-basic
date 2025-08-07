import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xii_rpl_3/models/product_model.dart';

class ProductService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/products';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<Product>> fetchProducts() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List).map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<Product> showProduct(int id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data['data']);
    } else {
      throw Exception('Failed to load product');
    }
  }

  static Future<bool> createProduct(
    String name,
    String description,
    double price,
    Uint8List imageBytes,
    String imageName,
  ) async {
    final token = await _getToken();
    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri);

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: imageName,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();

    return response.statusCode == 201;
  }

  static Future<bool> updateProduct(
    int id,
    String name,
    String description,
    double price, [
    Uint8List? imageBytes,
    String? imageName,
  ]) async {
    final token = await _getToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/$id?_method=PUT'),
    );

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();

    if (imageBytes != null && imageName != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();
    return response.statusCode == 200;
  }

  static Future<bool> deleteProduct(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}
