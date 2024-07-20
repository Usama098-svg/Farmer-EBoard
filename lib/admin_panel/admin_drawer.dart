// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:farmer_eboard/admin_panel/admin_page.dart';
import 'package:farmer_eboard/admin_panel/all_booking.dart';
import 'package:farmer_eboard/admin_panel/all_categories.dart';
import 'package:farmer_eboard/admin_panel/all_equipments.dart';
import 'package:farmer_eboard/admin_panel/all_feedback.dart';
import 'package:farmer_eboard/admin_panel/all_users.dart';
import 'package:farmer_eboard/user_panel/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDrawerWidget extends StatefulWidget {
  int selectedItemIndex;
  AdminDrawerWidget({Key? key, required this.selectedItemIndex}) : super(key: key);

  @override
  State<AdminDrawerWidget> createState() => _AdminDrawerWidgetState();
}

class _AdminDrawerWidgetState extends State<AdminDrawerWidget> {
  int selectedItemIndex = 0;
  @override
  void initState() {
    super.initState();
    selectedItemIndex = widget.selectedItemIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      )),
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: 15.0,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: ListTile(
                title: Text('Dear Admin Farmer'),
                subtitle: Text('Farmer Eboard App'),
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.green,
                  child: Text('F'),
                ),
              ),
            ),
            Divider(
              indent: 10.0,
              endIndent: 10.0,
              thickness: 1.0,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListTile(
                selected: selectedItemIndex == 0,
                onTap: () {
                  setState(() {
                    selectedItemIndex = 0;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => AdminMainScreen())));
                },
                title: Text('Home'),
                leading: Icon(Icons.home),
                trailing: Icon(Icons.arrow_forward_sharp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListTile(
                selected: selectedItemIndex == 1,
                onTap: () {
                  setState(() {
                    selectedItemIndex = 1;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => AllUsers())));
                },
                title: Text('Users'),
                leading: Icon(Icons.person),
                trailing: Icon(Icons.arrow_forward_sharp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListTile(
                selected: selectedItemIndex == 2,
                onTap: () {
                  setState(() {
                    selectedItemIndex = 2;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => AllBooking())));
                },
                title: Text('Bookings'),
                leading: Icon(Icons.local_mall_outlined),
                trailing: Icon(Icons.arrow_forward_sharp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListTile(
                selected: selectedItemIndex == 3,
                onTap: () {
                  setState(() {
                    selectedItemIndex = 3;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => AllFeedbacks())));
                },
                title: Text('Feedbacks'),
                leading: Icon(Icons.feedback),
                trailing: Icon(Icons.arrow_forward_sharp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListTile(
                selected: selectedItemIndex == 4,
                onTap: () {
                  setState(() {
                    selectedItemIndex = 4;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => AllCategories())));
                },
                title: Text('Categories'),
                leading: Icon(Icons.category),
                trailing: Icon(Icons.arrow_forward_sharp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListTile(
                selected: selectedItemIndex == 5,
                onTap: () {
                  setState(() {
                    selectedItemIndex = 5;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => AllEquipments())));
                },
                title: Text('Equipments'),
                leading: Icon(Icons.shopping_cart),
                trailing: Icon(Icons.arrow_forward_sharp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListTile(
                title: Text('Contact'),
                leading: Icon(Icons.help_center),
                trailing: Icon(Icons.arrow_forward_sharp),
              ),
            ),
           Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Logout!'),
                                content: Text(
                                    'Are you sure you want to logout?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('No')),
                                  ElevatedButton(
                                      onPressed: () {
                                        FirebaseAuth.instance
                                            .signOut()
                                            .then((value) {
                                          print('Admin logout successfully');
                                          Get.snackbar(
                                            "Admin logout!",
                                            "Admin logout successfully",
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            duration: Duration(seconds: 2),
                                          );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      LoginPage())));
                                        });
                                      },
                                      child: Text('Yes')),
                                ],
                              );
                            });
                      },
                      title: Text('Log Out'),
                      leading: Icon(Icons.logout_sharp),
                      trailing: Icon(Icons.arrow_forward_sharp),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
