// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/all_count.dart';
import 'package:farmer_eboard/user_panel/cart_page.dart';
import 'package:farmer_eboard/user_panel/drawer.dart';
import 'package:farmer_eboard/user_panel/favorite_page.dart';
import 'package:farmer_eboard/models/category_model.dart';
import 'package:farmer_eboard/user_panel/profile_page.dart';
import 'package:farmer_eboard/user_panel/selected_catergory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final CategoryLengthController _categoryLengthController = Get.put(CategoryLengthController());
  User? user = FirebaseAuth.instance.currentUser;
  List<CategoriesModel> categories = [];
  String searchName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Obx(() {
          return Text(
            'Categories (${_categoryLengthController.categoryCollectionLength.toString()})',
            style: TextStyle(fontSize: 25.0),
          );
        }),
        elevation: 0.0,
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
            height: 30.0,
          ),
          Expanded(
            child: FutureBuilder<List<CategoriesModel>>(
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
                  categories = snapshot.data!;
                  return categories.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: GridView.extent(
                            shrinkWrap: true,
                            maxCrossAxisExtent: 210.0,
                            crossAxisSpacing: 5.0,
                            childAspectRatio: 0.9,
                            children: List.generate(
                              categories.length,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) => SelectedCategory(
                                                    categoryId: categories[index].categoryId,
                                                    categoryName: categories[index].categoryName,
                                                  ))));
                                    },
                                    child: ItemCard(categoriesModel: categories[index]),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Center(
                          child: Text("No category found!"),
                        );
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
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
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

  Future<List<CategoriesModel>> fetchCategories(String searchName) async {
    List<CategoriesModel> categories = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('categoryName', isGreaterThanOrEqualTo: searchName)
          .where('categoryName', isLessThanOrEqualTo: '$searchName\uf8ff')
          .get();
      for (var doc in querySnapshot.docs) {
        categories.add(
          CategoriesModel(
            categoryId: doc['categoryId'],
            categoryImg: doc['categoryImg'],
            categoryName: doc['categoryName'],
            createdAt: doc['createdAt'],
          ),
        );
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
    return categories;
  }
}

class ItemCard extends StatelessWidget {
  final CategoriesModel categoriesModel;

  const ItemCard({
    Key? key,
    required this.categoriesModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130.0,
          width: 200.0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
            child: Image.network(
              categoriesModel.categoryImg,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          width: 200.0,
          height: 30.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0))),
          child: Center(
            child: Text(categoriesModel.categoryName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ],
    );
  }
}
