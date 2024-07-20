// ignore_for_file: file_names

import 'dart:math';

String generateBookingId() {
  DateTime now = DateTime.now();

  int randomNumbers = Random().nextInt(99999);
  String id = '${now.microsecondsSinceEpoch}_$randomNumbers';

  return id;
}

String generateFeedbackId() {
  DateTime now = DateTime.now();

  int randomNumbers = Random().nextInt(99999);
  String id = '${now.microsecondsSinceEpoch}_$randomNumbers';

  return id;
}