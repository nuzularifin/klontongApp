import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_klontong/utils/logging_interceptor.dart';
import '../model/product.dart';
import '../utils/logger.dart';

class ApiProvider {
  final Dio _dio = Dio();
  // final String _baseUrl = 'https://crudcrud.com/api/${dotenv.env['API_KEY']}';
  final String _baseUrl = 'https://ca3d5ce7159c03e78961.free.beeceptor.com/api';
  final String _dummyJsonResponse =
      'https://run.mocky.io/v3/c89be899-f89f-4ad6-bc26-87406e4cb1da';
  final String _dummyDetailResponse =
      'https://run.mocky.io/v3/f92e72c7-31ad-4337-9210-798ac4233fc8';

  // ApiProvider() {
  //   // Add logging interceptor for request and response
  //   _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
  //     LoggerService.logInfo('Sending request to : ${options.uri}');
  //     LoggerService.logInfo('Post : ${options.data}');
  //     return handler.next(options);
  //   }, onResponse: (response, handler) {
  //     LoggerService.logInfo(
  //         'Response: ${response.statusCode} - ${response.data}');
  //     return handler.next(response);
  //   }, onError: (DioException e, handler) {
  //     LoggerService.logError(
  //         'API Error: ${e.response?.statusCode} - ${e.message}');
  //     return handler.next(e);
  //   }));
  // }

  ApiProvider() {
    _dio.interceptors.add(LoggingInterceptor());
  }

  Future<List<Product>> fetchProduct(int page, int limit) async {
    try {
      final response = await _dio.get(_dummyJsonResponse,
          queryParameters: {'page': page, 'limit': limit});
      final List products = response.data;
      return products.map((product) => Product.fromJson(product)).toList();
    } catch (e) {
      LoggerService.logError('Error fetching products: $e');
      throw Exception('Failed to fetch product');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response =
          await _dio.post('$_baseUrl/products', data: product.toJson());
      LoggerService.logInfo('Product added successfully: ${response.data}');
    } catch (e) {
      LoggerService.logError('Error adding product: $e');
      throw Exception('Failed to add product');
    }
  }

  Future<void> deleteProduct(int idProduct) async {
    try {
      final response = await _dio.delete('$_baseUrl/products/$idProduct');
      LoggerService.logInfo('Product deleted successfully ${response.data}');
    } catch (e) {
      LoggerService.logError('Error deleting product: $e');
      throw Exception('Failed to delete product');
    }
  }

  Future<Product> detailProduct(int idProduct) async {
    try {
      final response = await _dio.get('$_dummyDetailResponse');
      LoggerService.logInfo('Product detail success ${response.data}');
      final Product productData = Product.fromJson(response.data);
      return productData;
    } catch (e) {
      LoggerService.logError('Error get detail product: $e');
      throw Exception('Failed to get detail product');
    }
  }
}
