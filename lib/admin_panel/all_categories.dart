// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:farmer_eboard/admin_panel/admin_drawer.dart';
import 'package:farmer_eboard/admin_panel/edit_category.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/admin_panel/add_category.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/all_count.dart';
import 'package:farmer_eboard/models/category_model.dart';
import 'package:get/get.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({Key? key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  TextEditingController UpdateCategoyName = TextEditingController();
  final CategoryLengthController _categoryLengthController = Get.put(CategoryLengthController());
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text('Categories (${_categoryLengthController.categoryCollectionLength.toString()})');
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) => AddCategory())));
              },
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: AdminDrawerWidget(selectedItemIndex:4)),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search Category',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Container(
                          child: Center(
                            child: Text('Error occurred while fetching categories!'),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Container(
                          child: Center(
                            child: Text('No categories found!'),
                          ),
                        );
                      }
          
                      if (snapshot.data != null) {
                        final filteredCategories = snapshot.data!.docs.where((doc) =>
                            doc['categoryName'].toString().toLowerCase().contains(searchQuery.toLowerCase()));
                        return ListView.builder(
                          itemCount: filteredCategories.length,
                          itemBuilder: (context, index) {
                            final data = filteredCategories.elementAt(index);
                            CategoriesModel categoriesModel = CategoriesModel(
                              categoryId: data['categoryId'],
                              categoryImg: data['categoryImg'],
                              categoryName: data['categoryName'],
                              createdAt: data['createdAt'],
                            );
          
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Card(
                                elevation: 5.0,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 30.0,
                                    backgroundColor: Colors.green,
                                    backgroundImage: NetworkImage(categoriesModel.categoryImg),
                                  //  child: Image.network(categoriesModel.categoryImg)
                                  ),
                                  title: Text('Category : ${categoriesModel.categoryName}'),
                                  subtitle: Text('CategoryId : ${categoriesModel.categoryId}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () async {
                                          Navigator.push(context, MaterialPageRoute(builder: ((context) => EditCategory(categoriesModel:categoriesModel))));
                                          // showDialog(
                                          //   context: context,
                                          //   builder: (context) {
                                          //     return AlertDialog(
                                          //       title: Text('Update category name'),
                                          //       content: TextField(
                                          //         controller: UpdateCategoyName,
                                          //         decoration: InputDecoration(hintText: categoriesModel.categoryName),
                                          //       ),
                                          //       actions: [
                                          //         ElevatedButton(
                                          //           onPressed: () {
                                          //             Navigator.pop(context);
                                          //           },
                                          //           child: Text('Cancel'),
                                          //         ),
                                          //         ElevatedButton(
                                          //           onPressed: () async {
                                          //            await FirebaseFirestore.instance
                                          //            .collection('categories')
                                          //            .doc(categoriesModel.categoryId)
                                          //            .update({
                                          //             'categoryName': UpdateCategoyName.text
                                          //            }).then((value) {
                                          //               print('Updated successfully');
                                          //               Get.snackbar(
                                          //                 "Updated!",
                                          //                 "Updated successfully",
                                          //                 backgroundColor: Colors.green,
                                          //                 colorText: Colors.white,
                                          //                 duration: Duration(seconds: 2),
                                          //                 );
                                          //               Navigator.pop(context);
                                          //             });
                                          //           },
                                          //           child: Text('Update'),
                                          //         ),
                                          //       ],
                                          //     );
                                          //  },
                                        //  );
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Delete!'),
                                                content: Text('Are you sure you want to delete?'),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('No'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await deleteImagesFromFirebase(categoriesModel.categoryImg);
                                                      await FirebaseFirestore.instance
                                                          .collection('categories')
                                                          .doc(categoriesModel.categoryId)
                                                          .delete()
                                                          .then((value) {
                                                        print('Deleted successfully');
                                                        Get.snackbar(
                                                          "Deleted!",
                                                          "Category deleted successfully",
                                                          backgroundColor: Colors.green,
                                                          colorText: Colors.white,
                                                          duration: Duration(seconds: 2),
                                                          );
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Text('Yes'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
          
                      return Container();
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

  Future deleteImagesFromFirebase(String imageUrl) async {
      try {
        Reference reference = FirebaseStorage.instance.refFromURL(imageUrl);
        reference.delete();
        print('deleteddd');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    
  }
}
