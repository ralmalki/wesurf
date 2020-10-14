import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  UserData({this.uid});

  Future updateOrAddUserName(String name) async {
    return await userCollection.doc(uid).set({"name": name});
  }
}
