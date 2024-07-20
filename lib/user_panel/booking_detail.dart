// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:carousel_slider/carousel_slider.dart';
import 'package:farmer_eboard/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetail extends StatefulWidget {
  String docId;
  BookingModel bookingModel;
  BookingDetail({super.key, required this.docId, required this.bookingModel,});

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  @override
  Widget build(BuildContext context) {
    DateTime createdAt = widget.bookingModel.createdAt;
    String formattedDate = DateFormat('MMMM d, y ' 'At' ' h:mm:ss a').format(createdAt);
    // DateTime startDate = widget.bookingModel.startDate.toDate();
    // String formattedstartDate = DateFormat('dd-MM-yyyy').format(startDate);
    // DateTime endDate = widget.bookingModel.endDate.toDate();
    // String formattedendDate = DateFormat('dd-MM-yyyy').format(endDate);
    
    return Scaffold(
      appBar: AppBar(title: Text('My Booking Detail')),
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:120.0),
              child: Container(
                 decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                 child:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            SizedBox(height: 170.0,),
            Divider(height:20.0, color:Colors.black),
            Text('Equipment Description :',style:TextStyle(fontWeight: FontWeight.bold) ,),
            SizedBox(height: 10.0,),
            Text(widget.bookingModel.equipmentDescription),
            Divider(height:20.0, color:Colors.black),
            SizedBox(height: 20.0,),
                   
            Column(
             crossAxisAlignment: CrossAxisAlignment.start,  
             children: [
                   Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(formattedDate,style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                   SizedBox(height: 20.0,),
                   Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'Booking Id:',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue: widget.bookingModel.bookingId,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'Equipment Name:',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue: widget.bookingModel.equipmentName,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'Category :',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue: widget.bookingModel.categoryName,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'Rent Pre Day : ',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue: widget.bookingModel.rentPrice,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'Start Date :',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue: widget.bookingModel.startDate,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'End Date :',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue: widget.bookingModel.endDate,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'Number of Days :',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue:
                               widget.bookingModel.numberOfDays.toString(),
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'Quantity :',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue:
                               widget.bookingModel.equipmentQuantity.toString(),
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'Subtotal :',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue:
                               widget.bookingModel.equipmentTotalPrice.toString(),
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'Customer Name :',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue: widget.bookingModel.customerName,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'Phone : ',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue: widget.bookingModel.customerPhone,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'Address :',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue: widget.bookingModel.customerAddress,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Text(
                         'Status :',
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: TextFormField(
                           initialValue: widget.bookingModel.status,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                               borderSide: BorderSide(color: Colors.black),
                             ),
                           )),
                     ),
             ],
                )
            ],
            ),
            ),
            ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  viewportFraction: 1.0 
                ),
                items: widget.bookingModel.equipmentImages.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () => _showImageDialog(imageUrl) ,
                        child: Container(
                          width: 200.0,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
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
    );
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