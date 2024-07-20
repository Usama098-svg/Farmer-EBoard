// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_declarations, deprecated_member_use

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/categories_dropdown.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/categories_dropdown_widget.dart';
import 'package:farmer_eboard/models/equipment_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:url_launcher/url_launcher.dart';

class AddEquipment extends StatefulWidget {
  const AddEquipment({Key? key}) : super(key: key);

  @override
  State<AddEquipment> createState() => _AddEquipmentState();
}

class _AddEquipmentState extends State<AddEquipment> {
  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());

  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController equipmentName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController model = TextEditingController();
  TextEditingController link = TextEditingController();
  TextEditingController rent = TextEditingController();
  String? value;
  List<Uint8List> selectedImagesInBytes = [];
  List<String> imageUrls = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Equipment'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: equipmentName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintText: 'Equipment Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the equipment name';
                    }
                    return null;
                  },
                ),
              ),
              DropDownCategoriesWiidget(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  maxLines: 6,
                  controller: description,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintText: 'Equipment Description',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the equipment description';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: model,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintText: 'Equipment model',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the model';
                    }
                    return null;
                  },
                ),
              ),
               Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: link,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintText: 'Link',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the link';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: rent,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintText: 'Rent Per Day',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the rent per day';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          for (var selectedImageInBytes in selectedImagesInBytes) {
                            
                            var downloadUrl = await uploadImage(selectedImageInBytes);
                            imageUrls.add(downloadUrl);
                          }
                          String docId = randomAlphaNumeric(20);
                          EquipmentModel equipmentModel = EquipmentModel(
                            equipmentId: docId,
                            equipmentName: equipmentName.text,
                            categoryName: categoryDropDownController.selectedCategoryName.toString(),
                            rentPrice: rent.text,
                            equipmentImages: imageUrls,
                            model: model.text,
                            link: link.text, 
                            equipmentDescription: description.text,
                            createdAt: DateTime.now(),
                          );

                          await FirebaseFirestore.instance.collection('equipments').doc(docId).set(equipmentModel.toMap()).then((value) {
                            print('Added successfully ');
                            Get.snackbar(
                              "Added!",
                              "Equipment added successfully",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: Duration(seconds: 5),
                            );
                            Navigator.pop(context);
                          });
                            // await sendMessageOnWhatsApp( equipmentModel: equipmentModel);
                            //   await sendEmail(
                            //       recipientEmail: 'uahmed098@gmail.com',
                            //       subject: 'New Equipment Added',
                            //       body: 'Hello Dear Farmer \n I want to inform you about this Equipment \n Equipment Name : ${equipmentModel.equipmentName} \n Equipment Catergory : ${equipmentModel.categoryName} \n Rent Par Day : ${equipmentModel.rentPrice}',
                            //     );
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
              ),
            ],
          ),
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

//Send message on whatsapp

 Future<void> sendMessageOnWhatsApp({
    required EquipmentModel equipmentModel,
  }) async {
    final number = "+923107673323";
    final message =
        "Hello Dear Farmer \n I want to inform you about this Equipment \n Equipment Name : ${equipmentModel.equipmentName} \n Equipment Catergory : ${equipmentModel.categoryName} \n Rent Par Day : ${equipmentModel.rentPrice}";

    final url = 'https://wa.me/$number?text=${Uri.encodeComponent(message)}';

     try {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    } catch (e) {
    print('Error launching WhatsApp: $e');
  }
  }


//Send message on mail

  Future<void> sendEmail({
  required String recipientEmail,
  required String subject,
  required String body,
}) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: recipientEmail,
    queryParameters: {
      'subject': subject,
      'body': body,
    },
  );

  try {
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch email';
    }
  } catch (e) {
    print('Error launching email: $e');
  }
} 
}