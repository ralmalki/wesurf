import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    FirebaseMessaging _fcm = FirebaseMessaging();
    try {
      fav = List.from(documentSnapshot['favLocations']);

      if (fav.contains(locationUID) == true) {
        documentReference.update({
          'favLocations': FieldValue.arrayRemove([locationUID])
        });
        _fcm.unsubscribeFromTopic(locationUID);
        return false;
      } else {
        documentReference.update(({
          'favLocations': FieldValue.arrayUnion([locationUID])
        }));
        _fcm.subscribeToTopic(locationUID);
      }
      return true;
    } catch (e) {
      if (fav == null) {
        await documentReference.set({
          "favLocations": [
            {locationUID}
          ]
        });
        _fcm.subscribeToTopic(locationUID);
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

  Future<void> showAlertDialog(
      BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // void confirmPasswordChange(String newPassword) {
  //   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //   User user = firebaseAuth.currentUser;
  //
  //   string newPassword = "SOME-SECURE-PASSWORD";
  //   if (user != null) {
  //     user.UpdatePasswordAsync(newPassword).ContinueWith(task => {
  //     if (task.IsCanceled) {
  //     Debug.LogError("UpdatePasswordAsync was canceled.");
  //     return;
  //     }
  //     if (task.IsFaulted) {
  //     Debug.LogError("UpdatePasswordAsync encountered an error: " + task.Exception);
  //     return;
  //     }
  //
  //     Debug.Log("Password updated successfully.");
  //     });
  //   }
  // }
}
