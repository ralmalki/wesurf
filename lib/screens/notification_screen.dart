import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:wesurf/components/loved_spots.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Widget _notification(String msg, int time, String color, Icon icon) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 6, 20, 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      /*boxShadow: [
            BoxShadow(
                color: Colors.white60.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 3))
          ]),*/
      child: Row(children: <Widget>[
        Container(margin: EdgeInsets.fromLTRB(3, 3, 10, 3), child: icon),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text(msg),
          Text('${time}m ago',
              style: TextStyle(
                  color: Color.fromRGBO(135, 135, 135, 1),
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
        ])
      ], mainAxisAlignment: MainAxisAlignment.start),
    );
  }

  Future<dynamic> getNotification() async {
    //Firebase.initializeApp();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    dynamic data = await _firestore.collection('locations').get();
    for (var spot in data) {
      print(spot.data);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
              title: Text(
                "Notifications",
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              backgroundColor: Colors.white,
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5),
                    child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        fillColor: Color.fromRGBO(255, 59, 48, 1),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(TablerIcons.heart,
                                    color: Colors
                                        .white)), //changed to filled heart
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                'Spots',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LovedSpots()));
                        }))
              ])),
      body: SingleChildScrollView(
        child: Container(
            color: Color.fromRGBO(242, 242, 247, 1),
            child: Column(children: <Widget>[
              SizedBox(height: 15),
              Text('NEW',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
              FutureBuilder(
                  future: getNotification(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    dynamic data = snapshot.data;
                    return Column(children: <Widget>[
                      for (var location in data) Text(location.toString())
                    ]);
                  }),
              SizedBox(height: 10),
              Text('EARLIER',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
              Column(children: <Widget>[])
            ])),
      ),
    ));
  }
}
