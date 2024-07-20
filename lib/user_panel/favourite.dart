// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/models/equipment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Favourite extends StatefulWidget {
  final EquipmentModel equipmentModel;
  const Favourite({super.key, required this.equipmentModel});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  User? user = FirebaseAuth.instance.currentUser;

  int rating = 0;

  //  void setRatingAsOne()
  @override
  Widget build(BuildContext context) {
    // double size = 20;
    print(rating);
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(0.0),
          child: IconButton(
              icon: (rating >= 1
                  ? Icon(
                      Icons.favorite,
                    )
                  : Icon(
                      Icons.favorite_border,
                    )),
              color: Colors.white,
              onPressed: () async {
                //setRatingAsOne(),
                await favouriteEquipment(uid: user!.uid.toString());
              }),
        ),
      ],
    );
  }

  Future<void> favouriteEquipment({
    required String uid,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
    .collection('favourite')
    .doc(uid)
    .collection('myfavourite')
    .doc(widget.equipmentModel.equipmentId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      print('Equipment already exists in your favourite');
      Get.snackbar(
        "Favourite already!",
        "Equipment already exists in your favourit",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } else {
      await documentReference.set(widget.equipmentModel.toMap());
      print('Equipment added in your favourite');
      Get.snackbar(
        "Favourite!",
        "Equipment added in your favourite",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }
}
