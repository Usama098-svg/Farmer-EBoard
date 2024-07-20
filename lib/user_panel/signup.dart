// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unused_local_variable

import 'package:farmer_eboard/user_panel/user_controller/signup_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farmer_eboard/user_panel/login.dart';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameText = TextEditingController();
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  TextEditingController confirmPasswordText = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    nameText.dispose();
    emailText.dispose();
    passwordText.dispose();
    confirmPasswordText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Container(
                padding: EdgeInsets.all(20),
                width: 300.0,
                height: 750.0,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create an Account',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        SizedBox(height: 50.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Full Name'),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: nameText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email'),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                else if (!value.contains('@')) {
                                  return 'Please contain @ symbol';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Password'),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              controller: passwordText,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                prefixIcon: IconButton(
                                  icon: _obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Confirm Password'),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              controller: confirmPasswordText,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                prefixIcon: IconButton(
                                  icon: _obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != passwordText.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 25.0),
                        Container(
                          height: 45.0,
                          width: 300.0,
                          child: ElevatedButton(
                            child: Text('SIGN UP'),
                            onPressed: () async{
                              if (_formKey.currentState!.validate()) {
                                String name = nameText.text.trim();
                                String email = emailText.text.trim();
                                String password = passwordText.text.trim();
                                String confirmpassword = confirmPasswordText.text.trim();
                                String userDeviceToken = '';
                                 UserCredential? userCredential =
                                    await SignUpController().signUpMethod(
                                  name,
                                  email,
                                  password,
                                  confirmpassword,
                                  userDeviceToken,
                                );
                                if (userCredential != null) {
                                print('Account Created...!');
                                Get.snackbar(
                                "Created",
                                "Account created successfully!",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: Duration(seconds: 2),
                              );
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginPage())));
                               
                              }
                            }
                          } ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?'),
                            TextButton(
                              child: Text('Login'),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginPage())));
                              },
                            )
                          ],
                        )
                      ],
                    ),
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
