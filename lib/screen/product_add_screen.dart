import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_klontong/bloc/product_bloc.dart';
import 'package:flutter_klontong/bloc/product_event.dart';
import 'package:flutter_klontong/bloc/product_state.dart';
import 'package:flutter_klontong/model/product.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});

  @override
  _ProductAddScreenState createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _weightController = TextEditingController();
  final _widthController = TextEditingController();
  final _lengthController = TextEditingController();
  final _heightController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: 84,
        categoryId: 14, // Set your category logic here
        categoryName: 'Cemilan', // Replace with actual category
        sku: 'MHZVTK',
        name: _nameController.text,
        description: _descriptionController.text,
        weight: int.parse(_weightController.text),
        width: int.parse(_widthController.text),
        length: int.parse(_lengthController.text),
        height: int.parse(_heightController.text),
        image:
            'https://cf.shopee.co.id/file/7cb930d1bd183a435f4fb3e5cc4a896b', // Image URL
        price: int.parse(_priceController.text),
      );

      // Dispatch the AddProduct event
      BlocProvider.of<ProductBloc>(context).add(AddProduct(product));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            title: const Text('Add Product')),
        body: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductAddedSuccess) {
              showMessage(context, 'Success add product');
              Navigator.pop(context);
            } else if (state is ProductError) {
              showMessage(context, 'Failed to add product');
            }
          },
          child: addProductForm(),
        ));
  }

  addProductForm() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextFormField(_nameController,
                    'Please enter a product name', 'Product Name'),
                const SizedBox(
                  height: 12,
                ),
                _buildTextFormField(_descriptionController,
                    'Please enter a description', 'Description'),
                const SizedBox(
                  height: 12,
                ),
                _buildTextNumberFormField(
                    _priceController, 'Please enter a price', 'Price'),
                const SizedBox(
                  height: 12,
                ),
                _buildTextNumberFormField(
                    _weightController, 'Please enter weight product', 'Weight'),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: _buildTextNumberFormField(_widthController,
                          'Please enter width product', 'Width'),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: _buildTextNumberFormField(_lengthController,
                          'Please enter lenght product', 'Length'),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: _buildTextNumberFormField(_heightController,
                          'Please enter height product', 'Height'),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(45)),
                    onPressed: () {
                      _submitForm();
                    },
                    child: Text('Add Product')),
              ],
            )));
  }

  _buildTextFormField(
      TextEditingController controller, String errorMessage, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }

  _buildTextNumberFormField(
      TextEditingController controller, String errorMessage, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }

  showMessage(context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
