// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/user_panel/bookings_page.dart';
import 'package:farmer_eboard/user_panel/categories.dart';
import 'package:farmer_eboard/user_panel/contact_us.dart';
import 'package:farmer_eboard/user_panel/favorite_page.dart';
import 'package:farmer_eboard/user_panel/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late User? user;
  DocumentSnapshot? userData;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        userData = snapshot;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0),
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        child: userData == null
            ? Center(child: CircularProgressIndicator())
            : Wrap(
                runSpacing: 10.0,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: ListTile(
                      title: Text('Dear ${userData!['username']}'),
                      subtitle: Text('${user!.email}'),
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => CategoriesPage())));
                      },
                      title: Text('My Home'),
                      leading: Icon(Icons.home),
                      trailing: Icon(Icons.arrow_forward_sharp),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => MyBookings())));
                      },
                      title: Text('My Booking'),
                      leading: Icon(Icons.local_mall_outlined),
                      trailing: Icon(Icons.arrow_forward_sharp),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => FavouritePage())));
                      },
                      title: Text('My Favorite'),
                      leading: Icon(Icons.favorite_border_outlined),
                      trailing: Icon(Icons.arrow_forward_sharp),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ContactUs())));
                      },
                      title: Text('Contact Us'),
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
                                          print('Logout successfully');
                                          Get.snackbar(
                                            "Logout!",
                                            "Logout successfully",
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
