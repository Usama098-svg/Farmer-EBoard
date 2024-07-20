// ignore_for_file: prefer_const_constructors, unused_local_variable, use_build_context_synchronously, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/models/equipment_model.dart';
import 'package:farmer_eboard/user_panel/user_controller/generate_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class FeedbackDialog extends StatefulWidget {
  EquipmentModel equipmentModel;
  FeedbackDialog({super.key, required this.equipmentModel});

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  TextEditingController feedback = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  late User? user = FirebaseAuth.instance.currentUser;
  double starRating = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Feedback'),
        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingBar.builder(
                    initialRating: 0.0,
                    minRating: 1.0,
                    allowHalfRating: true,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 30.0,
                    itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.green,
                    ),
                    onRatingUpdate: (ratingvalue) {
                      starRating = ratingvalue;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: feedback,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: 'Enter your feedback here...',
                    ),
                    maxLines: 4,
                    maxLength: 500,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your feedback';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
        TextButton(
            onPressed: () async {
              String feedbackId = generateFeedbackId();
              if (_formKey.currentState!.validate()) {
                String message;
                try {
                  await FirebaseFirestore.instance
                      .collection('feedbacks')
                      .doc(feedbackId)
                      .set({
                        'craetedAt': DateTime.now(),
                        'feedback': feedback.text,
                        'rating' : starRating,
                        'feedbackId': feedbackId,
                        'user': user!.email.toString(),
                        'equipmentId': widget.equipmentModel.equipmentId.toString(),
                        'equipmentName': widget.equipmentModel.equipmentName.toString(),
                        'categoryName' : widget.equipmentModel.categoryName.toString()
                      });
                       print('Your feedback sended');
                        Get.snackbar(
                          "Sended!",
                          "Your feedback sended",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: Duration(seconds: 2),
                        );
                        Navigator.pop(context);
                } catch (e) {
                  message = 'Error while sending feedback';
                }
              }
            },
            child: Text('Send')),
      ],
    );
  }
}
