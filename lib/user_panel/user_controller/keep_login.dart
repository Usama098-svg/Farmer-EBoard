// ignore_for_file: file_names, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetUserDataController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Object?>>> getUserData(String email) async {
    final QuerySnapshot userData =
        await _firestore.collection('users').where('email', isEqualTo: email).get();
    return userData.docs;
  }
}