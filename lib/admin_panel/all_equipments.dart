// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, unnecessary_null_comparison

import 'package:farmer_eboard/admin_panel/admin_drawer.dart';
import 'package:farmer_eboard/admin_panel/edit_equipment_detail.dart';
import 'package:farmer_eboard/admin_panel/eqipment_detail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/admin_panel/add_equipment.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/all_count.dart';
import 'package:farmer_eboard/models/equipment_model.dart';
import 'package:get/get.dart';

class AllEquipments extends StatefulWidget {
  const AllEquipments({Key? key});

  @override
  State<AllEquipments> createState() => _AllEquipmentsState();
}

class _AllEquipmentsState extends State<AllEquipments> {
  final EquipmentLengthController _equipmentLengthController =
      Get.put(EquipmentLengthController());
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(
              'Equipments (${_equipmentLengthController.equipmentCollectionLength.toString()})');
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => AddEquipment())));
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
            child: AdminDrawerWidget(selectedItemIndex:5)),
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
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search Equipment',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('equipments')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Container(
                          child: Center(
                            child: Text('Error occurred while fetching equipments!'),
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
                            child: Text('No equipments found!'),
                          ),
                        );
                      }
          
                      if (snapshot.data != null) {
                        final filteredEquipments = snapshot.data!.docs.where((doc) =>
                            doc['equipmentName']
                                .toString()
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()));
                        return ListView.builder(
                          itemCount: filteredEquipments.length,
                          itemBuilder: (context, index) {
                            final data = filteredEquipments.elementAt(index);
                            EquipmentModel equipmentModel = EquipmentModel(
                              equipmentId: data['equipmentId'],
                              equipmentName: data['equipmentName'],
                              categoryName: data['categoryName'],
                              rentPrice: data['rentPrice'],
                              equipmentImages: data['equipmentImages'],
                              model: data['model'],
                              link: data['link'],
                              equipmentDescription: data['equipmentDescription'],
                              createdAt: data['createdAt'],
                            );
          
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Card(
                                elevation: 5.0,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: ((context) => EquipmentDetail( equipmentModel: equipmentModel ))));
                                    
                                  },
                                  leading: CircleAvatar(
                                    radius: 30.0,
                                    backgroundColor:
                                        (equipmentModel.equipmentImages == null ||
                                                equipmentModel.equipmentImages.isEmpty)
                                            ? Colors.green
                                            : null,
                                    backgroundImage: (equipmentModel.equipmentImages !=
                                                null &&
                                            equipmentModel.equipmentImages.isNotEmpty)
                                        ? NetworkImage(
                                            equipmentModel.equipmentImages[0])
                                        : null,
                                  ),
                                  title: Text('Name : ${equipmentModel.equipmentName}'),
                                  subtitle:
                                      Text('Category : ${equipmentModel.categoryName}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: ((context) =>EditEquipment( equipmentModel:equipmentModel))));
                                          
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Delete!'),
                                                content: Text(
                                                    'Are you sure you want to delete?'),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('No'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await deleteImagesFromFirebase(
                                                          equipmentModel
                                                              .equipmentImages);
                                                      await FirebaseFirestore.instance
                                                          .collection('equipments')
                                                          .doc(equipmentModel
                                                              .equipmentId)
                                                          .delete()
                                                          .then((value) {
                                                        print('Deleted successfully');
                                                        Get.snackbar(
                                                          "Deleted!",
                                                          "Equipment deleted successfully",
                                                          backgroundColor: Colors.green,
                                                          colorText: Colors.white,
                                                          duration:
                                                              Duration(seconds: 2),
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

  Future deleteImagesFromFirebase(List imagesUrls) async {
    for (String imagesUrl in imagesUrls) {
      try {
        Reference reference = FirebaseStorage.instance.refFromURL(imagesUrl);
        reference.delete();
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
}
