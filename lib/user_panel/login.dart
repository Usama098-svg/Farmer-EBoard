// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unused_local_variable, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/admin_panel/admin_page.dart';
import 'package:farmer_eboard/user_panel/signup.dart';
import 'package:flutter/material.dart';
import 'package:farmer_eboard/user_panel/categories.dart';
import 'package:farmer_eboard/user_panel/forgot_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(backgroundColor: Colors.amber,),
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
              padding: EdgeInsets.all(20),
              width: 300.0,
              height: 650.0,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Farmer eBoard',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'An Online Platform for Rent a Farming Equipments',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green, 
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 50.0),
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
                                return 'Please enter a email';
                              }
                              else if(!value.contains('@')){
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
                            obscuringCharacter: '*',
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
                              if (value == null || value.isEmpty || value.length < 6) {
                                return 'Password must be at least 6 characters long';
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
                          child: Text('Login'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                                 try {
                                    final UserCredential userCredential = await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: emailText.text, password: passwordText.text);
              
                                    final String uid = userCredential.user!.uid;
              
                                    // Check if the user is an admin or not (replace this with your actual check)
                                    final bool isAdmin = await checkIfUserIsAdmin(uid);
              
                                    if (isAdmin) {
                                      Get.snackbar(
                                        "Success Admin Login",
                                        "login Successfully!",
                                      //  snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                        duration: Duration(seconds: 2),
                                      );
                                      Get.offAll(() => AdminMainScreen());
                                    } else {
                                      Get.offAll(() => CategoriesPage());
                                      Get.snackbar(
                                        "Login",
                                        "login Successfully!",
                                      //  snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                        duration: Duration(seconds: 2),
                                      );
                                    }
                                  } catch (error) {
                                    print('Error: ${error.toString()}');
                                    String errorMessage = 'An error occurred';
                                    if (error == 'user-not-found') {
                                      errorMessage = 'Email is incorrect';
                                    } else if (error == 'wrong-password') {
                                      errorMessage = 'Password is incorrect';
                                    }
                                  // Display error message
                                  Get.snackbar(
                                        "Error",
                                        "Some error occur!",
                                      //  snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        duration: Duration(seconds: 2),
                                      );
                        }
                        }})
                      ),  
                      SizedBox(height: 10.0),
                      TextButton(
                        child: Text('Forgotten password?'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: ((context) => ForgotPage())));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?'),
                          TextButton(
                            child: Text('Signup'),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => SignupPage())));
                            },
                          )
                        ],
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
  
  Future<bool> checkIfUserIsAdmin(String uid) async {
  try {
    // Get the user document from Firestore
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    // Check if the document exists and if the user is an admin
    if (snapshot.exists && snapshot.data() != null) {
      return snapshot.data()!['isAdmin'] == true;
    }

    return false; // User document doesn't exist or isAdmin is false
  } catch (e) {
    print('Error checking admin status: $e');
    return false; // Error occurred, return false
  }
}
 
}
