// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_typing_uninitialized_variables, sized_box_for_whitespace, must_be_immutable, unused_local_variable, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/models/cart_model.dart';
import 'package:farmer_eboard/models/equipment_model.dart';
import 'package:farmer_eboard/user_panel/checkout.dart';
import 'package:farmer_eboard/user_panel/feedback_dialog.dart';
import 'package:farmer_eboard/user_panel/feedback_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoriteDetailScreen extends StatefulWidget {
  EquipmentModel equipmentModel;
  FavoriteDetailScreen({
    super.key,
    required this.equipmentModel,
  });

  @override
  State<FavoriteDetailScreen> createState() => _FavoriteDetailScreenState();
}

class _FavoriteDetailScreenState extends State<FavoriteDetailScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(Icons.favorite_sharp),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.green,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 250.0),
                      Text('${widget.equipmentModel.equipmentName}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.equipmentModel.model}',
                            style: TextStyle( fontWeight: FontWeight.bold, fontSize: 15.0),
                          ),
                          Row(
                            children: [
                              Text('Rs '),
                              Text(
                                widget.equipmentModel.rentPrice,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(' Per Day')
                            ],
                          ),
                        ],
                      ),
                      Divider(height: 40.0, color: Colors.black),
                      Text('${widget.equipmentModel.equipmentDescription}'),
                      Divider(height: 20.0, color: Colors.black),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        //  RatingBox(),
                          ElevatedButton(
                              onPressed: () {
                                String link = widget.equipmentModel.link.toString();

                                launchUrl(Uri.parse(link),
                                    mode: LaunchMode.inAppWebView);
                              },
                              child: Text('How to use?')),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'REVIEW',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                         ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: ((context) => FeedbackDialog(
                                        equipmentModel:
                                            widget.equipmentModel)));
                              },
                              child: Text('Send Feedback')),
                        ],
                      ),
                      FeedbackList(widget.equipmentModel.equipmentId),
                      SizedBox(
                        height: 90.0,
                      ),
      
                     // SizedBox(height: 200.0,),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
            padding: const EdgeInsets.all(30.0),
             child: CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                autoPlay: true,
                viewportFraction: 1.0 
              ),
              items: widget.equipmentModel.equipmentImages.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () => _showImageDialog(imageUrl) ,
                      child: Container(
                        width: 400.0,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.fill, 
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text('ADD TO CART'),
                onPressed: () async {
                  await checkEquipment(uid: user!.uid.toString());
                  //  Navigator.push(context, MaterialPageRoute(builder: ((context) => FavouritePage())));
                },
              ),
              ElevatedButton(
                child: Text('BOOK NOW'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => CheckOut())));
                 
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkEquipment({
    required String uid,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uid)
        .collection('cartorders')
        .doc(widget.equipmentModel.equipmentId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      // int currentQuantity = snapshot['equipmentQuantity'];
      // int updatedQuantity = currentQuantity + quantityIncrement;
      // double totalPrice = double.parse(widget.equipmentModel.fullPrice) * updatedQuantity;
      // await documentReference.update({
      //   'equipmentQuantity':updatedQuantity,
      //   'equipmentTotalPrice':totalPrice,
      // });
      print('Equipment already exists in your cart');
      Get.snackbar(
        "Already!",
        "Equipment already exists in your cart",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(user!.uid).set({
        'email': user!.email,
        'createdAt': DateTime.now(),
      });
      CartModel cartModel = CartModel(
        equipmentId: widget.equipmentModel.equipmentId,
        equipmentName: widget.equipmentModel.equipmentName,
        categoryName: widget.equipmentModel.categoryName,
        rentPrice: widget.equipmentModel.rentPrice,
        equipmentImages: widget.equipmentModel.equipmentImages,
        model: widget.equipmentModel.model,
        equipmentDescription: widget.equipmentModel.equipmentDescription,
        createdAt: DateTime.now(),
        startDate: '',
        endDate: '',
        numberOfDays: 0,
        equipmentQuantity: 1,
        equipmentTotalPrice: double.parse(widget.equipmentModel.rentPrice),
      );

      await documentReference.set(cartModel.toMap());
      print('Equipment added in your cart');
      Get.snackbar(
        "Added!",
        "Equipment added in your cart",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    }
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              imageUrl, // Replace 'assets/logo.jpg' with your actual image path
              fit: BoxFit.fill,
              height: 400.0,
              width: 500.0,
            ),
          ),
        );
      },
    );
  }
}
