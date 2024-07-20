// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/admin_panel/admin_controller/all_count.dart';
import 'package:farmer_eboard/admin_panel/admin_drawer.dart';
import 'package:farmer_eboard/admin_panel/feedback_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllFeedbacks extends StatefulWidget {
  const AllFeedbacks({super.key});

  @override
  State<AllFeedbacks> createState() => _AllFeedbacksState();
}

class _AllFeedbacksState extends State<AllFeedbacks> {
  final FeedbackLengthController _feedbackLengthController =
      Get.put(FeedbackLengthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(
              'Feedbacks (${_feedbackLengthController.feedbackCollectionLength.toString()})');
        }),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: AdminDrawerWidget(selectedItemIndex:3)),
          Expanded(
            flex: 6,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('feedbacks')
                  //  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                      child: Text('Error occurred while fetching feedbacks!'),
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
                      child: Text('No feedback found!'),
                    ),
                  );
                }
          
                if (snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index];
          
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Card(
                          elevation: 5.0,
                          child: ListTile(
                            onTap: (() {
                              Navigator.push(context, MaterialPageRoute(builder: ((context) =>FeedbackDetail(
                                            feedbackId: snapshot.data!.docs[index]
                                                ['feedbackId'],
                                            categoryName: snapshot.data!.docs[index]
                                                ['categoryName'],
                                            craetedAt: snapshot.data!.docs[index]
                                                ['craetedAt'],
                                            equipmentId: snapshot.data!.docs[index]
                                                ['equipmentId'],
                                            equipmentName: snapshot.data!.docs[index]
                                                ['equipmentName'],
                                            feedback: snapshot.data!.docs[index]
                                                ['feedback'],
                                            rating: snapshot.data!.docs[index]
                                                ['rating'],    
                                            user: snapshot.data!.docs[index]['user'],
                                          ))));}),
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Text(data['user'][2]),
                              // backgroundImage: CachedNetworkImageProvider(
                              //   userModel.userImg,
                              //   errorListener: (err) {
                              //     // Handle the error here
                              //     print('Error loading image');
                              //     Icon(Icons.error);
                              //   },
                              // ),
                            ),
                            title: Text('Feedback : ${data['feedback']}'),
                            subtitle: Text('User : ${data['user']}'),
                            trailing: IconButton(
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
                                            await FirebaseFirestore.instance
                                                .collection('feedbacks')
                                                .doc(
                                                  snapshot.data!.docs[index]
                                                      ['feedbackId'],
                                                )
                                                .delete()
                                                .then((value) {
                                              print('Deleted successfully');
                                              Get.snackbar(
                                                "Deleted!",
                                                "Feedback deleted successfully",
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
    );
  }
}
