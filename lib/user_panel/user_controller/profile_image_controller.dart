// ignore_for_file: file_names, unused_field, unused_local_variable, prefer_const_constructors, avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_string/random_string.dart';

class AddProfileImageController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final RxString imageUrl = RxString('');
  final FirebaseStorage storageRef = FirebaseStorage.instance;

  Future<void> showImagePickerDialog() async {
    PermissionStatus status;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

    if (androidDeviceInfo.version.sdkInt <= 32) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.mediaLibrary.request();
    }

    if (status == PermissionStatus.granted) {
      Get.defaultDialog(
        title: "Choose Image",
        middleText: "Pick an image from the camera or gallery?",
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              seletcImage("camera");
            },
            child: Text('Camera'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              seletcImage("gallery");
            },
            child: Text('Gallery'),
          ),
        ],
      );
    }
    if (status == PermissionStatus.denied) {
      print("Error please allow permission for further usage");
      openAppSettings();
    }
    if (status == PermissionStatus.permanentlyDenied) {
      print("Error please allow permission for further usage");
      openAppSettings();
    }
  }

  Future<void> seletcImage(String type) async {
    XFile? img;
    if (type == 'gallery') {
      try {
        img = await _picker.pickImage(source: ImageSource.gallery);
        update();
      } catch (e) {
        print('Error $e');
      }
    } else {
      img = await _picker.pickImage(source: ImageSource.camera);
      update();
    }

    if (img != null) {
      selectedImage.value = img;
      update();
      print(selectedImage.value!.path);
    }
  }

  void removeImage() {
    selectedImage.value = null;
    update();
  }

  Future<void> uploadImage() async {
    if (selectedImage.value != null) {
      imageUrl.value = await uploadFile(selectedImage.value!);
      update();
    }
  }

  Future<String> uploadFile(XFile _image) async {
  String imageName = randomAlphaNumeric(20);
  TaskSnapshot reference = await storageRef
      .ref()
      .child("ProfilePics")
      .child(imageName)
      .putFile(
        File(imageName),
        SettableMetadata(contentType: 'image/jpeg'),
      );

  return await reference.ref.getDownloadURL();
}
}
