import 'package:flutter_klontong/data/api_provider.dart';

import '../model/product.dart';

class ProductRepository {
  final ApiProvider apiProvider;

  ProductRepository(this.apiProvider);

  Future<List<Product>> getProducts(int page, int limit) {
    return apiProvider.fetchProduct(page, limit);
  }

  Future<void> addProduct(Product product) {
    return apiProvider.addProduct(product);
  }

  Future<void> deleteProduct(int idProduct) {
    return apiProvider.deleteProduct(idProduct);
  }

  Future<Product> detailProduct(int idProduct) {
    return apiProvider.detailProduct(idProduct);
  }
}
