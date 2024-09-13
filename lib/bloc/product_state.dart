import 'package:equatable/equatable.dart';
import 'package:flutter_klontong/model/product.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;

  ProductLoaded({
    required this.products,
    required this.hasReachedMax,
  });

  ProductLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        {products, hasReachedMax}
      ];
}

class ProductEmpty extends ProductState {}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductAddedSuccess extends ProductState {}

class ProductDeletedSuccess extends ProductState {}

class ProductDetailSuccess extends ProductState {
  final Product product;

  ProductDetailSuccess(this.product);

  @override
  List<Object?> get props => [product];
}
