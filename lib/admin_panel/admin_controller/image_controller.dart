// ignore_for_file: unused_field, unused_local_variable, prefer_const_constructors

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageController extends GetxController{
  final ImagePicker _picker = ImagePicker();
  RxList<XFile> selectedImages = <XFile>[].obs;
  final RxList<String> arrImagesUrl = <String>[].obs;
  final FirebaseStorage storageRef = FirebaseStorage.instance;

  Future<void> showImagesPickerDialog() async{
    PermissionStatus status;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

    if(androidDeviceInfo.version.sdkInt <= 32)
    {
      status = await Permission.storage.request();
    }
    else
    {
      status = await Permission.mediaLibrary.request();
    }

    //
    if(status == PermissionStatus.granted)
    {
      Get.defaultDialog(
        title: 'Choose Image',
        middleText: 'Pick an image from the camera or gallery?',
        actions: [
          ElevatedButton(onPressed: (){selectImages('camera');}, child: Text('Camera')),
          ElevatedButton(onPressed: (){selectImages('Gallery');}, child: Text('Gallery')),
        ]

      );
    }
    if(status == PermissionStatus.denied)
    {
      print('Error please allow premission for futher usage');
      openAppSettings();
    }
    if(status == PermissionStatus.permanentlyDenied)
    {
      print('Error please allow premission for futher usage');
      openAppSettings();
    }
   }

    Future<void> selectImages(String type) async{
      List<XFile> imgs = [];
      if(type == 'Gallery')
      {
        try{
          imgs = await _picker.pickMultiImage(imageQuality: 80);
          update();
        } catch(e){
          print('error $e');
        }
      }
      else
      {
        final img = await _picker.pickImage(source: ImageSource.camera , imageQuality: 80);
        if(img != null)
        {
          imgs.add(img);
          update();
        }

      }
      if(imgs.isNotEmpty)
      {
        selectedImages.addAll(imgs);
        update();
      }
    }

    void removeImages(int index){
      selectedImages.removeAt(index);
      update();
    }
  }

  
  
















  // }
 // import 'package:firebase/firebase.dart' as fb;
 // import 'package:flutter/material.dart';
 // import 'package:get/get.dart';
 // import 'package:image_picker/image_picker.dart';
 // import 'package:image_picker_web/image_picker_web.dart';

 // class ImageContoller extends GetxController {
 //   RxList<XFile> selectedImages = <XFile>[].obs;
 //   final RxList<String> arrImagesUrl = <String>[].obs;

 //   Future<void> showImagesPickerDialog() async {
 //     fb.StorageReference storageRef = fb.storage().ref('images');

 //     Get.defaultDialog(
 //       title: 'Choose Image',
 //       middleText: 'Pick an image from the camera or gallery?',
 //       actions: [
 //         ElevatedButton(
 //           onPressed: () async {
 //             // XFile? image = await ImagePickerWeb().pickImage();
 //             // if (image != null) {
 //             //   selectedImages.add(image);
 //             //   uploadImage(storageRef, image);
 //             // }
 //             // Get.back();
 //           },
 //           child: Text('Gallery'),
 //         ),
 //       ],
 //     );
 //   }

 //   Future<void> uploadImage(fb.StorageReference storageRef, XFile image) async {
 //     fb.UploadTask task = storageRef.child(image.name).put(image.readAsBytesSync());
 //     fb.UploadTaskSnapshot snapshot = await task.future;
 //     String downloadUrl = await snapshot.ref.getDownloadURL();
 //     arrImagesUrl.add(downloadUrl);
//   }
// }


// import 'dart:io';
// import 'dart:io' show File;

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:oktoast/oktoast.dart';
// import 'package:uuid/uuid.dart';

// class UploadPage extends StatefulWidget {
//   const UploadPage({Key? key}) : super(key: key);

//   @override
//   _UploadPageState createState() => _UploadPageState();
// }

// class _UploadPageState extends State<UploadPage> {
//   List<Widget> itemPhotosWidgetList = <Widget>[];

//   final ImagePicker _picker = ImagePicker();
//   File? file;
//   List<XFile>? photo = <XFile>[];
//   List<XFile> itemImagesList = <XFile>[];

