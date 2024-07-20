// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:farmer_eboard/admin_panel/admin_drawer.dart';
import 'package:farmer_eboard/admin_panel/confirm_booking_detail.dart';
import 'package:farmer_eboard/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/all_count.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllPandingBooking extends StatefulWidget {
  const AllPandingBooking({super.key});

  @override
  State<AllPandingBooking> createState() => _AllPandingBookingState();
}

class _AllPandingBookingState extends State<AllPandingBooking> {
  final PendingBookingLengthController _pendingbookingLengthController = Get.put(PendingBookingLengthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Obx(() {
          return Text('Pending Bookings (${_pendingbookingLengthController.pendingBookingCollectionLength.toString()})');
        }),
      ),
      body: Row(
        children: [
          Expanded(
              flex: 2,
              child: AdminDrawerWidget(selectedItemIndex: 2)),
          Expanded(
            flex: 6,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                //  .where('status', isEqualTo: 'Delivered')
                  .snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                      child: Text(
                          'Error occurred while fetching delivered booking!'),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Container(
                    child: Center(
                      child: Text('No delivered booking found!'),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index];
                    List<dynamic> items = data['items'];
                    return Column(
                      children: items.map<Widget>((item) {
                        if (item['status'] == 'Pending') {
                          BookingModel bookingModel = BookingModel(
                            bookingId: data['bookingId'],
                            equipmentId: item['equipmentId'],
                            categoryId: item['categoryId'],
                            equipmentName: item['equipmentName'],
                            categoryName: item['categoryName'],
                            rentPrice: item['rentPrice'],
                            equipmentImages: item['equipmentImages'],
                            model: item['model'],
                            equipmentDescription:
                                item['equipmentDescription'],
                            createdAt: item['createdAt'],
                            startDate: item['startDate'],
                            endDate: item['endDate'],
                            numberOfDays: item['numberOfDays'],
                            equipmentQuantity: item['equipmentQuantity'],
                            equipmentTotalPrice:
                                item['equipmentTotalPrice'],
                            customerId: item['customerId'],
                            status: item['status'],
                            customerName: item['customerName'],
                            customerPhone: item['customerPhone'],
                            customerAddress: item['customerAddress'],
                            customerCity: item['customerCity'],
                            customerCountry: item['customerCountry'],
                            customerState: item['customerState'],
                            zipcode: item['zipcode'],
                          );
                          DateTime createdOn = item['createdAt'].toDate();
                          String formattedDate =
                              DateFormat('MMMM d, y ' 'At' ' h:mm:ss a')
                                  .format(createdOn);
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0),
                            child: Card(
                              elevation: 5.0,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          ConfirmBookingDetail(
                                            docId: snapshot.data!.docs[index].id,
                                            bookingModel: bookingModel,
                                            method: snapshot.data!.docs[index]
                                                .get('Payment Method')
                                                .toString(),
                                            amount: snapshot.data!.docs[index]
                                                .get('Amount')
                                                .toString(),
                                            holder: snapshot.data!.docs[index]
                                                .get('Holder`s Name')
                                                .toString(),
                                            account: snapshot.data!.docs[index]
                                                .get('Account No')
                                                .toString(),
                                          )),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Text(data['customerName'][0]),
                                ),
                                title: Text('Booking Id : ${data['bookingId']}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Customer Name : ${data['customerName']}'),
                                    Text('Phone : ${data['customerPhone']}'),
                                    Text('Date : $formattedDate'),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: (() {
                                        showBottomSheet(
                                          docId: data['bookingId'],
                                        );
                                      }),
                                      icon: Icon(Icons.more_vert),
                                    ),
                                    IconButton(
                                      onPressed: (() async {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Delete!'),
                                              content: Text(
                                                  'Are you sure you want to delete?'),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('No'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('bookings')
                                                        .doc(data['bookingId'][index])
                                                        .delete()
                                                        .then((value) {
                                                      print(
                                                          'Deleted successfully');
                                                      Get.snackbar(
                                                        "Deleted!",
                                                        "Booking deleted successfully",
                                                        backgroundColor:
                                                            Colors.green,
                                                        colorText: Colors.white,
                                                        duration:
                                                            Duration(seconds: 2),
                                                      );
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Text('Yes'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }),
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showBottomSheet({
  //  required String userDocId,
  //  required BookingModel bookingModel,
    required String docId, 
  }) {
    Get.bottomSheet(
      Container(
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('bookings')
                        //  .doc(userDocId)
                        //  .collection('confirmBookings')
                          .doc(docId)
                          .update(
                        {
                          'status': 'Pending',
                        },
                      ).then((value) {
                        print('Pending');
                         Get.snackbar(
                              "Pending!",
                              "Status changed to pending",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                        );
                        Navigator.pop(context);
                      });
                    },
                    child: Text('Pending'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('bookings')
                          //  .doc(userDocId)
                          //  .collection('confirmBookings')
                            .doc(docId)
                            .update(
                          {
                            'status': 'Delivered',
                          },
                        ).then((value) {
                        print('Delivered');
                         Get.snackbar(
                              "Delivered!",
                              "Status changed to delivered",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                        );
                        Navigator.pop(context);
                      });
                      },
                      child: Text('Delivered')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('bookings')
                          //  .doc(userDocId)
                          //  .collection('confirmBookings')
                            .doc(docId)
                            .update(
                          {
                            'status': 'Cancelled',
                          },
                        ).then((value) {
                        print('Cancelled');
                         Get.snackbar(
                              "Cancelled!",
                              "Status changed to cancelled",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                        );
                        Navigator.pop(context);
                      });
                      },
                      child: Text('Cancelled')),
                )
              ],
            )
          ],
        ),
      ),
    );
}
}