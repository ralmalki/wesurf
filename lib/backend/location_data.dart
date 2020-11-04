import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class LocationData {
  LocationData({this.locationUID});
  final String locationUID;

  final CollectionReference locationCollection =
      FirebaseFirestore.instance.collection('locations');

  void addPost(String postUID) async {
    return await locationCollection.doc(locationUID).update({
      'posts': FieldValue.arrayUnion([postUID])
    });
  }

  void updateDanger() async {
    DocumentReference locationReference = locationCollection.doc(locationUID);
    DocumentSnapshot locationSnapshot = await locationReference.get();
    print("shark: ${locationSnapshot['shark']}");
    if (locationSnapshot['bluebottle'] >= 2 ||
        locationSnapshot['current'] >= 2 ||
        locationSnapshot['shark'] >= 2 ||
        locationSnapshot['uv'] >= 2 ||
        locationSnapshot['wave'] >= 2 ||
        locationSnapshot['wind'] >= 2) {
      locationReference.update({'dangerous': true});
    }
  }

  Future<String> getLocationName() async {
    DocumentReference locationReference = locationCollection.doc(locationUID);
    DocumentSnapshot locationSnapshot = await locationReference.get();
    return locationSnapshot['name'];
  }

  Future<bool> getDangerous() async {
    DocumentReference locationReference = locationCollection.doc(locationUID);
    DocumentSnapshot locationSnapshot = await locationReference.get();
    return locationSnapshot['dangerous'];
  }
}
