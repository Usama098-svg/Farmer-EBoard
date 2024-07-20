// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class updateEquipmentDetail{
  
 Future updateName(String id, String name) async{
 return await
 FirebaseFirestore.instance
 .collection('equipments')
 .doc(id)
 .update({'equipmentName': name});
 }

  Future updateDescription(String id, String Description) async{
 return await
 FirebaseFirestore.instance
 .collection('equipments')
 .doc(id)
 .update({'equipmentDescription': Description});
 }

  Future updateRent(String id, String rent) async{
 return await
 FirebaseFirestore.instance
 .collection('equipments')
 .doc(id)
 .update({'rentPrice': rent});
 }

  Future updatedmodel(String id, String updatedmodel) async{
 return await
 FirebaseFirestore.instance
 .collection('equipments')
 .doc(id)
 .update({'model': updatedmodel});
 }

  Future updatecategoryName(String id, String categoryName) async{
 return await
 FirebaseFirestore.instance
 .collection('equipments')
 .doc(id)
 .update({'categoryName': categoryName});
 }

Future updateimageUrls(String id, List picurls) async{
 return await
 FirebaseFirestore.instance
 .collection('equipments')
 .doc(id)
 .update({'equipmentImages': picurls});
 }

}