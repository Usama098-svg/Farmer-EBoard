// ignore_for_file: file_names, unused_field, non_constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


//All users count
class UserLengthController extends GetxController {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _userControllerSubscription;

  final Rx<int> userCollectionLength = Rx<int>(0);

  @override
  void onInit() {
    super.onInit();

    _userControllerSubscription = FirebaseFirestore.instance
        .collection('users')
        .where('isAdmin', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      userCollectionLength.value = snapshot.size;
    });
  }

  @override
  void onClose() {
    _userControllerSubscription.cancel();
    super.onClose();
  }
}


//All quipments count
class EquipmentLengthController extends GetxController {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _equipmentControllerSubscription;

  final Rx<int> equipmentCollectionLength = Rx<int>(0);

  @override
  void onInit() {
    super.onInit();

    _equipmentControllerSubscription = FirebaseFirestore.instance
        .collection('equipments')
        .snapshots()
        .listen((snapshot) {
       equipmentCollectionLength.value = snapshot.size;
    });
  }

  @override
  void onClose() {
    _equipmentControllerSubscription.cancel();
    super.onClose();
  }
}

  //All categories count
 class CategoryLengthController extends GetxController {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _categoryControllerSubscription;

  final Rx<int> categoryCollectionLength = Rx<int>(0);

  @override
  void onInit() {
    super.onInit();

    _categoryControllerSubscription = FirebaseFirestore.instance
        .collection('categories')
        .snapshots()
        .listen((snapshot) {
        categoryCollectionLength.value = snapshot.size;
    });
  }

  @override
  void onClose() {
    _categoryControllerSubscription.cancel();
    super.onClose();
  }
 }

  //All subcategories count
 class SubCategoryLengthController extends GetxController {
  final String categoryName;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _subCategoryControllerSubscription;

  final Rx<int> subCategoryCollectionLength = Rx<int>(0);

  SubCategoryLengthController({required this.categoryName});

  @override
  void onInit() {
    super.onInit();
    _subCategoryControllerSubscription = FirebaseFirestore.instance
        .collection('equipments')
        .where('categoryName', isEqualTo: categoryName)
        .snapshots()
        .listen((snapshot) {
      subCategoryCollectionLength.value = snapshot.size;
    });
  }

  @override
  void onClose() {
    _subCategoryControllerSubscription.cancel();
    super.onClose();
  }
}

//All booking count
class BookingLengthController extends GetxController {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _bookingControllerSubscription;

  final Rx<int> bookingCollectionLength = Rx<int>(0);

  @override
  void onInit() {
    super.onInit();

    _bookingControllerSubscription = FirebaseFirestore.instance
        .collection('bookings')
        .snapshots()
        .listen((snapshot) {
        bookingCollectionLength.value = snapshot.size;
    });
  }

  @override
  void onClose() {
    _bookingControllerSubscription.cancel();
    super.onClose();
  }
}

//All cancelled booking count
class CancelledBookingLengthController extends GetxController {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _cancelledBookingControllerSubscription;
  final Rx<int> cancelledBookingCollectionLength = Rx<int>(0);

  @override
  void onInit() {
    super.onInit();
    _cancelledBookingControllerSubscription = FirebaseFirestore.instance
        .collection('bookings')
        .snapshots()
        .listen((snapshot) {
      int count = 0;
      for (var doc in snapshot.docs) {
        List<dynamic> items = doc['items'] as List<dynamic>;
        for (var item in items) {
          if (item['status'] == 'Cancelled') {
            count++;
          }
        }
      }
      cancelledBookingCollectionLength.value = count;
    });
  }

  @override
  void onClose() {
    _cancelledBookingControllerSubscription.cancel();
    super.onClose();
  }
}


//All pending booking count
class PendingBookingLengthController extends GetxController {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _pendingBookingControllerSubscription;
  final Rx<int> pendingBookingCollectionLength = Rx<int>(0);

  @override
  void onInit() {
    super.onInit();
    _pendingBookingControllerSubscription = FirebaseFirestore.instance
        .collection('bookings')
        .snapshots()
        .listen((snapshot) {
      int count = 0;
      for (var doc in snapshot.docs) {
        List<dynamic> items = doc['items'] as List<dynamic>;
        for (var item in items) {
          if (item['status'] == 'Pending') {
            count++;
          }
        }
      }
      pendingBookingCollectionLength.value = count;
    });
  }

  @override
  void onClose() {
    _pendingBookingControllerSubscription.cancel();
    super.onClose();
  }
}


//All delivered booking count
class DeliveredBookingLengthController extends GetxController {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _deliveredBookingControllerSubscription;
  final Rx<int> deliveredBookingCollectionLength = Rx<int>(0);

  @override
  void onInit() {
    super.onInit();
    _deliveredBookingControllerSubscription = FirebaseFirestore.instance
        .collection('bookings')
        .snapshots()
        .listen((snapshot) {
      int count = 0;
      for (var doc in snapshot.docs) {
        List<dynamic> items = doc['items'] as List<dynamic>;
        for (var item in items) {
          if (item['status'] == 'Delivered') {
            count++;
          }
        }
      }
      deliveredBookingCollectionLength.value = count;
    });
  }

  @override
  void onClose() {
    _deliveredBookingControllerSubscription.cancel();
    super.onClose();
  }
}


//All feedback count
class FeedbackLengthController extends GetxController {
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _feedbackControllerSubscription;

  final Rx<int> feedbackCollectionLength = Rx<int>(0);

  @override
  void onInit() {
    super.onInit();

    _feedbackControllerSubscription = FirebaseFirestore.instance
        .collection('feedbacks')
        .snapshots()
        .listen((snapshot) {
        feedbackCollectionLength.value = snapshot.size;
    });
  }

  @override
  void onClose() {
    _feedbackControllerSubscription.cancel();
    super.onClose();
  }
}
