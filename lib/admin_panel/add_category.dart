// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/admin_panel/admin_drawer.dart';
import 'package:farmer_eboard/models/category_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key,});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController categoryName = TextEditingController();
  String? _imageFile; // Variable to hold the selected image file
  Uint8List? selectedImageInBytes;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Category'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: AdminDrawerWidget(selectedItemIndex:4)),
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.0,),
                    Stack(
                          children: [
                            _imageFile != null
                                ? Container(
                                    width: 300.0,
                                    height: 300.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.memory(selectedImageInBytes!),
                                    ),
                                  )
                                : Container(
                                    width: 300.0,
                                    height: 300.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Icon(Icons.photo, size: 200.0, color: Colors.grey),
                                    ),
                                  ),
                            Positioned(
                              top: 10.0,
                              left: 10.0,
                              child: CircleAvatar(
                                child: IconButton(
                                  onPressed: () async {
                                    await pickImage();
                                  },
                                  icon: Icon(Icons.add_a_photo),
                                ),
                              ),
                            )
                          ],
                        ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0 , bottom: 20.0 , right: 20.0 , left: 20.0),
                      child: TextFormField(
                        controller: categoryName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: 'Category Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the category name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String docId = randomAlphaNumeric(20);
                              var downloadUrl = await uploadImage(selectedImageInBytes!);
                              CategoriesModel categoriesModel = CategoriesModel(
                                categoryId: docId,
                                categoryImg: downloadUrl,
                                categoryName: categoryName.text,
                                createdAt: DateTime.now(),
                              );
            
                              await FirebaseFirestore.instance
                                  .collection('categories')
                                  .doc(docId)
                                  .set(categoriesModel.toMap())
                                  .then((value) {
                                print('Added successfully ');
                                 Get.snackbar(
                                      "Added!",
                                      "Category added successfully",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      duration: Duration(seconds: 2),
                                );
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Text('Add'),
                        ),
                         ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            )
                      ],
                      
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 Future<void> pickImage() async {
    try {
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (fileResult != null) {
        setState(() {
          _imageFile = fileResult.files.first.name;
          selectedImageInBytes = fileResult.files.first.bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error:$e")));
    }
  }

  Future<String> uploadImage(Uint8List selectedImageInBytes) async {
  try {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('CategoriesPics');
    String imageName = randomAlphaNumeric(20);
    Reference referenceImageToUpload = referenceDirImages.child(imageName);

    final metadata = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask = referenceImageToUpload.putData(selectedImageInBytes, metadata);

    await uploadTask;
    // .whenComplete(() => ScaffoldMessenger.of(context)
    //     .showSnackBar(const SnackBar(content: Text("Image Uploaded"))));
    String downloadUrl = await referenceImageToUpload.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  }
  return '';
}
}