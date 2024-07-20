// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/models/chart_model/booking_chart_model.dart';
import 'package:get/get.dart';

class GetAllBookingChart extends GetxController {
  final RxList<ChartData> monthlyBookingData = RxList<ChartData>();

  @override
  void onInit() {
    super.onInit();
    fetchMonthlyData();
  }

  Future<void> fetchMonthlyData() async {
    final CollectionReference bookingCollection =
        FirebaseFirestore.instance.collection('bookings');

    final DateTime dateMonthAgo = DateTime.now().subtract(Duration(days: 120));

    final QuerySnapshot allUserSnapshot = await bookingCollection.get();
    final Map<String, int> monthlyCount = {};

    for (QueryDocumentSnapshot userSnaphot in allUserSnapshot.docs) {
      final QuerySnapshot userBookingSnaphot = await bookingCollection
          .where('createdAt', isGreaterThanOrEqualTo: dateMonthAgo)
          .get();

      for (var booking in userBookingSnaphot.docs) {
        final Timestamp timestamp = booking['createdAt'];
        final DateTime dateTime = timestamp.toDate();
        final monthYear = '${dateTime.year}-${dateTime.month}';

        monthlyCount[monthYear] = (monthlyCount[monthYear] ?? 0) + 1;
      }
    }

    final List<ChartData> monthlyData = monthlyCount.entries
        .map((entry) => ChartData(entry.key, entry.value.toDouble()))
        .toList();

        if(monthlyData.isEmpty){
          monthlyBookingData.add(ChartData('Booking not found', 0));
        }
        else{
          monthlyData.sort((a, b) => a.month.compareTo(b.month));
          monthlyBookingData.assignAll(monthlyData);
        }
  }
}
