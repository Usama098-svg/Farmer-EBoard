// ignore_for_file: file_names, unnecessary_overrides, unused_local_variable, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

User? user = FirebaseAuth.instance.currentUser;
class EquipmentPriceController extends GetxController {
  RxDouble totalPrice = 0.0.obs;
  @override
  void onInit() {
    fetchequipmentPrice();
    super.onInit();
  }

  void fetchequipmentPrice() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('cart')
        .doc(user!.email)
        .collection('cartorders')
        .get();

    double sum = 0.0;

    if (snapshot.docs.isNotEmpty) {
      for (final doc in snapshot.docs) {
        final data = doc.data();
        if (data != null && data.containsKey('equipmentTotalPrice')) {
          sum += (data['equipmentTotalPrice'] as num).toDouble();
        }
      }
    }
    totalPrice.value = sum.toDouble();
    
     if (totalPrice.value.toDouble() == 0.0) {
    totalPrice.value = 0.0;
  }
  }
}