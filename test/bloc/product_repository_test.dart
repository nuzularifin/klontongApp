import 'package:flutter_klontong/data/repository.dart';
import 'package:flutter_klontong/model/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_klontong/data/api_provider.dart';

import 'product_repository_test.mocks.dart';

@GenerateMocks([ApiProvider])
void main() {
  late MockApiProvider mockApiProvider;
  late ProductRepository productRepository;

  setUp(() {
    mockApiProvider = MockApiProvider();
    productRepository = ProductRepository(mockApiProvider);
  });

  group('FetchProducts', () {
    final List<Product> products = [
      Product(
        id: 1,
        name: 'Test Product 1',
        description: 'Description 1',
        price: 100,
        categoryName: 'Category 1',
        categoryId: 14,
        sku: 'MVXTW',
        weight: 5,
        width: 10,
        length: 10,
        height: 10,
        image: 'https://google.com/',
      ),
      Product(
          id: 2,
          name: 'Test Product 2',
          description: 'Description 2',
          price: 200,
          categoryName: 'Category 2',
          categoryId: 14,
          sku: 'MVXTW',
          weight: 5,
          width: 10,
          length: 10,
          height: 10,
          image: 'https://google.com/'),
    ];
    test('should return a list of products when fetchproduct return a list',
        () async {
      when(mockApiProvider.fetchProduct(1, 10))
          .thenAnswer((_) async => products);
      // act
      final result = await productRepository.getProducts(1, 10);
      // assert
      expect(result, isNotNull);
      expect(result, hasLength(products.length));
      for (int i = 0; i < products.length; i++) {
        expect(result[i], equals(products[i]));
      }
      verify(mockApiProvider.fetchProduct(1, 10)).called(1);
    });
  });
}
