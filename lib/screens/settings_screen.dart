import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:http/http.dart';
import 'package:wesurf/backend/user_data.dart';
import 'package:wesurf/components/accessibility_page.dart';
import 'package:wesurf/components/notification_page.dart';
import 'package:wesurf/components/security_page.dart';

import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String username = "";

  Future<void> _logout() async {
    //await Firebase.initializeApp();

    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  void getUserName() async {
    await UserData(uid: FirebaseAuth.instance.currentUser.uid)
        .getUserName()
        .then((value) {
      setState(() {
        username = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    double appbar_h = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
              fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        color: Color(0xFFF2F2F7),
        child: Column(
          children: [
            _userProfile_btn(username, "assets/profile_pic2.png"),
            SizedBox(
              height: 25,
            ),
            option_btn(TablerIcons.user_plus, "Invite Mates"),
            SizedBox(
              height: 18,
            ),
            option_btn(TablerIcons.bell, "Notifications"),
            SizedBox(
              height: 18,
            ),
            option_btn(TablerIcons.accessible, "Accessibility"),
            SizedBox(
              height: 18,
            ),
            option_btn(TablerIcons.lock, "Security"),
            SizedBox(
              height: 18,
            ),
            // option_btn(TablerIcons.info_circle, "About"),
            // SizedBox(
            //   height: 18,
            // ),
            option_btn(TablerIcons.logout, "Log Out"),
          ],
        ),
      ),
    );
  }

  Widget _userInfo(String username, String profile_pic_path) {
    return Container(
        // padding: EdgeInsets.fromLTRB(12, 18, 20, 0),
        child: Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Image.asset(profile_pic_path, width: 30, height: 30),
            SizedBox(width: 7),
            Text(username, style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        SizedBox(height: 6),
      ],
    ));
  }

  Widget _userProfile_btn(String username, String profile_pic_path) {
    return RaisedButton(
      textColor: Colors.black,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: [
            Image.asset(profile_pic_path, width: 40, height: 40),
            SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(username,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              SizedBox(height: 3),
              Text("See my profile",
                  style: TextStyle(
                      color: Color(0xff75798C),
                      fontSize: 12,
                      fontWeight: FontWeight.w300)),
            ]),
          ],
        ),
      ),
      onPressed: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      },
    );
  }

  Widget option_btn(
    IconData icon_type,
    String btn_str,
  ) {
    return FlatButton(
      child: Column(
        children: [
          SizedBox(height: 17),
          Row(children: <Widget>[
            Icon(
              icon_type,
              color: Colors.black,
              size: 28,
            ),
            SizedBox(width: 15),
            Text(
              btn_str,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ]),
          SizedBox(height: 17),
        ],
      ),
      textColor: Colors.black,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: () {
        if (btn_str == "Security") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SecurityPage()));
        } else if (btn_str == "Accessibility") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AccessibilityPage()));
        } else if (btn_str == "Invite Mates") {
        } else if (btn_str == "Notifications") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationPage()));
        } else if (btn_str == "About") {
        } else if (btn_str == "Log Out") {
          _logout();
        }
      },
    );
  }
}
