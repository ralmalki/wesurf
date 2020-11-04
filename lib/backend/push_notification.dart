import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wesurf/screens/home.dart';

class PushNotification extends StatefulWidget {
  @override
  _PushNotificationState createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
      _fcm.onIosSettingsRegistered.listen((event) {
        print("IOS Registered");
      });
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        //this callback happens when you are in the app and notification is received
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        //this callback happens when you launch app after a notification received
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        //this callbakc happens when you open the app after a notification received AND
        //app was running in the background
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Home();
  }
}
