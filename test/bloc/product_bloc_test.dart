import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_klontong/bloc/product_bloc.dart';
import 'package:flutter_klontong/bloc/product_event.dart';
import 'package:flutter_klontong/bloc/product_state.dart';
import 'package:flutter_klontong/data/repository.dart';
import 'package:flutter_klontong/model/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductBloc productBloc;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    productBloc = ProductBloc(mockProductRepository);
  });

  blocTest<ProductBloc, ProductState>(
    'emits [ProductLoading, ProductLoaded] when products are successfully fetched.',
    build: () {
      when(mockProductRepository.getProducts(1, 10))
          .thenAnswer((_) async => <Product>[]);
      return productBloc;
    },
    act: (bloc) => bloc.add(FetchProducts()),
    expect: () => [
      ProductLoading(),
      ProductLoaded(products: List.empty(), hasReachedMax: true)
    ],
  );
}
