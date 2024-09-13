import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_klontong/injection_container.dart';
import 'package:flutter_klontong/screen/product_add_screen.dart';
import 'package:flutter_klontong/screen/product_detail_screen.dart';
import 'package:flutter_klontong/utils/logger.dart';

import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedProduct = -1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ProductBloc>().add(FetchProducts());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    LoggerService.logInfo('isBottom = $_isBottom');
    if (_isBottom) {
      context.read<ProductBloc>().add(FetchMoreProducts());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    LoggerService.logInfo(
        'maxScroll: $maxScroll, currentScroll: $currentScroll');
    return maxScroll == 0 || currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
              onPressed: () {
                openAddProduct(context);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final products = state.products;
            if (!state.hasReachedMax) {
              context.read<ProductBloc>().add(FetchMoreProducts());
            }

            return ListView.builder(
              shrinkWrap: false,
              itemCount:
                  state.hasReachedMax ? products.length : products.length + 1,
              itemBuilder: (context, index) {
                if (index >= products.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final product = products[index];
                return ListTile(
                  onTap: () {
                    _selectedProduct = index;
                    setState(() {
                      LoggerService.logInfo(
                          'selected product id : $_selectedProduct');
                    });
                    openDetailProduct(context, state.products[index].id);
                  },
                  title: Text(product.name),
                  subtitle: Text(product.description),
                  leading: Image.network(product.image,
                      width: 50, height: 50, fit: BoxFit.cover),
                );
              },
            );
          } else if (state is ProductEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                      child: Text(
                    'Empty Product',
                    textAlign: TextAlign.center,
                  )),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(FetchProducts());
                    },
                    child: const Text('Retry'),
                  ),
                )
              ],
            );
          } else if (state is ProductError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                  )),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(FetchProducts());
                    },
                    child: const Text('Retry'),
                  ),
                )
              ],
            );
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<ProductBloc>(context).add(FetchProducts());
              },
              child: const Text('Load Products'),
            ),
          );
        },
      ),
    );
  }
}

void openDetailProduct(context, selectedProductId) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ProductBloc(sl()),
                child: ProductDetailScreen(idProduct: selectedProductId),
              )));
}

void openAddProduct(context) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ProductBloc(sl()),
                child: const ProductAddScreen(),
              )));
}
