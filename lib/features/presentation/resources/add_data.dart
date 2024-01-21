import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName).child('id');
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({
    // required Uint8List file,
    required String name,
    required String surname,
    required String age,
    required String address,
    required String classStudent,
    required String gender,
    required String mobile,
    required String studentID,
    required String typeEmployee,
  }) async {
    String resp = "Some Error Occurred";
    try {
      if (name.isNotEmpty) {
        // String imageUrl = await uploadImageToStorage("profileImage", file);
        await _firestore.collection("userProfile").add({
          "name": name,
          "surname" : surname,
          "age" : age,
          "address" : address,
          "classStudent" : classStudent,
          "gender" : gender,
          "mobile" : mobile,
          "studentID" : studentID,
          "typeEmployee" : typeEmployee,
          // "imageUrl": imageUrl,
        });
        resp = "success";
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
