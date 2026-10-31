import 'package:dio/dio.dart';
import '../models/app_models.dart';

class ApiServiceProducts {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://dummyjson.com',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  // 1. GET ALL PRODUCTS
  Future<List<Product>> getAllProducts({int limit = 30, int skip = 0}) async {
    final response = await _dio.get('/products', queryParameters: {'limit': limit, 'skip': skip});
    final List list = response.data['products'];
    return list.map((e) => Product.fromJson(e)).toList();
  }

  // 2. GET SINGLE PRODUCT
  Future<Product> getProductById(int id) async {
    final response = await _dio.get('/products/$id');
    return Product.fromJson(response.data);
  }

  // 3. SEARCH PRODUCTS
  Future<List<Product>> searchProducts(String query) async {
    final response = await _dio.get('/products/search', queryParameters: {'q': query});
    final List list = response.data['products'];
    return list.map((e) => Product.fromJson(e)).toList();
  }

  // 4. GET CATEGORY LIST
  Future<List<String>> getCategoryList() async {
    final response = await _dio.get('/products/category-list');
    return (response.data as List).map((e) => e.toString()).toList();
  }

  // 5. GET PRODUCTS BY CATEGORY
  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await _dio.get('/products/category/$category');
    final List list = response.data['products'];
    return list.map((e) => Product.fromJson(e)).toList();
  }
}
