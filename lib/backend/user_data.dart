import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  UserData({this.uid});

  Future updateOrAddUserName(String name) async {
    return await userCollection
        .doc(uid)
        .set({"name": name, "favLocations": [], "auth": true});
  }

  Future<String> getUserName() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['name'];
  }

  //check if user has login before
  Future<bool> firstTime() async {
    DocumentReference documentReference =
      FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['auth'];
  }

  //get user favorite spots to populate loved-spots page
  Future<List<dynamic>> getFavSpots() async {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['favLocations'];
  }

  Future<bool> addFavLocationToUser(String locationUID) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    List<String> fav;
    try {
      fav = List.from(documentSnapshot['favLocations']);

      if (fav.contains(locationUID) == true) {
        documentReference.update({
          'favLocations': FieldValue.arrayRemove([locationUID])
        });
        return false;
      } else {
        documentReference.update(({
          'favLocations': FieldValue.arrayUnion([locationUID])
        }));
      }
      return true;
    } catch (e) {
      if (fav == null) {
        await documentReference.set({
          "favLocations": [
            {locationUID}
          ]
        });
      }
      print(e);

      return false;
    }
  }

  Future<bool> checkLocationInFav(String locationUID) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    List<String> fav;
    try {
      fav = List.from(documentSnapshot['favLocations']);

      if (fav.contains(locationUID) == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
