// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_eboard/user_panel/change_password.dart';
import 'package:farmer_eboard/user_panel/login.dart';
import 'package:farmer_eboard/user_panel/user_controller/profile_image_controller.dart';
import 'package:farmer_eboard/user_panel/user_controller/signin_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AddProfileImageController addProfileImageController =
      Get.put(AddProfileImageController());
  TextEditingController username = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();

late User? user;
DocumentSnapshot? userData;
Uint8List? selectedImageInBytes;

@override
void initState() {
  super.initState();
  user = FirebaseAuth.instance.currentUser;
  _fetchUserData();
}

Future<void> _fetchUserData() async {
  if (user != null) {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    setState(() {
      userData = snapshot;
    });
  }
}

  @override
  Widget build(BuildContext context) {
     if (userData == null) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Center(
        child: CircularProgressIndicator(color: Colors.white,),
      ),
    );
  }
    DateTime createdAt = userData!['createdOn'].toDate();
    String formattedDate = DateFormat('MMMM d, y ' 'At' ' h:mm:ss a').format(createdAt);
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: userData == null
      ? Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Dear ${userData!['username']}',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 120.0, left: 30.0, right: 30.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('${userData!['username']}'),
                        iconColor: Colors.black,
                        leading: Icon(Icons.account_circle),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update Name'),
                                    content: TextField(
                                      controller: username,
                                      decoration: InputDecoration(
                                          hintText: '${userData!['username']}'),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await updateUserInfo()
                                              .updateName(
                                                  user!.uid, username.text)
                                              .then((value) {
                                            print('updated successfully');
                                            Get.snackbar(
                                              "Updated!",
                                              "Updated successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.pop(context);
                                          }).catchError((error) {
                                            print('Error: ${error.toString()}');
                                            String errorMessage =
                                                'An error occurred';
                                            // Display error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(errorMessage),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          });

                                          print(' Button pressed');
                                        },
                                        child: Text('Update'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit)),
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('${user!.email}'),
                        iconColor: Colors.black,
                        leading: Icon(Icons.email),
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('${userData!['phone']}'),
                        iconColor: Colors.black,
                        leading: Icon(Icons.phone),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update phone'),
                                    content: TextField(
                                      controller: phone,
                                      decoration: InputDecoration(
                                          hintText: '${userData!['phone']}'),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await updateUserInfo()
                                              .updatePhone(
                                                  user!.uid, phone.text)
                                              .then((value) {
                                            print('updated successfully');
                                            Get.snackbar(
                                              "Updated!",
                                              "Updated successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.pop(context);
                                          }).catchError((error) {
                                            print('Error: ${error.toString()}');
                                            String errorMessage =
                                                'An error occurred';
                                            // Display error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(errorMessage),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          });

                                          print('Button pressed');
                                        },
                                        child: Text('Update'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit)),
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('${userData!['userAddress']}'),
                        iconColor: Colors.black,
                        leading: Icon(Icons.location_on),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update Adress'),
                                    content: TextField(
                                      controller: userAddress,
                                      decoration: InputDecoration(
                                          hintText:
                                              '${userData!['userAddress']}'),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await updateUserInfo()
                                              .updateAddress(
                                                  user!.uid, userAddress.text)
                                              .then((value) {
                                            print('updated successfully');
                                            Get.snackbar(
                                              "Updated!",
                                              "Updated successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.pop(context);
                                          }).catchError((error) {
                                            print('Error: ${error.toString()}');
                                            String errorMessage =
                                                'An error occurred';
                                            // Display error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(errorMessage),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          });

                                          print('Button pressed');
                                        },
                                        child: Text('Update'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit)),
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('${userData!['city']}'),
                        iconColor: Colors.black,
                        leading: Icon(Icons.location_city),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update city'),
                                    content: TextField(
                                      controller: city,
                                      decoration: InputDecoration(
                                          hintText: '${userData!['city']}'),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await updateUserInfo()
                                              .updateCity(user!.uid, city.text)
                                              .then((value) {
                                            print('updated successfully');
                                            Get.snackbar(
                                              "Updated!",
                                              "Updated successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.pop(context);
                                          }).catchError((error) {
                                            print('Error: ${error.toString()}');
                                            String errorMessage =
                                                'An error occurred';
                                            // Display error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(errorMessage),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          });

                                          print('Button pressed');
                                        },
                                        child: Text('Update'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit)),
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('${userData!['country']}'),
                        iconColor: Colors.black,
                        leading: Icon(Icons.location_searching),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Update country'),
                                    content: TextField(
                                      controller: country,
                                      decoration: InputDecoration(
                                          hintText: '${userData!['country']}'),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await updateUserInfo()
                                              .updateCountry(
                                                  user!.uid, country.text)
                                              .then((value) {
                                            print('updated successfully');
                                            Get.snackbar(
                                              "Updated!",
                                              "Updated successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.pop(context);
                                          }).catchError((error) {
                                            print('Error: ${error.toString()}');
                                            String errorMessage =
                                                'An error occurred';
                                            // Display error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(errorMessage),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          });

                                          print('Button pressed');
                                        },
                                        child: Text('Update'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit)),
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text(formattedDate),
                        leading: Icon(Icons.person_add_sharp),
                        iconColor: Colors.black,
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: ((context) => ChangePasswordPage()))); 
                        },
                        title: Text('Change Password'),
                        leading: Icon(Icons.password),
                        iconColor: Colors.black,
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text('Logout'),
                        leading: Icon(Icons.logout),
                        iconColor: Colors.black,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Logout!'),
                                  content:
                                      Text('Are you sure you want to logout?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No')),
                                    ElevatedButton(
                                        onPressed: () {
                                          FirebaseAuth.instance
                                              .signOut()
                                              .then((value) {
                                            print('Logout successfully');
                                            Get.snackbar(
                                              "Logout!",
                                              "Logout successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginPage()))); 
                                            
                                          });
                                        },
                                        child: Text('Yes')),
                                  ],
                                );
                              });
                        },
                      ),
                      Divider(height: 10.0, thickness: 2.0),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text(
                          'Delete Account',
                          style: TextStyle(color: Colors.red),
                        ),
                        leading: Icon(Icons.no_accounts),
                        iconColor: Colors.red,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Delete!',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: Text(
                                      'Are you sure you want to delete your account?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No')),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await user!.delete();
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user!.uid)
                                              .delete()
                                              .then((value) {
                                            print(
                                                'Account deleted successfully');
                                            Get.snackbar(
                                              "Deleted!",
                                              "Account deleted successfully",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              duration: Duration(seconds: 2),
                                            );
                                            Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginPage())));
                                            
                                          });
                                        },
                                        child: Text('Yes')),
                                  ],
                                );
                              });
                        },
                      ),

                      Divider(height: 20.0, thickness: 2.0),
                      SizedBox(height: 75.0),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: CircleAvatar(
                      radius: 75.0,
                      // backgroundImage:AssetImage("assets/person1.jpg")
                   backgroundImage: selectedImageInBytes == null && (userData!['userImg'] == null || userData!['userImg'].isEmpty)
                 ? 
                
                 AssetImage('assets/person1.jpg')
                  : selectedImageInBytes != null && (userData!['userImg'] == null || userData!['userImg'].isNotEmpty)
                      ? MemoryImage(selectedImageInBytes!) as ImageProvider
                      : NetworkImage('${userData!['userImg']}'),
                            
                    ),
                  ),
                  Positioned(
                    top: 150.0,
                  //  left: 220.0,
                    child: IconButton(
                        onPressed: () async {
                          await deleteImage(userData!['userImg']);
                          await pickImage();
                        //  await addProfileImageController.showImagePickerDialog();
                        //  await addProfileImageController.uploadFile(addProfileImageController.selectedImage.value!);
                          // await updateUserInfo()
                          //     .updateProfilePic(user!.uid, addProfileImageController.imageUrl as String)
                          //     .then((value) {
                          //   print('updated successfully');
                          //   Get.snackbar(
                          //     "Updated!",
                          //     "Updated successfully",
                          //     backgroundColor: Colors.green,
                          //     colorText: Colors.white,
                          //     duration: Duration(seconds: 2),
                          //   );
                          //   Navigator.pop(context);
                          // }).catchError((error) {
                          //   print('Error: ${error.toString()}');
                          //   String errorMessage = 'An error occurred';
                          //   // Display error message
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text(errorMessage),
                          //       backgroundColor: Colors.red,
                          //     ),
                          //   );
                          // });
            
                          print('Button pressed');
                        },
                        icon: Icon(Icons.add_a_photo)),
                  )
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

   Future<void> deleteImage(String image)async {
    try {
      // Delete the image from Firebase Storage
      await FirebaseStorage.instance
          .refFromURL(image)
          .delete();

    //  Update the Firestore document to remove the image URL
      // await FirebaseFirestore.instance
      //     .collection('categories')
      //     .doc(widget.categoriesModel.categoryId)
      //     .update({
      //   'categoryImg': '',
      // });

      // Get.snackbar(
      //   "Deleted!",
      //   "Image deleted successfully",
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   duration: Duration(seconds: 2),
      // );
    } catch (e) {
      // Get.snackbar(
      //   "Error",
      //   "Failed to delete image",
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   duration: Duration(seconds: 2),
      // );
    }
  }
  
  //For mobile
  // Future<void> pickImage() async {
  //   try {
  //     final picker = ImagePicker();
  //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //     if (pickedFile != null) {
  //       setState(() {
  //         selectedImageInBytes = File(pickedFile.path).readAsBytesSync();
  //       });
  //       String downloadUrl = await uploadImage(selectedImageInBytes!);
  //       await updateUserInfo()
  //           .updateProfilePic(user!.uid, downloadUrl)
  //           .then((value) => print('updated successfully'));
  //       Get.snackbar(
  //         "Updated!",
  //         "Updated successfully",
  //         backgroundColor: Colors.green,
  //         colorText: Colors.white,
  //         duration: Duration(seconds: 2),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error:$e")));
  //   }
  // }

  // Future<String> uploadImage(Uint8List selectedImageInBytes) async {
  //   try {
  //     Reference referenceRoot = FirebaseStorage.instance.ref();
  //     Reference referenceDirImages = referenceRoot.child('ProfilePics');
  //     String imageName = randomAlphaNumeric(20);
  //     Reference referenceImageToUpload = referenceDirImages.child(imageName);

  //     final metadata = SettableMetadata(contentType: 'image/jpeg');
  //     UploadTask uploadTask = referenceImageToUpload.putData(selectedImageInBytes, metadata);

  //     await uploadTask;
  //     String downloadUrl = await referenceImageToUpload.getDownloadURL();
  //     return downloadUrl;
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  //   }
  //   return '';
  // }
    


  // For Web  
  Future<void> pickImage() async {
    try {
      FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (fileResult != null) {
        setState(() {
          // _imageFile = fileResult.files.first.name;
          selectedImageInBytes = fileResult.files.first.bytes;
        });
        String downloadUrl = await uploadImage(selectedImageInBytes!);
        await updateUserInfo()
            .updateProfilePic(user!.uid, downloadUrl)
            .then((value) => print('updated successfully'));
        Get.snackbar(
          "Updated!",
          "Updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:$e")));
    }
  }

  Future<String> uploadImage(Uint8List selectedImageInBytes) async {
    try {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('ProfilePics');
      String imageName = randomAlphaNumeric(20);
      Reference referenceImageToUpload = referenceDirImages.child(imageName);

      final metadata = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask =
          referenceImageToUpload.putData(selectedImageInBytes, metadata);

      await uploadTask;
      // .whenComplete(() => ScaffoldMessenger.of(context)
      //     .showSnackBar(const SnackBar(content: Text("Image Uploaded"))));
      String downloadUrl = await referenceImageToUpload.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return '';
  }
}
