// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers

import 'package:farmer_eboard/user_panel/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  @override
  Widget build(BuildContext context) {
    var emailText = TextEditingController();

    final _formKey = GlobalKey<FormState>(); // Add this line

    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5, // Adjust the opacity here
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/grass.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              width: 300.0,
              height: 500.0,
              child: SingleChildScrollView(
                child: Form( // Wrap your content in a Form widget
                  key: _formKey, // Assign the form key
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      SizedBox(height: 40.0),
                      Container(
                      //  height: 250,
                      //  width: 250,
                        child: Image.asset('assets/Group 67.png'),
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email'),
                          SizedBox(height: 10.0,),
                          TextFormField( // Change TextField to TextFormField
                            keyboardType: TextInputType.emailAddress,
                            controller: emailText,
                            validator: (value) { // Add validator function
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              else if(!value.contains('@')){
                                return 'Please contain @ symbol';
                              }
                              // Add more validation as per your requirement, like email format validation
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.0),
                      Container(
                        height: 45.0,
                        width: 300.0,
                        child: ElevatedButton(
                          child: Text('RESET PASSWORD'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) { // Validate the form
                              try {
                                FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: emailText.text)
                                    .then((value) {
                                  print('Reset email sent successfully');
                                  Get.snackbar(
                                  "Reset!",
                                  "Reset email sent successfully",
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  duration: Duration(seconds: 2),
                                  );
                                  Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginPage())));
                                 
                                });
                              } on FirebaseAuthException catch (e) {
                                print('error $e');
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        height: 45.0,
                        width: 300.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey
                          ),
                          child: Text('BACK TO LOGIN'),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginPage())));
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
