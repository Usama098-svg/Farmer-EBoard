// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_constructors_in_immutables, sized_box_for_whitespace, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedbackList extends StatefulWidget {
  String equipmentId;
  FeedbackList(this.equipmentId, {super.key});

  @override
  State<FeedbackList> createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('feedbacks')
          .where('equipmentId', isEqualTo: widget.equipmentId)
          .snapshots(),
      //.orderBy('createdAt', descending: true)

      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Text('Error occurred while fetching feedbacks!'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Container(
            child: Center(
              child: Text('No reviews found!'),
            ),
          );
        }

        if (snapshot.data != null) {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                final createdAt = data['craetedAt'].toDate();
                final timeAgo = timeago.format(createdAt);

                return ListTile(
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
                  title: Text(data['feedback']),
                  subtitle: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['user']),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(timeAgo), 
                            Row(
                              children: [
                                Text(data['rating'].toString()),
                                SizedBox(width: 10,),
                                RatingBarIndicator(
                                  rating: data['rating'].toDouble(),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.green,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                                                    
                            ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return Container();
      },
    );
  }
}
