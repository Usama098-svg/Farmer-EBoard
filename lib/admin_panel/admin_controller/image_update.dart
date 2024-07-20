// ignore_for_file: file_names, avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/models/equipment_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditequipmentController extends GetxController {
  final EquipmentModel equipmentModel;
  EditequipmentController({
    required this.equipmentModel,
  });
  RxList<String> images = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getRealTimeImages();
  }

  void getRealTimeImages() {
    FirebaseFirestore.instance
        .collection('equipments')
        .doc(equipmentModel.equipmentId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['equipmentImages'] != null) {
          images.value =
              List<String>.from(data['equipmentImages'] as List<dynamic>);
          update();
        }
      }
    });
  }

  //delete images
  Future deleteImagesFromStorage(String imageUrl) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      Reference reference = storage.refFromURL(imageUrl);
      await reference.delete();
      print('deteled');
    } catch (e) {
      print("Error $e");
    }
  }

  //collection
  Future<void> deleteImageFromFireStore(
      String imageUrl, String equipmentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('equipments')
          .doc(equipmentId)
          .update({
        'equipmentImages': FieldValue.arrayRemove([imageUrl])
      });
      update();
      print('image deleted successfully');
      Get.snackbar(
        "Deleted!",
        "Delete successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print("Error $e");
    }
  }
}
