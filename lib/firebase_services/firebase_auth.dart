
import 'package:cloud_firestore/cloud_firestore.dart'; 

class DatabaseMethods{ 
 
 //CREATE 
  Future addUserDetails( 
    Map<String, dynamic> userInfoMap, String id) async{ 
  return await FirebaseFirestore.instance 
  .collection('Users') 
  .doc(id) 
  .set(userInfoMap); 
  } 
 
 
 
 //READ 
  Future<List<QueryDocumentSnapshot<Object?>>> getUserDetails(String id)async{ 
  final QuerySnapshot user = await FirebaseFirestore.instance.collection('Users').where('id', isEqualTo: id).get();
  return user.docs;
 } 
 
 //UPDATE 
 Future updateUserDetail(String id, Map<String , dynamic> updateInfo) async{ 
 return  await 
FirebaseFirestore.instance.collection('Users').doc(id).update(updateInfo); 
 } 
 
 //DELETE 
 Future deleteUserDetail(String id) async{ 
 return  await FirebaseFirestore.instance.collection('Users').doc(id).delete(); 
} 
} 