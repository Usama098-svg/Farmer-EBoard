// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_build_context_synchronously

import 'package:farmer_eboard/admin_panel/admin_drawer.dart';
import 'package:farmer_eboard/admin_panel/confirm_booking_detail.dart';
import 'package:farmer_eboard/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/all_count.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllBooking extends StatefulWidget {
  const AllBooking({super.key});

  @override
  State<AllBooking> createState() => _AllBookingState();
}

class _AllBookingState extends State<AllBooking> {
  final BookingLengthController _bookingLengthController =
      Get.put(BookingLengthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(
              'Bookings (${_bookingLengthController.bookingCollectionLength.toString()})');
        }),
      ),
      body: Row(
        children: [
          Expanded(flex: 2, child: AdminDrawerWidget(selectedItemIndex: 2)),
          Expanded(
            flex: 6,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                      child: Text('Error occurred while fetching booking!'),
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
                      child: Text('No booking found!'),
                    ),
                  );
                }

                if (snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index];
                      final bookingDataMap =
                          data.data() as Map<String, dynamic>;
                      List<dynamic> items = bookingDataMap['items'];
                      if(items.isNotEmpty){
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Card(
                          elevation: 5.0,
                          child: ExpansionTile(
                            title: Text(
                                "Booking ID: ${bookingDataMap['bookingId']}"),
                            subtitle: Text(
                              "Customer Name: ${bookingDataMap['customerName'] ?? 'Unknown'}",
                            ),
                            children: items.map((item) {
                              BookingModel bookingModel = BookingModel(
                                bookingId: bookingDataMap['bookingId'] ?? '',
                                equipmentId: item['equipmentId'] ?? '',
                                categoryId: item['categoryId'] ?? '',
                                equipmentName: item['equipmentName'] ?? '',
                                categoryName: item['categoryName'] ?? '',
                                rentPrice: item['rentPrice'] ?? '',
                                equipmentImages: List<String>.from(
                                    item['equipmentImages'] ?? []),
                                model: item['model'] ?? '',
                                equipmentDescription:
                                    item['equipmentDescription'] ?? '',
                                createdAt: item['createdAt'],
                                startDate: item['startDate'] ?? '',
                                endDate: item['endDate'] ?? '',
                                numberOfDays: item['numberOfDays'] ?? '',
                                equipmentQuantity:
                                    item['equipmentQuantity'] ?? '',
                                equipmentTotalPrice: double.parse(
                                    item['equipmentTotalPrice'].toString()),
                                customerId: bookingDataMap['customerId'] ?? '',
                                status: item['status'] ?? '',
                                customerName:
                                    bookingDataMap['customerName'] ?? '',
                                customerPhone:
                                    bookingDataMap['customerPhone'] ?? '',
                                customerAddress:
                                    bookingDataMap['customerAddress'] ?? '',
                                customerCity:
                                    bookingDataMap['customerCity'] ?? '',
                                customerCountry:
                                    bookingDataMap['customerCountry'] ?? '',
                                customerState:
                                    bookingDataMap['customerState'] ?? '',
                                zipcode: bookingDataMap['zipcode'] ?? '',
                              );

                              DateTime createdAt =
                                  bookingModel.createdAt.toDate();
                              String formattedDate =
                                  DateFormat('MMMM d, y ' 'At' ' h:mm:ss a')
                                      .format(createdAt);

                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ConfirmBookingDetail(
                                        docId: data.id,
                                        bookingModel: bookingModel,
                                        method:
                                            data['Payment Method'].toString(),
                                        amount: data['Amount'].toString(),
                                        holder:
                                            data['Holder`s Name'].toString(),
                                        account: data['Account No'].toString(),
                                      ),
                                    ),
                                  );
                                },
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: bookingModel.equipmentImages.isNotEmpty
                                      ? Image.network(
                                          bookingModel.equipmentImages[0],height: 100.0, width: 50.0,)
                                      : Icon(Icons.image_not_supported),
                                ),
                                title: Text(bookingModel.equipmentName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Price: ${bookingModel.equipmentTotalPrice}"),
                                    Text("Date: $formattedDate"),
                                    Text(
                                      "Status: ${bookingModel.status}",
                                      style: TextStyle(
                                        color: bookingModel.status ==
                                                'Cancelled'
                                            ? Colors.red
                                            : bookingModel.status == 'Delivered'
                                                ? Colors.green
                                                : Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        showBottomSheet(
                                          docId: data.id,
                                          item: item,
                                          items: items,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
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
                                                  try {
                                                    // Find the index of the item in the items list
                                                    int itemIndex = items.indexWhere((element) => element == item);

                                                    if (itemIndex != -1) {
                                                      // Remove the item from the items list
                                                      items.removeAt(itemIndex);

                                                      if (items.isEmpty) {
                                                        // If no items are left, delete the entire document
                                                        await FirebaseFirestore.instance
                                                            .collection('bookings')
                                                            .doc(bookingModel.bookingId)
                                                            .delete();

                                                        print('Booking document deleted successfully');
                                                        Get.snackbar(
                                                          "Deleted!",
                                                          "Booking deleted successfully",
                                                          backgroundColor: Colors.green,
                                                          colorText: Colors.white,
                                                          duration: Duration(seconds: 2),
                                                        );
                                                      } else {
                                                        // If there are still items left, update the Firestore document with the new items list
                                                        await FirebaseFirestore.instance
                                                            .collection('bookings')
                                                            .doc(bookingModel.bookingId)
                                                            .update({'items': items});

                                                        print('Booking item deleted successfully');
                                                        Get.snackbar(
                                                          "Deleted!",
                                                          "Booking deleted successfully",
                                                          backgroundColor: Colors.green,
                                                          colorText: Colors.white,
                                                          duration: Duration(seconds: 2),
                                                        );
                                                      }

                                                      Navigator.pop(context);
                                                    }
                                                  } catch (e) {
                                                    print("Error $e");
                                                  }
                                                },
                                                child: Text('Yes'),
                                              ),

                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                    else {
                        return SizedBox.shrink();
                     // return null;
                    }
                    
                });
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  void showBottomSheet({
    required String docId,
    required Map<String, dynamic> item,
    required List<dynamic> items,
  }) {
    Get.bottomSheet(
      Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await updateBookingStatus(docId, item, items, 'Pending');
                },
                child: Text('Pending'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await updateBookingStatus(docId, item, items, 'Delivered');
                },
                child: Text('Delivered'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await updateBookingStatus(docId, item, items, 'Cancelled');
                },
                child: Text('Cancelled'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateBookingStatus(String docId, Map<String, dynamic> item,
      List<dynamic> items, String status) async {
    List<dynamic> updatedItems = List.from(items);
    int itemIndex = updatedItems.indexOf(item);
    updatedItems[itemIndex]['status'] = status;

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(docId)
        .update({'items': updatedItems}).then((value) {
      print(status);
      Get.snackbar(
        status,
        "Status changed to $status",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      Navigator.pop(context);
    });
  }
}
