import '../model/product.dart';

abstract class ProductEvent {}

class FetchProducts extends ProductEvent {}

class FetchMoreProducts extends ProductEvent {}

class AddProduct extends ProductEvent {
  final Product product;

  AddProduct(this.product);
}

class DeleteProduct extends ProductEvent {
  final int idProduct;

  DeleteProduct({required this.idProduct});
}

class DetailProduct extends ProductEvent {
  final int idProduct;

  DetailProduct({required this.idProduct});
}
