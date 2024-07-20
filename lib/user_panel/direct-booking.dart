// ignore_for_file: prefer_const_constructors, must_be_immutable, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/models/cart_model.dart';
import 'package:farmer_eboard/user_panel/checkout2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DirectBooking extends StatefulWidget {
  CartModel cartModel;
  String email;
  DirectBooking({super.key, required this.cartModel, required this.email});

  @override
  State<DirectBooking> createState() => _DirectBookingState();
}

class _DirectBookingState extends State<DirectBooking> {
  String? startDate = '';
  String? endDate = '';
  int? numberOfDays = 0;

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
      appBar: AppBar(
        title: Text(widget.cartModel.equipmentName),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Card(
          elevation: 5.0,
          child: Container(
            height: 150.0,
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage:
                    NetworkImage(widget.cartModel.equipmentImages[0]),
                backgroundColor: Colors.white,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Text(widget.cartModel.equipmentName),
                      Text(' (${widget.cartModel.equipmentQuantity})'),
                    ],
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    'RS.${widget.cartModel.rentPrice} PERDAY',
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(height: 3.0),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text((double.parse(widget.cartModel.rentPrice) *
                                  numberOfDays!)
                              .toString()),
                          Text(' ($numberOfDays Days)'),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (widget.cartModel.equipmentQuantity > 1) {
                                setState(() {
                                  widget.cartModel.equipmentQuantity -= 1;
                                });
                                await FirebaseFirestore.instance
                                    .collection('directBooking')
                                    .doc(widget.email)
                                    .collection('confirmDirectBooking')
                                    .doc(widget.cartModel.equipmentId)
                                    .update({
                                  'equipmentQuantity':
                                      widget.cartModel.equipmentQuantity,
                                });
                              }
                            },
                            child: CircleAvatar(
                              radius: 10.0,
                              child: Text('-'),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Text(widget.cartModel.equipmentQuantity.toString()),
                          SizedBox(width: 10.0),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                widget.cartModel.equipmentQuantity += 1;
                              });
                              await FirebaseFirestore.instance
                                  .collection('directBooking')
                                  .doc(widget.email)
                                  .collection('confirmDirectBooking')
                                  .doc(widget.cartModel.equipmentId)
                                  .update({
                                'equipmentQuantity':
                                    widget.cartModel.equipmentQuantity,
                              });
                            },
                            child: CircleAvatar(
                              radius: 10.0,
                              child: Text('+'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await getCurrent(context).then(
                                (value) => print(
                                    'Start: $startDate\nEnd: $endDate\nDays: $numberOfDays'),
                              );
                              await FirebaseFirestore.instance
                                  .collection('directBooking')
                                  .doc(widget.email)
                                  .collection('confirmDirectBooking')
                                  .doc(widget.cartModel.equipmentId)
                                  .update({
                                'startDate': startDate,
                                'endDate': endDate,
                                'numberOfDays': numberOfDays,
                                'equipmentTotalPrice':
                                    (double.parse(widget.cartModel.rentPrice) *
                                            numberOfDays!)
                                        .toString()
                              });
                            },
                            icon: Icon(Icons.calendar_month),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              '$startDate To $endDate',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 3.0),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
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
                    Text((double.parse(widget.cartModel.rentPrice) *
                            numberOfDays!)
                        .toStringAsFixed(2)),
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
                    Text(((double.parse(widget.cartModel.rentPrice) *
                                numberOfDays!) +
                            500.00)
                        .toStringAsFixed(2)),
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
                        MaterialPageRoute(builder: (context) => CheckOut2()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
