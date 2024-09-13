import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_klontong/bloc/product_event.dart';
import 'package:flutter_klontong/bloc/product_state.dart';
import 'package:flutter_klontong/data/repository.dart';
import 'package:flutter_klontong/utils/logger.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  int currentPage = 1;
  final int pageSize = 10;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      try {
        currentPage = 1;
        final products = await repository.getProducts(currentPage, pageSize);
        if (products.isEmpty) {
          emit(ProductEmpty());
        } else {
          emit(ProductLoaded(
              products: products, hasReachedMax: products.length < pageSize));
        }
      } catch (e) {
        emit(ProductError('Failed to fetch products : $e'));
      }
    });

    on<FetchMoreProducts>((event, emit) async {
      if (state is ProductLoaded) {
        final currentState = state as ProductLoaded;
        if (currentState.hasReachedMax) return; // no more products to fetch

        try {
          currentPage++;
          final moreProducts =
              await repository.getProducts(currentPage, pageSize);
          LoggerService.logInfo(
              "New state emitted with ${currentState.products.length + moreProducts.length} products");
          emit(moreProducts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : ProductLoaded(
                  products: currentState.products + moreProducts,
                  hasReachedMax: moreProducts.length < pageSize));
        } catch (e) {
          emit(ProductError('Failed to load more products'));
        }
      }
    });

    // Add Product
    on<AddProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        await repository.addProduct(event.product);
        emit(ProductAddedSuccess());
      } catch (e) {
        emit(ProductError('Failed to add product'));
      }
    });
    // delete Product
    on<DeleteProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        await repository.deleteProduct(event.idProduct);
        emit(ProductDeletedSuccess());
      } catch (e) {
        emit(ProductError('Failed to add product'));
      }
    });
    // detail Product
    on<DetailProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        final product = await repository.detailProduct(event.idProduct);
        emit(ProductDetailSuccess(product));
      } catch (e) {
        emit(ProductError('Failed to add product'));
      }
    });
  }
}
