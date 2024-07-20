// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_const_constructors_in_immutables, use_build_context_synchronously, must_be_immutable, no_leading_underscores_for_local_identifiers

//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/user_panel/categories.dart';
import 'package:farmer_eboard/user_panel/user_controller/cart_price_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethod extends StatefulWidget {
  String bookingId;
  double equipmentTotalPrice;
  PaymentMethod({super.key, required this.bookingId, required this.equipmentTotalPrice});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  User? user = FirebaseAuth.instance.currentUser;
  
  final EquipmentPriceController equipmentPriceController =
      Get.put(EquipmentPriceController());
  @override
  Widget build(BuildContext context) {
    double totalrent = widget.equipmentTotalPrice + 500.00;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.green,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Text(
                    "Payment Method",
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            Positioned(
                top: 150.0,
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(45.0),
                          topLeft: Radius.circular(45.0))),
                   child:Padding(
                     padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                     child: Column(
                      children: [
                        SizedBox(height: 50.0,),
                        GestureDetector(
                          onTap: () {
                            showCustomBottomSheet(method: 'Easypaisa');
                          },
                          child: Container(
                            height: 50.0,
                            width: size.width,
                            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text("Easypaisa", style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Image.asset("assets/Easypaisa.jpg")
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0,),
                        GestureDetector(
                          onTap: () {
                            showCustomBottomSheet(method: 'Jazzcash');
                          },
                          child: Container(
                            height: 50.0,
                            width: size.width,
                            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:10.0),
                                  child: Text("Jazzcash", style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Image.asset("assets/jazzcash.jpg")
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0,),
                        GestureDetector(
                          onTap: () {
                            showCustomBottomSheet(method: 'Bank');
                          },
                          child: Container(
                            height: 50.0,
                            width: size.width,
                            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:10.0),
                                  child: Text("Bank", style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Image.asset("assets/bank.png")
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0,),
                        GestureDetector(
                          onTap: () {
                            showCustomBottomSheet2(method: 'Cash on Delivery');
                          },
                          child: Container(
                            height: 50.0,
                            width: size.width,
                            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text("Cash on Delivery", style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Image.asset("assets/cash.jpg")
                              ],
                            ),
                          
                          ),
                        )
                      ],
                     ),
                   )    
                ))
                
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Subtotal Rent'),
                      Text(widget.equipmentTotalPrice.toStringAsFixed(2))
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Delivery'),
                      Text('500.00'),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Total Rent'), 
                      Text(totalrent.toStringAsFixed(2)),
                     
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // Container(
                  //     height: 45,
                  //     width: 300,
                  //     child: ElevatedButton(
                  //       child: Text('CHECK OUT'),
                  //       onPressed: (){
                  //         if()
                  //       //  Navigator.push(context, MaterialPageRoute(builder: ((context) => CheckOut())));
                  //      _showPaymentSuccessDialog();
                  //       }),),
                ],
              ),
            ),
          ),
        ));
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Booking Comfirm"),
          content: Text("Your payment has been successfully processed."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  "Order Confirmed",
                  "Thank you for your booking!",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: Duration(seconds: 2),
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => CategoriesPage())));
              },
              child: Text("OK"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  TextEditingController mobile = TextEditingController();
  TextEditingController holder = TextEditingController();
  TextEditingController amount = TextEditingController();
  void showCustomBottomSheet({required String method}) {
    final _formKey = GlobalKey<FormState>(); // Key for the Form

    Get.bottomSheet(
      Container(
        height: Get.height * 1.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            // Wrap the contents with a Form widget
            key: _formKey, // Assign the key to the Form
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                  child: TextFormField(
                    controller: mobile,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: 'Account Number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your number';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextFormField(
                    controller: holder,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: 'Holder`s Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter holder name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextFormField(
                    controller: amount,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: 'Amount',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 30.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10.0,
                        backgroundImage: AssetImage('assets/tick.png'),
                      ),
                      SizedBox(width: 10.0),
                      Text('Save Card Information'),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //  backgroundColor: AppConstant.appMainColor,
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(widget.bookingId); // Validate the form
                      await FirebaseFirestore.instance
                          .collection('bookings')
                          //  .doc(user!.uid)
                          //  .collection('confirmBookings')
                          .doc(widget.bookingId)
                          //  .where('bookingId', isEqualTo: widget.bookingId )

                          .update({
                        'Holder`s Name': holder.text,
                        'Account No': mobile.text,
                        'Amount': amount.text,
                        'Payment Method': method
                      }).then((value) => _showPaymentSuccessDialog());
                      //  await sendEmail(
                      //             recipientEmail: user!.email,
                      //             subject: 'Equipment Booking Proceeded',
                      //             body: 'Hello Dear Farmer \n I want to inform you about this Equipment \n Equipment Name : ${equipmentModel.equipmentName} \n Equipment Catergory : ${equipmentModel.categoryName} \n Rent Par Day : ${equipmentModel.rentPrice}',
                      //           );

                      // Display a snackbar or navigate to a new screen
                      // Get.snackbar(
                      //   "Order Confirmed",
                      //   "Thank you for your booking!",
                      //   backgroundColor: Colors.green,
                      //   colorText: Colors.white,
                      //   duration: Duration(seconds: 5),
                      // );
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: ((context) => CategoriesPage())));
                    }
                  },
                  child: Text(
                    "Place Booking",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6.0,
    );
  }

  void showCustomBottomSheet2({required String method}) {
    Get.bottomSheet(
      Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              print(widget.bookingId);
              await FirebaseFirestore.instance
                  .collection('bookings')
                  //  .doc(user!.uid)
                  //  .collection('confirmBookings')
                  .doc(widget.bookingId)
                  .update({
                'Holder`s Name': '',
                'Account No': '',
                'Amount': '',
                'Payment Method': method
              }).then((value) => _showPaymentSuccessDialog());

              // Display a snackbar or navigate to a new screen
              // Get.snackbar(
              //   "Order Confirmed",
              //   "Thank you for your booking!",
              //   backgroundColor: Colors.green,
              //   colorText: Colors.white,
              //   duration: Duration(seconds: 5),
              // );
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: ((context) => CategoriesPage())));
            },
            child: Text(
              "Place Booking",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6.0,
    );
  }
}
