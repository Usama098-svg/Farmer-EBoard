// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:farmer_eboard/admin_panel/admin_controller/all_count.dart';
import 'package:farmer_eboard/admin_panel/admin_drawer.dart';
import 'package:farmer_eboard/admin_panel/all_booking.dart';
import 'package:farmer_eboard/admin_panel/all_cancel_booking.dart';
import 'package:farmer_eboard/admin_panel/all_delivered_booking.dart';
import 'package:farmer_eboard/admin_panel/all_panding_booking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {

final BookingLengthController _bookingLengthController = Get.put(BookingLengthController());
final CancelledBookingLengthController _cancelledbookingLengthController = Get.put(CancelledBookingLengthController());
final PendingBookingLengthController _pendingBookingLengthController = Get.put(PendingBookingLengthController());
final DeliveredBookingLengthController _deliveredBookingLengthController = Get.put(DeliveredBookingLengthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                Icon(Icons.person),
                Text('Admin'),
              ],
            ),
          )
        ],
      ),
     // drawer: AdminDrawerWidget(),
      body: Container(
        child: Row(
          children: [
            Expanded(flex: 2, child: AdminDrawerWidget(selectedItemIndex: -1)),
            Expanded(
                flex: 6,
                child: Container(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 200,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(15.0)),
                                
                                child: Center(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Total Booking', style: TextStyle(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.bold ),),
                                    Obx(() {return Text(_bookingLengthController.bookingCollectionLength.toString(), style: TextStyle(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.bold ));}),
                                    SizedBox(height: 50,),
                                    ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: ((context) => AllBooking())));}, style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                      foregroundColor:Colors.green,
                                    ),child: Text('View')),
                                  ],
                                )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 200,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(15.0)),
                                child: Center(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Pending', style: TextStyle(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.bold ),),
                                    Obx(() {return Text(_pendingBookingLengthController.pendingBookingCollectionLength.toString(), style: TextStyle(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.bold ));}),
                                    SizedBox(height: 50,),
                                    ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: ((context) => AllPandingBooking())));}, style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                      foregroundColor:Colors.green,
                                    ),child: Text('View')),
                                  ],
                                )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 200,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(15.0)),
                                child: Center(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Delivered', style: TextStyle(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.bold ),),
                                    Obx(() {return Text(_deliveredBookingLengthController.deliveredBookingCollectionLength.toString(), style: TextStyle(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.bold ));}),
                                    SizedBox(height: 50,),
                                    ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: ((context) => AllDeliveredBooking())));}, style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                      foregroundColor:Colors.green,
                                    ),child: Text('View')),
                                  ],
                                )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 200,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(15.0)),
                                child: Center(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Cancelled', style: TextStyle(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.bold ),),
                                    Obx(() {return Text(_cancelledbookingLengthController.cancelledBookingCollectionLength.toString(), style: TextStyle(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.bold ));}),
                                    SizedBox(height: 50,),
                                    ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: ((context) => AllCancelBooking())));}, style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                      foregroundColor:Colors.green,
                                    ),child: Text('View')),
                                  ],
                                )),
                              ),
                            ),
                          
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
