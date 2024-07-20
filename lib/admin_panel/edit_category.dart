// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_build_context_synchronously, unnecessary_null_comparison, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:farmer_eboard/models/category_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

class EditCategory extends StatefulWidget {
  CategoriesModel categoriesModel;
  EditCategory({super.key, required this.categoriesModel});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  TextEditingController UpdateCategoyName = TextEditingController();
  Uint8List? selectedImageInBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Category'),
      ),
      body: Column(
        children: [
          widget.categoriesModel.categoryImg != null &&
                  widget.categoriesModel.categoryImg.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 300.0,
                        height: 300.0,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(
                            widget.categoriesModel.categoryImg,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10.0,
                        top: 10.0,
                        child: InkWell(
                          onTap: () async {
                            await deleteImage();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Stack(
                    children: [
                      Container(
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
                          child: selectedImageInBytes != null
                              ? Image.memory(selectedImageInBytes!)
                              : Icon(Icons.photo,
                                  size: 200.0, color: Colors.grey),
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
                ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category Name'),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: UpdateCategoyName
                    ..text = widget.categoriesModel.categoryName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Update Category Name'),
                                  content: TextField(
                                    controller: UpdateCategoyName,
                                    decoration: InputDecoration(
                                      hintText:
                                          widget.categoriesModel.categoryName,
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('categories')
                                            .doc(widget
                                                .categoriesModel.categoryId)
                                            .update({
                                          'categoryName': UpdateCategoyName.text
                                        }).then((value) {
                                          print('Updated successfully');
                                          Get.snackbar(
                                            "Updated!",
                                            "Updated successfully",
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            duration: Duration(seconds: 2),
                                          );
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text('Update'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//Delete category image
  Future<void> deleteImage() async {
    try {
      // Delete the image from Firebase Storage
      await FirebaseStorage.instance
          .refFromURL(widget.categoriesModel.categoryImg)
          .delete();

      // Update the Firestore document to remove the image URL
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoriesModel.categoryId)
          .update({
        'categoryImg': '',
      });

      Get.snackbar(
        "Deleted!",
        "Image deleted successfully",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete image",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

  Future<void> pickImage() async {
    try {
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (fileResult != null) {
        setState(() {
          selectedImageInBytes = fileResult.files.first.bytes;
        });
        String downloadUrl = await uploadImage(selectedImageInBytes!);
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(widget.categoriesModel.categoryId)
            .update({
          'categoryImg': downloadUrl,
        });
        // setState(() {
        //   widget.categoriesModel.categoryImg = downloadUrl;
        // });
      }
      Get.snackbar(
        "Updated!",
        "Image updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<String> uploadImage(Uint8List selectedImageInBytes) async {
    try {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('CategoriesPics');
      String imageName = randomAlphaNumeric(20);
      Reference referenceImageToUpload = referenceDirImages.child(imageName);

      final metadata = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask =
          referenceImageToUpload.putData(selectedImageInBytes, metadata);

      await uploadTask;
      String downloadUrl = await referenceImageToUpload.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return '';
  }
}
