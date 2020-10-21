import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class MediaStore {

  StorageReference firebaseStorageRef = FirebaseStorage.instance.ref();

  Future uploadImage(File imageFile, String path) {
    //StorageUploadTask uploadTask = firebaseStorageRef.child(path).putData(imageFile.path);

  }

}
