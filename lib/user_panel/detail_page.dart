// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_local_variable, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/models/cart_model.dart';
import 'package:farmer_eboard/models/equipment_model.dart';
import 'package:farmer_eboard/user_panel/direct-booking.dart';
import 'package:farmer_eboard/user_panel/feedback_dialog.dart';
import 'package:farmer_eboard/user_panel/feedback_list.dart';
import 'package:farmer_eboard/user_panel/user_controller/rating_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'favourite.dart';

class DetailScreen extends StatefulWidget {
  EquipmentModel equipmentModel;
  DetailScreen({super.key, required this.equipmentModel});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isBooked = false; // Initialize isBooked state

  late CalculateProductRatingController calculateProductRatingController;

  @override
  void initState() {
    super.initState();
    calculateProductRatingController = Get.put(
      CalculateProductRatingController(widget.equipmentModel.equipmentId),
      tag: widget.equipmentModel.equipmentId, // Tag to avoid conflicts
    );
    checkIfBooked(); // Check booking status when screen initializes
  }

  Future<void> checkIfBooked() async {
    final CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('bookings');

    collectionReference.snapshots().listen((snapshot) {
      bool found = false;
      for (var doc in snapshot.docs) {
        List<dynamic> items = doc['items'] as List<dynamic>;
        for (var item in items) {
          if (item['equipmentId'] == widget.equipmentModel.equipmentId) {
            setState(() {
              isBooked = true; // Update isBooked state if equipment is booked
          
            });
            found = true;
            break;
        }
        }
        if (found) break;
      }
    });
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Favourite(equipmentModel: widget.equipmentModel),
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
                      Text(widget.equipmentModel.equipmentName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25.0)),
                             
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.equipmentModel.model,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(calculateProductRatingController.averageRating
                              .toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: 10,),    
                          Container(
                            alignment: Alignment.topLeft,
                            child: RatingBar.builder(
                              glow: false,
                              ignoreGestures: true,
                              initialRating: double.parse(
                                  calculateProductRatingController.averageRating
                                      .toString()),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 25,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.green,
                              ),
                              onRatingUpdate: (value) {},
                            ),
                          ),
                          
                        ],
                      ),
                      Divider(height: 40.0, color: Colors.black),
                      Text(widget.equipmentModel.equipmentDescription),
                      Divider(height: 20.0, color: Colors.black),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                String link =
                                    widget.equipmentModel.link.toString();

                                launchUrl(Uri.parse(link),
                                    mode: LaunchMode.inAppWebView);
                              },
                              child: Text('How to use?')),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
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
                      SizedBox(
                        height: 20.0,
                      ),
                      FeedbackList(widget.equipmentModel.equipmentId),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: CarouselSlider(
                options: CarouselOptions(
                    height: 400.0, autoPlay: true, viewportFraction: 1.0),
                items: widget.equipmentModel.equipmentImages.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () => _showImageDialog(
                            widget.equipmentModel.equipmentImages,
                            widget.equipmentModel.equipmentImages
                                .indexOf(imageUrl)),
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
      bottomNavigationBar: isBooked
          ? Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 10.0,
                bottom: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Equipment Already Booked',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                 
                ],
              ),
            )
          : Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 10.0,
                bottom: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('ADD TO CART'),
                    onPressed: () async {
                      await checkEquipment(email: user!.email.toString());
                    },
                  ),
                  ElevatedButton(
                    child: Text('BOOK NOW'),
                    onPressed: () async {
                      await directBooking(email: user!.email.toString());
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> checkEquipment({
    required String email,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.email)
        .collection('cartorders')
        .doc(widget.equipmentModel.equipmentId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      print('Equipment already exists in your cart');
      Get.snackbar(
        "Already!",
        "Equipment already exists in your cart",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(user!.email).set({
        'email': email,
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
        duration: Duration(seconds: 2),
      );
    }
  }

  Future<void> directBooking({
    required String email,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('directBooking')
        .doc(email)
        .collection('confirmDirectBooking')
        .doc(widget.equipmentModel.equipmentId.toString());

    DocumentSnapshot snapshot = await documentReference.get();
    {
      await FirebaseFirestore.instance
          .collection('directBooking')
          .doc(email)
          .set({
        'email': email,
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
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DirectBooking(cartModel: cartModel, email: email)),
      );
    }
  }

  void _showImageDialog(List<dynamic> images, int initialIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: InteractiveViewer(
            boundaryMargin: EdgeInsets.all(20.0),
            minScale: 1.0,
            maxScale: 2.0,
            child: Image.network(
              images[initialIndex],
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
