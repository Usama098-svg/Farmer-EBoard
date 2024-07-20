// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, avoid_unnecessary_containers

import 'package:farmer_eboard/user_panel/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmnewpassword = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    super.dispose();
    newpassword.dispose();
    confirmnewpassword.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
              height: 650.0,
              child: SingleChildScrollView(
                child: Form(
                  // Wrap your content in a Form widget
                  key: _formKey, // Assign the form key
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.0),
                      Text(
                        'Change Password?',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        //  height: 250,
                        //  width: 250,
                        child: Image.asset('assets/changepassword11.png', height: 200.0, width: 200.0,),
                      ),
                      SizedBox(height: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('New Password'),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: newpassword,
                            obscureText: _obscureText,
                            validator: (value) {
                              // Add validator function
                              if (value == null || value.isEmpty) {
                                return 'Please enter your new password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              prefixIcon: IconButton(
                                icon: _obscureText
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text('Confirm New Password'),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: confirmnewpassword,
                            obscureText: _obscureText,
                            validator: (value) {
                              // Add validator function
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
              
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              prefixIcon: IconButton(
                                icon: _obscureText
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
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
                          child: Text('CHANGE PASSWORD'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (newpassword.text == confirmnewpassword.text) {
                                try {
                                  await user!.updatePassword(newpassword.text);
                                  FirebaseAuth.instance.signOut();
                                  print('Your password changed successfully');
                                  Get.snackbar(
                                    "Changed!",
                                    "Your password changed successfully",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    duration: Duration(seconds: 2),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) => LoginPage()),
                                    ),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  print('error $e');
                                }
                              } else {
                                // Show an error message to the user
                                Get.snackbar(
                                  "Error",
                                  "Passwords do not match",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  duration: Duration(seconds: 2),
                                );
                              }
                            }
                          },
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
