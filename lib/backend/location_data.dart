import 'package:cloud_firestore/cloud_firestore.dart';

class LocationData {
  LocationData({this.locationUID});
  final String locationUID;

  final CollectionReference locationCollection =
  FirebaseFirestore.instance.collection('locations');

  Future addPost(String postUID) async {
    return await locationCollection
        .doc(locationUID)
        .update({
      'posts': FieldValue.arrayUnion([postUID])
    });
  }
}