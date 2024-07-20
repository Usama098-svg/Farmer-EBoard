// ignore_for_file: file_names, unused_field, body_might_complete_normally_nullable, unused_local_variable, camel_case_types, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
 // final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //for password visibilty
 // var isPasswordVisible = false.obs;

  Future<UserCredential?> signInMethod(
      String userEmail, String userPassword) async {
    try {
      EasyLoading.show(status: "Please wait");
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText:Colors.white,
      );
    }
  }

}

class updateUserInfo{
 Future updateName(String id, String name) async{
 return await
 FirebaseFirestore.instance
 .collection('users')
 .doc(id)
 .update({'username': name});
 }

  Future updatePhone(String id, String phone) async{
 return await
 FirebaseFirestore.instance
 .collection('users')
 .doc(id)
 .update({'phone': phone});
 }

  Future updateAddress(String id, String address) async{
 return await
 FirebaseFirestore.instance
 .collection('users')
 .doc(id)
 .update({'userAddress': address});
 }

  Future updateCity(String id, String city) async{
 return await
 FirebaseFirestore.instance
 .collection('users')
 .doc(id)
 .update({'city': city});
 }

  Future updateCountry(String id, String country) async{
 return await
 FirebaseFirestore.instance
 .collection('users')
 .doc(id)
 .update({'country': country});
 }

 Future updateProfilePic(String id, String userImg) async{
 return await
 FirebaseFirestore.instance
 .collection('users')
 .doc(id)
 .update({'userImg': userImg.toString()});
 }
}
