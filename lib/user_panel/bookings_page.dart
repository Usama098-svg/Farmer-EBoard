// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/models/booking_model.dart';
import 'package:farmer_eboard/user_panel/booking_detail.dart';
import 'package:farmer_eboard/user_panel/user_controller/cart_price_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  User? user = FirebaseAuth.instance.currentUser;
  final EquipmentPriceController equipmentPriceController = Get.put(EquipmentPriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('customerId', isEqualTo: user!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No bookings found!"),
            );
          }

          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final bookingData = snapshot.data!.docs[index];
                  Map<String, dynamic> bookingDataMap = bookingData.data() as Map<String, dynamic>;
                  List<dynamic> items = bookingDataMap['items'];

                  return Card(
                    elevation: 5,
                    child: ExpansionTile(
                      title: Text("Booking ID: ${bookingDataMap['bookingId']}"),
                      subtitle: Text(
                        "Phone: ${bookingDataMap['customerPhone']}",
                        
                      ),
                      children: items.asMap().entries.map((entry) {
                        int itemIndex = entry.key;
                        var item = entry.value;

                        // Ensuring the type conversion for fields
                        BookingModel bookingModel = BookingModel(
                          bookingId: bookingDataMap['bookingId'] ?? '',
                          equipmentId: item['equipmentId']?.toString() ?? '',
                          categoryId: item['categoryId']?.toString() ?? '',
                          equipmentName: item['equipmentName'] ?? '',
                          categoryName: item['categoryName'] ?? '',
                          rentPrice: item['rentPrice']?.toString() ?? '',
                          equipmentImages: List<String>.from(item['equipmentImages'] ?? []),
                          model: item['model'] ?? '',
                          equipmentDescription: item['equipmentDescription'] ?? '',
                          createdAt: (item['createdAt'] as Timestamp).toDate(),
                          startDate: item['startDate'] ?? '',
                          endDate: item['endDate'] ?? '',
                          numberOfDays: double.parse(item['numberOfDays'].toString()),
                          equipmentQuantity: double.parse(item['equipmentQuantity'].toString()),
                          equipmentTotalPrice: double.parse(item['equipmentTotalPrice'].toString()),
                          customerId: bookingDataMap['customerId'] ?? '',
                          status: item['status'] ?? '',
                          customerName: bookingDataMap['customerName'] ?? '',
                          customerPhone: bookingDataMap['customerPhone'] ?? '',
                          customerAddress: bookingDataMap['customerAddress'] ?? '',
                          customerCity: bookingDataMap['customerCity'] ?? '',
                          customerCountry: bookingDataMap['customerCountry'] ?? '',
                          customerState: bookingDataMap['customerState'] ?? '',
                          zipcode: bookingDataMap['zipcode']?.toString() ?? '', // Handle null case
                        );

                        DateTime createdAt = bookingModel.createdAt;
                        String formattedDate = DateFormat('MMMM d, y ' 'At' ' h:mm:ss a').format(createdAt);

                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingDetail(
                                  docId: snapshot.data!.docs[index].id,
                                  bookingModel: bookingModel,
                                ),
                              ),
                            );
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: bookingModel.equipmentImages.isNotEmpty
                                ? Image.network(bookingModel.equipmentImages[0], height: 100.0, width: 50.0,)
                                : Icon(Icons.image_not_supported),
                          ),
                          title: Text(bookingModel.equipmentName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Price: ${bookingModel.equipmentTotalPrice.toDouble()}"),
                              Text("Date: $formattedDate"),
                              Text(
                                "Status: ${bookingModel.status}",
                                style: TextStyle(
                                  color: bookingModel.status == 'Cancelled'
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
                              bookingModel.status != 'Delivered' && bookingModel.status != 'Cancelled'
                                  ? ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Cancel Booking!'),
                                              content: Text('Are you sure you want to cancel the booking?'),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('No')),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      items[itemIndex]['status'] = 'Cancelled';
                                                      await FirebaseFirestore.instance
                                                          .collection('bookings')
                                                          .doc(bookingData.id)
                                                          .update({'items': items}).then((value) {
                                                        print('Booking Cancelled');
                                                        Get.snackbar(
                                                          "Cancelled!",
                                                          "Cancelled booking successfully",
                                                          backgroundColor: Colors.green,
                                                          colorText: Colors.white,
                                                          duration: Duration(seconds: 2),
                                                        );
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Text('Yes')),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text('Cancel'),
                                    )
                                  : SizedBox.shrink(),
                                 IconButton(onPressed: () async {
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
                                 }, icon: Icon(Icons.delete))
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
