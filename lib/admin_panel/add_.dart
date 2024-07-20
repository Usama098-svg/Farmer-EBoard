// ignore_for_file: prefer_const_constructors, deprecated_member_use, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class Product {
  final String name;
  final double price;
  final File image;

  Product({required this.name, required this.price, required this.image});
}


class AdminProducts extends StatefulWidget {
  const AdminProducts({super.key});

  @override
  _AdminProductsState createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  File? imageFile;

  List<Product> products = [];

  void _addProduct() {
    if (nameController.text.isEmpty || priceController.text.isEmpty || imageFile == null) {
      return;
    }

    setState(() {
      products.add(Product(
        name: nameController.text,
        price: double.parse(priceController.text),
        image: imageFile!,
      ));
    });

    // Clear form fields after adding product
    nameController.clear();
    priceController.clear();
    setState(() {
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10.0),
            imageFile != null ? Image.file(imageFile!) : Container(),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                setState(() {
                  imageFile = File(pickedFile!.path);
                });
              },
              child: Text('Select Image'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.file(products[index].image),
                    title: Text(products[index].name),
                    subtitle: Text('\$${products[index].price}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
