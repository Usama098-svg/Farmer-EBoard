// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_build_context_synchronously

import 'dart:async';

import 'package:farmer_eboard/admin_panel/admin_page.dart';
import 'package:farmer_eboard/user_panel/categories.dart';
import 'package:farmer_eboard/user_panel/splash_screen2.dart';
import 'package:farmer_eboard/user_panel/user_controller/keep_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class LogoScreen extends StatefulWidget{
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), (){
        loggdin(context);    
    });
  }
  
  Future<void> loggdin(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController =
          Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.email.toString());

      if (userData[0]['isAdmin'] == true) {
        Navigator.push(context, MaterialPageRoute(builder: ((context) => AdminMainScreen())));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: ((context) => CategoriesPage())));
      }
    } else {
        Navigator.push(context, MaterialPageRoute(builder: ((context) => SplashScreen2())));
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/logo.jpg'),
              Text('Powered by RU2', style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      )
      );
  }
}