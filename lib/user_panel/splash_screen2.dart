
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:farmer_eboard/user_panel/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(height:60.0),
          Center(child: Image.asset('assets/SplashScreenImage.png')),
          SizedBox(height:77.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Find Your ",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
                Text("FARMING EQUIPMENTS",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold, color: Colors.green),),
                Text("Here!",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
                SizedBox(height: 10.0,),
                Text("Explore all the most advanced and demanding farming equipments here."),
                SizedBox(height: 50.0,),
              ],
            ),
          ),
          
          ],),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0, right: 10.0),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0)
          ),
          onPressed: () {
            Get.to(()=>LoginPage());
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.arrow_forward,color: Colors.white,),
        ),
      )
    );
  }
}