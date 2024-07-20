// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/models/booking_model.dart';
import 'package:farmer_eboard/user_panel/payment_page.dart';
import 'package:farmer_eboard/user_panel/user_controller/generate_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
void PlaceOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerCity, 
  required String customerState, 
  required String zipCode, 
  required String customerCountry,
}) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not logged in');
      return;
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(user.email)
        .collection('cartorders')
        .get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    String bookingId = generateBookingId();
    
    List<BookingModel> bookingList = [];
    double totalEquipmentPrice = 0.0; // Initialize total equipment price

    for (var doc in documents) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        BookingModel bookingModel = BookingModel(
          bookingId: bookingId,
          equipmentId: data['equipmentId'] ?? '',
          categoryId: data['categoryId'] ?? '',
          equipmentName: data['equipmentName'] ?? '',
          categoryName: data['categoryName'] ?? '',
          rentPrice: data['rentPrice'] ?? '',
          equipmentImages: data['equipmentImages'] is List<dynamic> ? data['equipmentImages'] : [data['equipmentImages']],
          model: data['model'] ?? '',
          equipmentDescription: data['equipmentDescription'] ?? '',
          createdAt: DateTime.now(),
          startDate: data['startDate'] ?? '',
          endDate: data['endDate'] ?? '',
          numberOfDays: data['numberOfDays'] ?? '',
          equipmentQuantity: data['equipmentQuantity'] ?? 0,
          equipmentTotalPrice: double.parse(data['equipmentTotalPrice'].toString()),
          customerId: user.uid,
          status: 'Pending', 
          customerName: customerName, 
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerCity: customerCity,
          customerCountry: customerCountry,
          customerState: customerState, 
          zipcode: zipCode,
        );

        bookingList.add(bookingModel);

        // Accumulate total price
        totalEquipmentPrice += bookingModel.equipmentTotalPrice;

        // Delete cart equipment
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(user.email)
            .collection('cartorders')
            .doc(bookingModel.equipmentId.toString())
            .delete()
            .then((value) {
          print('Deleted cart equipment ${bookingModel.equipmentId.toString()}');
        });
      }
    }

    // Save all bookings as a single document
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .set({
          'bookingId': bookingId,
          'customerId': user.uid,
          'customerName': customerName,
          'customerPhone': customerPhone,
          'customerAddress': customerAddress,
          'customerCity': customerCity,
          'customerState': customerState,
          'customerCountry': customerCountry,
          'zipCode': zipCode,
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'items': bookingList.map((item) => item.toMap()).toList(),
        });

    print("Order Confirmed");
    EasyLoading.dismiss();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethod(
          bookingId: bookingId,
          equipmentTotalPrice: totalEquipmentPrice, // Pass the total price
        ),
      ),
    );
  } catch (e) {
    print("Error: $e");
  }
}
