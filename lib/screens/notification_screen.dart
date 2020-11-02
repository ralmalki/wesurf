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

  //get the difference in time
  String timeFromNow(String t) {
    DateTime timestamp = DateTime.parse(t);
    Duration duration = DateTime.now().difference(timestamp);
    if (duration.inSeconds > 60) {
      if (duration.inMinutes > 60) {
        if (duration.inHours > 24) {
          return '${duration.inDays} days ago';
        }
        else
          return '${duration.inHours} hours ago';
      }
      else
        return '${duration.inMinutes} minutes ago';
    }
    return 'Just now';
  }

  List<Widget> newNotification() {
    List<Widget> notification = List<Widget>();
    notification.add(_notification(
        RichText(
          text: TextSpan(
              style: TextStyle(fontSize: 14, color: Colors.black),
              text: "New forum post at ",
              children: <TextSpan>[
                TextSpan(
                    style: TextStyle(fontSize: 14,  fontWeight: FontWeight.bold),
                    text: "Towradgi Beach "),
              ]
          ),
        ),
        "1h ago",
        Colors.white,
        Colors.grey,
        Icon(TablerIcons.inbox, size: 24)
    ));
    notification.add(_notification(
        RichText(
          text: TextSpan(
              style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
              text: "Anna Johnson ",
              children: <TextSpan>[
                TextSpan(
                    style: TextStyle(fontSize: 14,  fontWeight: FontWeight.normal),
                    text: "commented on your post "),
              ]
          ),
        ),
        "2h ago",
        Colors.white,
        Colors.grey,
        Icon(TablerIcons.message_circle, size: 24)
    ));

    return notification;
  }
  List<Widget> earlierNotification() {
    List<Widget> notification = List<Widget>();
    notification.add(_notification(
        RichText(
          text: TextSpan(
              style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
              text: "John Doe ",
              children: <TextSpan>[
                TextSpan(
                    style: TextStyle(fontSize: 14,  fontWeight: FontWeight.normal),
                    text: "commented on your post "),
              ]
          ),
        ),
        "4h ago",
        Colors.white,
        Colors.grey,
        Icon(TablerIcons.message_circle, size: 24)
    ));
    notification.add(_notification(
        RichText(
          text: TextSpan(
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              text: "Shark ",
              children: <TextSpan>[
                TextSpan(
                    style: TextStyle(fontSize: 14,  fontWeight: FontWeight.normal),
                    text: "danger alert at "),
                TextSpan(
                    style: TextStyle(fontSize: 14),
                    text: "North Wollongong Beach"),
              ]
          ),
        ),
        "5m ago",
        Colors.red,
        Colors.white,
        Image.asset('assets/sharks.png', height: 24, width: 24)
    ));
    notification.add(_notification(
        RichText(
          text: TextSpan(
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              text: "Strong current ",
              children: <TextSpan>[
                TextSpan(
                    style: TextStyle(fontSize: 14,  fontWeight: FontWeight.normal),
                    text: "danger alert at "),
                TextSpan(
                    style: TextStyle(fontSize: 14),
                    text: "Towradgi Beach"),
              ]
          ),
        ),
        "6m ago",
        Colors.red,
        Colors.white,
        Image.asset('assets/current.png', height: 24, width: 24)
    ));
    return notification;
  }

  Widget _notification(RichText msg, String time, Color background, Color text, Widget icon) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 6, 10, 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: background,
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
          msg,
          Text(time,
              style: TextStyle(
                  color: text,
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
        ])
      ], mainAxisAlignment: MainAxisAlignment.start),
    );
  }

  Future<dynamic> getNotification() async {
    Firebase.initializeApp();
    var data;
    var locationInstance = FirebaseFirestore.instance.collection('locations');
    await locationInstance.get().then((value) async {
      for (var location in value.docs) {
        for (var notification in location.data()['notification']) {
          DateTime dateTime = DateTime(notification['time']);
          //print(dateTime);
          //print(notification);
        }
      }
    });
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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
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
                    // return Column(children: <Widget>[
                    //   for (var location in data) Text(location.toString())
                    // ]);
                    return Column(
                      children: newNotification()
                    );
                  }),
              SizedBox(height: 10),
              Text('EARLIER',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
              Column(children: earlierNotification())
            ])),
      ),
    ));
  }
}
