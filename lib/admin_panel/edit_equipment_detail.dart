// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_declarations, use_build_context_synchronously, must_be_immutable, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'dart:typed_data';

import 'package:farmer_eboard/admin_panel/admin_controller/categories_dropdown.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/categories_dropdown_widget.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/detail_updated.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/image_update.dart';
import 'package:farmer_eboard/models/equipment_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

class EditEquipment extends StatefulWidget {
  EquipmentModel equipmentModel;
  EditEquipment({Key? key, required this.equipmentModel}) : super(key: key);

  @override
  State<EditEquipment> createState() => _EditEquipmentState();
}

class _EditEquipmentState extends State<EditEquipment> {
  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());

  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController updatedequipmentName = TextEditingController();
  TextEditingController updateddescription = TextEditingController();
  TextEditingController updatedmodel = TextEditingController();
  TextEditingController updatedrent = TextEditingController();
  //String? updatedvalue;
  String? value;
  List<Uint8List> selectedImagesInBytes = [];
  List<String> imageUrls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Equipment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.equipmentModel.equipmentImages != null &&
                          widget.equipmentModel.equipmentImages.isNotEmpty
                      ? widget.equipmentModel.equipmentImages.map((imageUrl) {
                          return Stack(
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
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10.0,
                                top: 10.0,
                                child: InkWell(
                                  onTap: () async {
                                    EditequipmentController controller =
                                        Get.put(EditequipmentController(
                                            equipmentModel:
                                                widget.equipmentModel));
                                    await controller
                                        .deleteImagesFromStorage(imageUrl);
                                    await controller.deleteImageFromFireStore(
                                        imageUrl,
                                        widget.equipmentModel.equipmentId);
                                    setState(() {
                                    widget.equipmentModel.equipmentImages.remove(imageUrl);
                                  });    
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
                          );
                        }).toList()
                      : [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              width: 300.0,
                              height: 300.0,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: IconButton(
                                onPressed: () async {
                                  await pickImages();
                                  for (var selectedImageInBytes in selectedImagesInBytes) {
                                    var downloadUrl = await uploadImage(selectedImageInBytes);
                                    setState(() {
                                      imageUrls.add(downloadUrl);
                                    });
                                    await updateEquipmentDetail().updateimageUrls(widget.equipmentModel.equipmentId, imageUrls);
                                  }
                                  print('uploaded');
                                },
                                icon: Icon(Icons.add_a_photo),
                                iconSize: 50.0,
                              ),
                            ),
                          ),
                          for (int i = 0; i < selectedImagesInBytes.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Container(
                                width: 300.0,
                                height: 300.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: ClipRRect(
                                  child: Image.memory(
                                    selectedImagesInBytes[i],
                                  ),
                                ),
                              ),
                            ),
                        ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Equipment Name'),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: updatedequipmentName
                      ..text = widget.equipmentModel.equipmentName,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        // hintText: widget.equipmentModel.equipmentName,
                        suffixIcon: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update Equipment Name'),
                                    content: TextField(
                                      controller: updatedequipmentName,
                                      decoration: InputDecoration(
                                        hintText:
                                            widget.equipmentModel.equipmentName,
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
                                          await updateEquipmentDetail()
                                              .updateName(
                                                  widget.equipmentModel
                                                      .equipmentId,
                                                  updatedequipmentName.text)
                                              .then((value) {
                                            print('updated successfully');
                                            Get.snackbar(
                                              "Updated!",
                                              "Updated successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.pop(context);
                                          }).catchError((error) {
                                            print('Error: ${error.toString()}');
                                            String errorMessage =
                                                'An error occurred';
                                            // Display error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(errorMessage),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category'),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                      // controller: widget.equipmentModel.categoryName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: widget.equipmentModel.categoryName,
                          suffixIcon: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update Category'),
                                    content: DropDownCategoriesWiidget(),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await updateEquipmentDetail()
                                              .updatecategoryName(
                                                  widget.equipmentModel
                                                      .equipmentId,
                                                  categoryDropDownController
                                                      .selectedCategoryName
                                                      .toString())
                                              .then((value) {
                                            print('updated successfully');
                                            Get.snackbar(
                                              "Updated!",
                                              "Updated successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.pop(context);
                                          }).catchError((error) {
                                            print('Error: ${error.toString()}');
                                            String errorMessage =
                                                'An error occurred';
                                            // Display error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(errorMessage),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          });
                                        },
                                        child: Text('Update'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit),
                          )))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description'),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    maxLines: 6,
                    controller: updateddescription
                      ..text = widget.equipmentModel.equipmentDescription,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        // hintText: widget.equipmentModel.equipmentDescription,
                        suffixIcon: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update Destription'),
                                    content: TextField(
                                      maxLines: 6,
                                      controller: updateddescription,
                                      decoration: InputDecoration(
                                        hintText: widget.equipmentModel
                                            .equipmentDescription,
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
                                          await updateEquipmentDetail()
                                              .updateDescription(
                                                  widget.equipmentModel
                                                      .equipmentId,
                                                  updateddescription.text)
                                              .then((value) {
                                            print('updated successfully');
                                            Get.snackbar(
                                              "Updated!",
                                              "Updated successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.pop(context);
                                          }).catchError((error) {
                                            print('Error: ${error.toString()}');
                                            String errorMessage =
                                                'An error occurred';
                                            // Display error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(errorMessage),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Equipment Model'),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: updatedmodel
                      ..text = widget.equipmentModel.model,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        // hintText: widget.equipmentModel.model,
                        suffixIcon: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update Model'),
                                    content: TextField(
                                      controller: updatedmodel,
                                      decoration: InputDecoration(
                                        hintText: widget.equipmentModel.model,
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
                                          await updateEquipmentDetail()
                                              .updatedmodel(
                                                  widget.equipmentModel
                                                      .equipmentId,
                                                  updatedmodel.text)
                                              .then((value) {
                                            print('updated successfully');
                                            Get.snackbar(
                                              "Updated!",
                                              "Updated successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.pop(context);
                                          }).catchError((error) {
                                            print('Error: ${error.toString()}');
                                            String errorMessage =
                                                'An error occurred';
                                            // Display error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(errorMessage),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rent Price'),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: updatedrent
                      ..text = widget.equipmentModel.rentPrice,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        // hintText: widget.equipmentModel.rentPrice,
                        suffixIcon: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update Rent Price'),
                                    content: TextField(
                                      controller: updatedrent,
                                      decoration: InputDecoration(
                                        hintText:
                                            widget.equipmentModel.rentPrice,
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
                                          await updateEquipmentDetail()
                                              .updateRent(
                                                  widget.equipmentModel
                                                      .equipmentId,
                                                  updatedrent.text)
                                              .then((value) {
                                            print('updated successfully');
                                            Get.snackbar(
                                              "Updated!",
                                              "Updated successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.pop(context);
                                          }).catchError((error) {
                                            print('Error: ${error.toString()}');
                                            String errorMessage =
                                                'An error occurred';
                                            // Display error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(errorMessage),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
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
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

   Future<void> pickImages() async {
    try {
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );

      if (fileResult != null) {
        setState(() {
          for (var file in fileResult.files) {
            selectedImagesInBytes.add(file.bytes!);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error:$e")));
    }
  }

  Future<String> uploadImage(Uint8List selectedImageInBytes) async {
    try {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('EquipmentPics');
      String imageName = randomAlphaNumeric(20);
      Reference referenceImageToUpload = referenceDirImages.child(imageName);

      final metadata = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask = referenceImageToUpload.putData(selectedImageInBytes, metadata);

      await uploadTask;
      String downloadUrl = await referenceImageToUpload.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return '';
  }
}

