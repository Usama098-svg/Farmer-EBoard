// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:farmer_eboard/admin_panel/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/all_count.dart';
import 'package:farmer_eboard/admin_panel/each_user_profile_page.dart';
import 'package:farmer_eboard/models/user_model.dart';
import 'package:get/get.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final UserLengthController _userLengthController = Get.put(UserLengthController());
  String searchName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text('Users (${_userLengthController.userCollectionLength.toString()})');
        }),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: AdminDrawerWidget(selectedItemIndex:1)),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchName = value;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search User',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<UserModel>>(
                    future: fetchCategories(searchName),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error occurred while fetching users!'),
                        );
                      } else {
                        List<UserModel> users = snapshot.data!;
                        return users.isNotEmpty
                            ? ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  return ItemCard(userModel: users[index]);
                                },
                              )
                            : Center(
                                child: Text("No User found!"),
                              );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<UserModel>> fetchCategories(String searchName) async {
  List<UserModel> users = [];
  Set<String> userIds = {};
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: searchName)
        .where('username', isLessThanOrEqualTo: '$searchName\uf8ff')
        .get();
    QuerySnapshot emailQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: searchName)
        .where('email', isLessThanOrEqualTo: '$searchName\uf8ff')
        .get();
    for (var doc in querySnapshot.docs) {
      if (!userIds.contains(doc['uId'])) {
        users.add(
          UserModel(
            uid: doc['uId'],
            username: doc['username'],
            email: doc['email'],
            phone: doc['phone'],
            userImg: doc['userImg'],
            userDeviceToken: doc['userDeviceToken'],
            country: doc['country'],
            userAddress: doc['userAddress'],
            street: doc['street'],
            isAdmin: doc['isAdmin'],
            isActive: doc['isActive'],
            createdOn: doc['createdOn'],
            city: doc['city'],
          ),
        );
        userIds.add(doc['uId']);
      }
    }
    for (var doc in emailQuerySnapshot.docs) {
      if (!userIds.contains(doc['uId'])) {
        users.add(
          UserModel(
            uid: doc['uId'],
            username: doc['username'],
            email: doc['email'],
            phone: doc['phone'],
            userImg: doc['userImg'],
            userDeviceToken: doc['userDeviceToken'],
            country: doc['country'],
            userAddress: doc['userAddress'],
            street: doc['street'],
            isAdmin: doc['isAdmin'],
            isActive: doc['isActive'],
            createdOn: doc['createdOn'],
            city: doc['city'],
          ),
        );
        userIds.add(doc['uId']);
      }
    }
  } catch (e) {
    print("Error fetching users: $e");
  }
  return users;
}

}

class ItemCard extends StatelessWidget {
  final UserModel userModel;

  const ItemCard({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
        elevation: 5.0,
        child: ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: ((context) => EachUserProfilePage(userModel: userModel))));
          
          },
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: userModel.userImg != ''
            ? NetworkImage(userModel.userImg)
            : AssetImage('assets/person1.jpg') as ImageProvider
            // backgroundImage: CachedNetworkImageProvider(
            //   userModel.userImg,
            //   errorListener: (err) {
            //     // Handle the error here
            //     print('Error loading image');
            //     Icon(Icons.error);
            //   },
            // ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(userModel.username),
              userModel.isAdmin == true
              ?Text('Admin', style: TextStyle(color: Colors.green, decoration: TextDecoration.overline),)
              :Text(''),
            ],
          ),
          subtitle: Text(userModel.email),
          trailing: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete!'),
                        content: Text('Are you sure you want to delete user?'),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No')),
                          ElevatedButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userModel.uid)
                                    .delete()
                                    .then((value) {
                                  print('User deleted successfully');
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text("User deleted successfully"),
                                    backgroundColor: Colors.green,
                                  ));
                                });
                              },
                              child: Text('Yes')),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.delete)),
        ),
      ),
    );
  }
}
