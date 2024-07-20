// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_build_context_synchronously, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/models/equipment_model.dart';
import 'package:farmer_eboard/user_panel/categories.dart';
import 'package:farmer_eboard/user_panel/favorite_equipment_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_page.dart';
import 'profile_page.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  User? user = FirebaseAuth.instance.currentUser;

  void deleteEquipment(String equipmentId) async {
    await FirebaseFirestore.instance
        .collection('favourite')
        .doc(user!.uid)
        .collection('myfavourite')
        .doc(equipmentId)
        .delete();
    print('Favourite equipment deleted...');
    Get.snackbar(
      "Deleted!",
      "Favourite equipment deleted",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Favourite')),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('favourite')
              .doc(user!.uid)
              .collection('myfavourite')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                //  height: Get.height / 5,
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("My Favourite is empty...!"),
              );
            }

            if (snapshot.data != null) {
              return GridView.extent(
                shrinkWrap: true,
                maxCrossAxisExtent: 210.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 0.9,
                children: List.generate(
                  snapshot.data!.docs.length,
                  (index) {
                    final equipmentData = snapshot.data!.docs[index];
                    EquipmentModel equipmentModel = EquipmentModel(
                      equipmentId: equipmentData['equipmentId'],
                      equipmentName: equipmentData['equipmentName'],
                      categoryName: equipmentData['categoryName'],
                      rentPrice: equipmentData['rentPrice'],
                      equipmentImages: equipmentData['equipmentImages'],
                      model: equipmentData['model'],
                      link: equipmentData['link'],
                      equipmentDescription:
                          equipmentData['equipmentDescription'],
                      createdAt: DateTime.now(),
                    );
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ItemCard(
                          equipmentModel: equipmentModel,
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Delete!'),
                                  content:
                                      Text('Are you sure you want to delete?'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('No'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        deleteEquipment(
                                            equipmentModel.equipmentId);
                                        Get.snackbar(
                                          'Deleted',
                                          "Favourite equipment is deleted",
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          duration: Duration(seconds: 2),
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => FavoriteDetailScreen(
                                    equipmentModel: equipmentModel))));
                      },
                    );
                  },
                ),
              );
            }

            return Container();
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.grid_view_outlined),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => CategoriesPage())));
              },
              color: Colors.white,
            ),
            IconButton(
              icon: Icon(Icons.local_mall_outlined),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => MyCart())));
              },
              color: Colors.white,
            ),
            IconButton(
              icon: Icon(Icons.favorite_border_outlined),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => FavouritePage())));
              },
              color: Colors.white,
            ),
            IconButton(
              icon: Icon(Icons.account_circle_outlined),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => ProfilePage())));
              },
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final EquipmentModel equipmentModel;
  final VoidCallback onDelete;

  ItemCard({
    Key? key,
    required this.equipmentModel,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ Column(
       // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120.0,
            width: 200.0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft:Radius.circular(15.0), topRight: Radius.circular(15.0)),
              child: Image.network(
                equipmentModel.equipmentImages[0],
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: 200.0,
            decoration: BoxDecoration(color: Colors.green ,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(equipmentModel.equipmentName,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('RS.${equipmentModel.rentPrice} PERDAY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 5.0,)
              ],
            ),
          ), 
           
        ],
      ),
       Positioned(
          top: 5.0,
          right: 5.0,
          child: Icon(Icons.favorite, color: Colors.red),
        ),
        Positioned(
            top: 5.0,
            left: 5.0,
            child: GestureDetector(
              onTap: onDelete,
              child: Icon(Icons.delete, color: Colors.red),
            )),
      ]
    );
  }
}
