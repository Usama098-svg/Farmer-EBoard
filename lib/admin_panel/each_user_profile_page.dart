// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/admin_panel/admin_drawer.dart';
import 'package:farmer_eboard/models/user_model.dart';
import 'package:farmer_eboard/user_panel/login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EachUserProfilePage extends StatelessWidget {
  UserModel userModel;
  EachUserProfilePage({super.key, required this.userModel});
 
 @override
  Widget build(BuildContext context) {
    DateTime createdAt = userModel.createdOn.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt);
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(elevation: 0,),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: AdminDrawerWidget(selectedItemIndex:1)),
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Dear ${userModel.username}', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 120.0,),
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
                            // Row(
                            //   children: [
                            //     SizedBox(width: 20),
                            //     Icon(Icons.account_circle),
                            //     SizedBox(width: 30),
                            //     Text('${userData['username']}'),
                            //   ],
                            // ),
                            ListTile(
                              title: Text(userModel.username),
                              iconColor: Colors.black,
                              leading: Icon(Icons.account_circle),
                              trailing: IconButton(
                                onPressed: (){
                                
                                }, 
                                icon: Icon(Icons.edit)),
                            ),
                            Divider(height: 10.0, thickness: 2.0),
                            SizedBox(height: 10.0),
                            // Row(
                            //   children: [
                            //     SizedBox(width: 20),
                            //     Icon(Icons.email),
                            //     SizedBox(width: 30),
                            //     Text('${user!.email}'),
                            //   ],
                            // ),
                             ListTile(
                              title: Text(userModel.email),
                              iconColor: Colors.black,
                              leading: Icon(Icons.email), 
                            ),
                            Divider(height: 10.0, thickness: 2.0),
                            SizedBox(height: 10.0),
                            // Row(
                            //   children: [
                            //     SizedBox(width: 20),
                            //     Icon(Icons.phone),
                            //     SizedBox(width: 30),
                            //     Text('${userData['phone']}'),
                            //   ],
                            // ),
                             ListTile(
                              title: Text(userModel.phone),
                              iconColor: Colors.black,
                              leading: Icon(Icons.phone),
                              trailing: IconButton(
                                onPressed: (){
                                
                                }, 
                                icon: Icon(Icons.edit)
                                ),
                            ),
                            Divider(height: 10.0, thickness: 2.0),
                            SizedBox(height: 10.0),
                            // Row(
                            //   children: [
                            //     SizedBox(width: 20),
                            //     Icon(Icons.location_on),
                            //     SizedBox(width: 30),
                            //     Text('${userData['userAddress']}'),
                            //   ],
                            // ),
                             ListTile(
                              title: Text(userModel.userAddress),
                              iconColor: Colors.black,
                              leading: Icon(Icons.location_on),
                              trailing: IconButton(
                                onPressed: (){
                                
                                }, 
                                icon: Icon(Icons.edit)),
                            ),
                            Divider(height: 10.0, thickness: 2.0),
                            SizedBox(height: 10.0),
                            // Row(
                            //   children: [
                            //     SizedBox(width: 20),
                            //     Icon(Icons.location_city),
                            //     SizedBox(width: 30),
                            //     Text('${userData['city']}'),
                            //   ],
                            // ),
                             ListTile(
                              title: Text(userModel.city),
                              iconColor: Colors.black,
                              leading: Icon(Icons.location_city),
                              trailing: IconButton(
                                onPressed: (){
                                
                                }, 
                                icon: Icon(Icons.edit)),
                            ),
                            Divider(height: 10.0, thickness: 2.0),
                            SizedBox(height: 10.0),
                            // Row(
                            //   children: [
                            //     SizedBox(width: 20),
                            //     Icon(Icons.location_searching),
                            //     SizedBox(width: 30),
                            //     Text('${userData['country']}'),
                            //   ],
                            // ),
                             ListTile(
                              title: Text(userModel.country),
                              iconColor: Colors.black,
                              leading: Icon(Icons.location_searching),
                              trailing: IconButton(
                                onPressed: (){
                                 
                                }, 
                                icon: Icon(Icons.edit)),
                            ),
                            Divider(height: 10.0, thickness: 2.0),
                            SizedBox(height: 10.0),
                            ListTile(
                              title: Text(formattedDate),
                              iconColor: Colors.black,
                              leading: Icon(Icons.person_add_sharp),
                            ),
                            Divider(height: 10.0, thickness: 2.0),
                            SizedBox(height: 10.0), 
                            ListTile(
                              title: Text('Delete Account' , style: TextStyle(color: Colors.red),),
                              leading: Icon(Icons.no_accounts),
                              iconColor: Colors.red,
                              onTap: () {
                                showDialog(context: context, builder: (context){
                                return AlertDialog(
                                title: Text('Delete!'),
                                content: Text('Are you sure you want to delete your account?'),
                                actions: [
                                 ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('No')),
                                ElevatedButton(onPressed: () async {
                             // await  user!.delete();
                              await FirebaseFirestore.instance.collection('users').doc(userModel.uid).delete().then((value) {
                              print('Account deleted successfully');
                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Account deleted successfully"), backgroundColor: Colors.green, ),); 
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginPage())));});
                              }, child: Text('Yes')
                            ),
                                  ],
                                 );
                              });
                              },
                            ),
                          
                            Divider(height: 20.0, thickness: 2.0),
                            SizedBox(height: 75.0), 
                          ],
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
          ),
        ],
      ),
    );
  }
} 
