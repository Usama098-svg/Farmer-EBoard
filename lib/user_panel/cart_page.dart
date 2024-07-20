// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/models/cart_model.dart';
import 'package:farmer_eboard/user_panel/checkout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'user_controller/cart_price_controller.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  String? startDate;
  String? endDate;
  int? numberOfDays;
  User? user = FirebaseAuth.instance.currentUser;
  final EquipmentPriceController equipmentPriceController =
      Get.put(EquipmentPriceController());

  Future<void> getCurrent(BuildContext context) async {
    final DateTimeRange? dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
    );
    if (dateRange != null) {
      setState(() {
        startDate = DateFormat("dd-MM-yyyy").format(dateRange.start);
        endDate = DateFormat("dd-MM-yyyy").format(dateRange.end);
        numberOfDays = dateRange.end.difference(dateRange.start).inDays + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Cart'),
            Text('Delete'),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.email)
            .collection('cartorders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("Cart is empty...!"),
            );
          }

          if (snapshot.data != null) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final equipmentData = snapshot.data!.docs[index];
                      CartModel cartModel = CartModel(
                        equipmentId: equipmentData['equipmentId'],
                        equipmentName: equipmentData['equipmentName'],
                        categoryName: equipmentData['categoryName'],
                        rentPrice: equipmentData['rentPrice'],
                        equipmentImages: equipmentData['equipmentImages'],
                        model: equipmentData['model'],
                        equipmentDescription: equipmentData['equipmentDescription'],
                        createdAt: equipmentData['createdAt'],
                        startDate: equipmentData['startDate'],
                        endDate: equipmentData['endDate'],
                        equipmentQuantity: equipmentData['equipmentQuantity'],
                        equipmentTotalPrice: equipmentData['equipmentTotalPrice'],
                        numberOfDays: equipmentData['numberOfDays'],
                      );
                      equipmentPriceController.fetchequipmentPrice();
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(cartModel.equipmentImages[0]),
                              backgroundColor: Colors.white,
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Delete!'),
                                      content: Text('Are you sure you want to delete?'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('cart')
                                                .doc(user!.email)
                                                .collection('cartorders')
                                                .doc(cartModel.equipmentId)
                                                .delete();
                                            print('deleted...');
                                            Get.snackbar(
                                              "Deleted!",
                                              "Equipment deleted successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.delete),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Text(cartModel.equipmentName),
                                    Text(' (${cartModel.equipmentQuantity})'),
                                  ],
                                ),
                                SizedBox(height: 3.0),
                                Text(
                                  'RS.${cartModel.rentPrice} PERDAY',
                                  style: TextStyle(color: Colors.green),
                                ),
                                SizedBox(height: 3.0),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(cartModel.equipmentTotalPrice.toString()),
                                        Text(' (${cartModel.numberOfDays} Days)'),
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (cartModel.equipmentQuantity > 1) {
                                              await FirebaseFirestore.instance
                                                  .collection('cart')
                                                  .doc(user!.email)
                                                  .collection('cartorders')
                                                  .doc(cartModel.equipmentId)
                                                  .update({
                                                'equipmentQuantity': cartModel.equipmentQuantity - 1,
                                              });
                                            }
                                          },
                                          child: CircleAvatar(
                                            radius: 10.0,
                                            child: Text('-'),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Text(cartModel.equipmentQuantity.toString()),
                                        SizedBox(width: 10.0),
                                        GestureDetector(
                                          onTap: () async {
                                            await FirebaseFirestore.instance
                                                .collection('cart')
                                                .doc(user!.email)
                                                .collection('cartorders')
                                                .doc(cartModel.equipmentId)
                                                .update({
                                              'equipmentQuantity': cartModel.equipmentQuantity + 1,
                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: 10.0,
                                            child: Text('+'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.0),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await getCurrent(context).then(
                                          (value) => print('Start: $startDate\nEnd: $endDate\nDays: $numberOfDays'),
                                        );
                                        await FirebaseFirestore.instance
                                            .collection('cart')
                                            .doc(user!.email)
                                            .collection('cartorders')
                                            .doc(cartModel.equipmentId)
                                            .update({
                                          'startDate': startDate,
                                          'endDate': endDate,
                                          'numberOfDays': numberOfDays,
                                        //  'equipmentQuantity': cartModel.equipmentQuantity,
                                          'equipmentTotalPrice':
                                              (double.parse(cartModel.rentPrice) * numberOfDays! * cartModel.equipmentQuantity.toDouble()),
                                        });
                                      },
                                      icon: Icon(Icons.calendar_month),
                                    ),
                                    SizedBox(width: 10.0),
                                    Expanded(child: Text('${cartModel.startDate} To ${cartModel.endDate}')),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                              Obx(() => Text(' ${equipmentPriceController.totalPrice.value.toStringAsFixed(2)}')),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Delivery'),
                              Text('500.00'),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Total Rent'),
                              Obx(() {
                                double totalRent = equipmentPriceController.totalPrice.value + 500.00;
                                return Text(totalRent.toStringAsFixed(2));
                              }),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            height: 45.0,
                            width: 300.0,
                            child: ElevatedButton(
                              child: Text('CHECK OUT'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CheckOut()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }
}