//   List<String> downloadUrl = <String>[];

//   bool uploading = false;

//   @override
//   Widget build(BuildContext context) {
//     double _screenwidth = MediaQuery.of(context).size.width,
//         _screenheight = MediaQuery.of(context).size.height;
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//       if (constraints.maxWidth < 480) {
//         return displayPhoneUploadFormScreen(_screenwidth, _screenheight);
//       } else {
//         return displayWebUploadFormScreen(_screenwidth, _screenheight);
//       }
//     });
//   }

//   displayPhoneUploadFormScreen(_screenwidth, _screenheight) {
//     return Container();
//   }

//   displayWebUploadFormScreen(_screenwidth, _screenheight) {
//     return OKToast(
//         child: Scaffold(
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 100.0,
//           ),
//           Container(
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12.0),
//                 color: Colors.white70,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade200,
//                     offset: const Offset(0.0, 0.5),
//                     blurRadius: 30.0,
//                   )
//                 ]),
//             width: _screenwidth * 0.7,
//             height: 300.0,
//             child: Center(
//               child: itemPhotosWidgetList.isEmpty
//                   ? Center(
//                       child: MaterialButton(
//                         onPressed: pickPhotoFromGallery,
//                         child: Container(
//                           alignment: Alignment.bottomCenter,
//                           child: Center(
//                             child: Image.network(
//                               "https://static.thenounproject.com/png/3322766-200.png",
//                               height: 100.0,
//                               width: 100.0,
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   : SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Wrap(
//                         spacing: 5.0,
//                         direction: Axis.horizontal,
//                         children: itemPhotosWidgetList,
//                         alignment: WrapAlignment.spaceEvenly,
//                         runSpacing: 10.0,
//                       ),
//                     ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(
//                   top: 50.0,
//                   left: 100.0,
//                   right: 100.0,
//                 ),
//                 child: ElevatedButton( 
//                     onPressed: uploading ? null : () => upload(),
//                     child: uploading
//                         ? const SizedBox(
//                             child: CircularProgressIndicator(),
//                             height: 15.0,
//                           )
//                         : const Text(
//                             "Add",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           )),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ));
//   }

//   addImage() {
//     for (var bytes in photo!) {
//       itemPhotosWidgetList.add(Padding(
//         padding: const EdgeInsets.all(1.0),
//         child: Container(
//           height: 90.0,
//           child: AspectRatio(
//             aspectRatio: 16 / 9,
//             child: Container(
//               child: kIsWeb
//                   ? Image.network(File(bytes.path).path)
//                   : Image.file(
//                       File(bytes.path),
//                     ),
//             ),
//           ),
//         ),
//       ));
//     }
//   }

//   pickPhotoFromGallery() async {
//     photo = await _picker.pickMultiImage();
//     if (photo != null) {
//       setState(() {
//         itemImagesList = itemImagesList + photo!;
//         addImage();
//         photo!.clear();
//       });
//     }
//   }

//   upload() async {
//     String productId = await uplaodImageAndSaveItemInfo();
//     setState(() {
//       uploading = false;
//     });
//     showToast("Image Uploaded Successfully");
//   }

//   Future<String> uplaodImageAndSaveItemInfo() async {
//     setState(() {
//       uploading = true;
//     });
//     PickedFile? pickedFile;
//     String? productId = const Uuid().v4();
//     for (int i = 0; i < itemImagesList.length; i++) {
//       file = File(itemImagesList[i].path);
//       pickedFile = PickedFile(file!.path);

//       await uploadImageToStorage(pickedFile, productId);
//     }
//     return productId;
//   }

//   uploadImageToStorage(PickedFile? pickedFile, String productId) async {
//     String? pId = const Uuid().v4();
//     Reference reference =
//         FirebaseStorage.instance.ref().child('Items/$productId/product_$pId');
//     await reference.putData(
//       await pickedFile!.readAsBytes(),
//       SettableMetadata(contentType: 'image/jpeg'),
//     );
//     String value = await reference.getDownloadURL();
//     downloadUrl.add(value);
//   }
// 