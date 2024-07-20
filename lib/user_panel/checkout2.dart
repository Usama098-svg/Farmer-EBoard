// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, unused_local_variable, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables

import 'package:farmer_eboard/user_panel/place_order2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckOut2 extends StatefulWidget {
  CheckOut2({
    Key? key, 
  }) : super(key: key);

  @override
  State<CheckOut2> createState() => _CheckOut2State();
}

class _CheckOut2State extends State<CheckOut2> {
  User? user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController fullnameText = TextEditingController();
  TextEditingController numberText = TextEditingController();
  TextEditingController addressText = TextEditingController();
  TextEditingController zipcodeText = TextEditingController();
  var cityText = 'Select City';
  var stateText = 'Select State/Region/Province';
  var countryText = 'Select Country';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(backgroundColor: Colors.white, elevation: 0,),
      body: Center(
        child: Card(
          elevation: 50.0,
          shadowColor: Colors.black,
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: 400.0,
            height: 850.0,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'DETAILS',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    SizedBox(height: 50.0),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: fullnameText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'Full Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: numberText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'Mobile Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      maxLines: 3,
                      controller: addressText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'Address',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      value: cityText,
                      items: [
                        DropdownMenuItem<String>(
                          value: 'Select City',
                          child: Text('Select City'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Gujrat',
                          child: Text('Gujrat'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          cityText =
                              value!; // Update cityText with the selected value
                        });
                      },
                      validator: (value) {
                        if (value == null || value == 'Select City') {
                          return 'Please select a city';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      value: stateText,
                      items: [
                        DropdownMenuItem<String>(
                          value: 'Select State/Region/Province',
                          child: Text('Select State/Region/Province'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Punjab',
                          child: Text('Punjab'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          stateText = value!;
                        });
                      },
                       validator: (value) {
                        if (value == null || value == 'Select State/Region/Province') {
                          return 'Please select a state';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: zipcodeText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        hintText: 'Zip Code (Postal Code)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your zip code';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      value: countryText,
                      items: [
                        DropdownMenuItem<String>(
                          value: 'Select Country',
                          child: Text('Select Country'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Pakistan',
                          child: Text('Pakistan'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          countryText = value!;
                        });
                      },
                       validator: (value) {
                        if (value == null || value == 'Select Country') {
                          return 'Please select a country';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50.0),
                    Container(
                      height: 45.0,
                      width: 300.0,
                      child: ElevatedButton(
                        child: Text('CHECKOUT'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            PlaceOrder2(
                              context: context,
                              customerName: fullnameText.text,
                              customerPhone: numberText.text,
                              customerAddress: addressText.text,
                              customerCity: cityText,
                              customerState: stateText,
                              zipCode: zipcodeText.text,
                              customerCountry: countryText,
                            );
                            print('Order Placed Successfully');
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: ((context) => PaymentMethod(
                            //               bookingId: '',
                            //             ))));
                          } else {
                            print('some error');
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
      ),
    );
  }
}
