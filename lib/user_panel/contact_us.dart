// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  late User? user;
  late DocumentSnapshot userData;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    setState(() {
      userData = snapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(elevation: 0.0,),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Contact Us!', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 120.0, left: 30.0, right: 30.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Farmer EBoard Team'),
                        iconColor: Colors.black,
                        leading: Icon(Icons.account_circle), 
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('farmerebord@gmail.com'),
                        iconColor: Colors.black,
                        leading: Icon(Icons.email), 
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('+92123456789'),
                        iconColor: Colors.black,
                        leading: Icon(Icons.phone), 
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('Jalalpur Jatta'),
                        iconColor: Colors.black,
                        leading: Icon(Icons.location_on), 
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('Gujrat'),
                        iconColor: Colors.black,
                        leading: Icon(Icons.location_city), 
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('Pakistan'),
                        iconColor: Colors.black,
                        leading: Icon(Icons.location_searching), 
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 180.0),
                    ] 
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 75.0,
                    backgroundImage: AssetImage('assets/logo.jpg'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
