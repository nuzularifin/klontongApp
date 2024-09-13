import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_klontong/bloc/product_bloc.dart';
import 'package:flutter_klontong/bloc/product_event.dart';
import 'package:flutter_klontong/bloc/product_state.dart';
import 'package:flutter_klontong/model/product.dart';
import 'package:flutter_klontong/utils/screen_size_config.dart';

class ProductDetailScreen extends StatefulWidget {
  final int idProduct;
  const ProductDetailScreen({Key? key, required this.idProduct})
      : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(DetailProduct(idProduct: widget.idProduct));

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
        actions: [
          IconButton(
              onPressed: () {
                showAlertDialog(
                    context,
                    'Are you sure want to delete this product ?',
                    widget.idProduct);
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductDetailSuccess) {
            return _buildBody(state.product);
          } else if (state is ProductDeletedSuccess) {
            Navigator.pop(context);
            return const SizedBox();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Product Not Found'),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      _retry(context);
                    },
                    child: const Text('Retry'))
              ],
            ),
          );
        },
      ),
    );
  }

  _retry(context) {
    BlocProvider.of<ProductBloc>(context)
        .add(DetailProduct(idProduct: widget.idProduct));
  }

  _deleteProduct(int idProduct) {
    BlocProvider.of<ProductBloc>(context)
        .add(DeleteProduct(idProduct: idProduct));
  }

  _buildBody(Product product) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Center(
            child: Image.network(
              product.image,
              height: ScreenSizeConfig().screenHeight * 0.3,
              width: ScreenSizeConfig().screenWidth,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          // Product name
          Text(
            product.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          // Product description
          Text(
            product.description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          _boldTextView('Price'),
          const SizedBox(height: 4),
          _normalTextView('${product.price} IDR'),
          const SizedBox(height: 12),
          _boldTextView('SKU'),
          const SizedBox(height: 4),
          _normalTextView(product.sku),
          const SizedBox(height: 12),
          _boldTextView('Weight'),
          const SizedBox(height: 4),
          _normalTextView(product.weight.toString()),
          const SizedBox(height: 12),
          _boldTextView('Dimensions'),
          const SizedBox(height: 4),
          _normalTextView(
              "${product.width} x ${product.length} x ${product.height} cm"),
          const SizedBox(height: 12),
          _boldTextView('Category'),
          const SizedBox(height: 4),
          _normalTextView(product.categoryName),
        ],
      ),
    );
  }

  _boldTextView(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  _normalTextView(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    );
  }

  Future<bool> showAlertDialog(
      BuildContext context, String message, int idProduct) async {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        // returnValue = false;
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Continue"),
      onPressed: () {
        // returnValue = true;
        _deleteProduct(idProduct);
        Navigator.of(context).pop(true);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Do you want to continue?"),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    final result = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return result ?? false;
  }
}
