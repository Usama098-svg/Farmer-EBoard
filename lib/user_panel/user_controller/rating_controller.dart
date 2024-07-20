// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CalculateProductRatingController extends GetxController {
  final String equipmentId;
  RxDouble averageRating = 0.0.obs;

  CalculateProductRatingController(this.equipmentId);

  @override
  void onInit() {
    super.onInit();
    calculateAverageRating();
  }

  void calculateAverageRating() {
    print('Calculating average rating for equipmentId: $equipmentId');
    FirebaseFirestore.instance
        .collection('feedbacks')
        .where('equipmentId', isEqualTo: equipmentId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        double totalRating = 0.0;
        int numberOfReviews = snapshot.docs.length;

        snapshot.docs.forEach((doc) {
          final ratingStr = doc['rating'].toString();
          final rating = double.tryParse(ratingStr);
          if (rating != null) {
            totalRating += rating;
          } else {
            print('Failed to parse rating: $ratingStr');
          }
        });

        averageRating.value = totalRating / numberOfReviews;
        print('Total Rating: $totalRating, Number of Reviews: $numberOfReviews, Average Rating: ${averageRating.value}');
      } else {
        averageRating.value = 0.0;
        print('No ratings found for equipmentId: $equipmentId');
      }
    }, onError: (error) {
      print('Error fetching feedbacks: $error');
    });
  }
}
