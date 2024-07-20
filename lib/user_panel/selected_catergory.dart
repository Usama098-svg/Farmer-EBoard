// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/all_count.dart';
import 'package:farmer_eboard/user_panel/cart_page.dart';
import 'package:farmer_eboard/user_panel/categories.dart';
import 'package:farmer_eboard/user_panel/detail_page.dart';
import 'package:farmer_eboard/user_panel/drawer.dart';
import 'package:farmer_eboard/user_panel/favorite_page.dart';
import 'package:farmer_eboard/user_panel/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/equipment_model.dart';

class SelectedCategory extends StatefulWidget {
  String categoryId;
  String categoryName;
  SelectedCategory(
      {Key? key, required this.categoryId, required this.categoryName})
      : super(key: key);

  @override
  State<SelectedCategory> createState() => _SelectedCatergoryState();
}

class _SelectedCatergoryState extends State<SelectedCategory> {
 
  late SubCategoryLengthController _subCategoryLengthController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller only once
    _subCategoryLengthController = Get.put(SubCategoryLengthController(categoryName: widget.categoryName));
  }

  @override
  void dispose() {
    // Dispose of the controller properly
    if (Get.isRegistered<SubCategoryLengthController>()) {
      Get.delete<SubCategoryLengthController>();
    }
    super.dispose();
  }
  User? user = FirebaseAuth.instance.currentUser;
  List<EquipmentModel> equipments = [];
  String searchName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
         title:Obx(() {
          return Text('${widget.categoryName} (${_subCategoryLengthController.subCategoryCollectionLength.toString()})', style: TextStyle(fontSize: 25.0),);
        }),
      ),
      drawer: DrawerWidget(),
      body: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
                  hintText: 'Search Equipment',
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: FutureBuilder<List<EquipmentModel>>(
              future: fetchCategories(searchName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error occurred while fetching categories!'),
                  );
                } else {
                  equipments = snapshot.data!;
                  return equipments.isNotEmpty
                      ? Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: GridView.extent(
                            shrinkWrap: true,
                            maxCrossAxisExtent: 210.0,
                            crossAxisSpacing: 5.0,
                            childAspectRatio: 0.9,
                            children: List.generate(
                              equipments.length,
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                     Navigator.push(context, MaterialPageRoute(builder: ((context) => DetailScreen(equipmentModel: equipments[index]))));
                                  },
                                  child:
                                      ItemCard(equipmentModel: equipments[index]),
                                );
                              },
                            ),
                          ),
                      )
                      : Center(child: Text("No equipment found!"),);
                }
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.grid_view_outlined),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) => CategoriesPage())));
              },
              color: Colors.green,
            ),
            IconButton(
              icon: Icon(Icons.local_mall_outlined),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) => MyCart())));
              },
              color: Colors.green,
            ),
            IconButton(
              icon: Icon(Icons.favorite_border_outlined),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) => FavouritePage())));
              },
              color: Colors.green,
            ),
            IconButton(
              icon: Icon(Icons.account_circle_outlined),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) => ProfilePage())));
              },
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Future<List<EquipmentModel>> fetchCategories(String searchName) async {
    List<EquipmentModel> equipments = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('equipments')
          .where('categoryName', isEqualTo: widget.categoryName)
          .get();
      for (var doc in querySnapshot.docs) {
        EquipmentModel equipment = EquipmentModel(
          equipmentId: doc['equipmentId'],
          equipmentName: doc['equipmentName'],
          categoryName: doc['categoryName'],
          rentPrice: doc['rentPrice'],
          equipmentImages: doc['equipmentImages'],
          model: doc['model'],
          link: doc['link'],
          equipmentDescription: doc['equipmentDescription'],
          createdAt: doc['createdAt'],
        );

        // Filter by searchName
        if (searchName.isEmpty ||
            equipment.equipmentName
                .toLowerCase()
                .contains(searchName.toLowerCase())) {
          equipments.add(equipment);
        }
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
    return equipments;
  }
  
}

class ItemCard extends StatelessWidget {
  final EquipmentModel equipmentModel;

  const ItemCard({
    Key? key,
    required this.equipmentModel,
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
            decoration: BoxDecoration(color: Colors.white ,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(equipmentModel.equipmentName,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('RS.${equipmentModel.rentPrice} PERDAY', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ), 
           
        ],
      ),
      Positioned(
          top: 5.0,
          right: 5.0,
          child: Icon(Icons.favorite, color: Colors.green),
        ),
      ]
    );
  }
}
 
