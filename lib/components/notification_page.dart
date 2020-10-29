import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);
  @override
  _NotificationPage createState() {
    return _NotificationPage();
  }
}

class _NotificationPage extends State<NotificationPage> {
  // Switch values for individual switches
  bool weatherForecastSwitch = false;
  bool weatherWarningSwitch = false;
  bool hazardWarningSwitch = false;
  bool newForumPostSwitch = false;
  // Main switch value
  bool isSwitched = false;

  // Set the values when changing state of individual switches
  bool _changed(String field, bool val) {
    switch (field) {
      case "Weather Forecast":
        {
          weatherForecastSwitch = val;
        }
        break;
      case "Weather Warning":
        {
          weatherWarningSwitch = val;
        }
        break;
      case "Hazard Warning":
        {
          hazardWarningSwitch = val;
        }
        break;
      case "New Forum Post":
        {
          newForumPostSwitch = val;
        }
        break;
      default:
        {}
        break;
    }
    ;
  }

  // Returns switch value for the different switches
  bool getValue(String str) {
    switch (str) {
      case "Weather Forecast":
        {
          return weatherForecastSwitch;
        }
        break;
      case "Weather Warning":
        {
          return weatherWarningSwitch;
        }
        break;
      case "Hazard Warning":
        {
          return hazardWarningSwitch;
        }
        break;
      case "New Forum Post":
        {
          return newForumPostSwitch;
        }
        break;
      default:
        {}
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new Row(children: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            textColor: Color(0xFF1A7EFF),
            child: Row(children: [
              Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: Color(0xFFFF1300),
              ),
              SizedBox(
                width: 1,
              ),
              Text('Settings',
                  style: TextStyle(
                      color: Color(0xFFFC2D54), fontWeight: FontWeight.w700))
            ]),
          ),
        ]),
        leadingWidth: 200,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
          color: Color(0xFFF2F2F7),
          child: new ListView(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  color: Color(0xFFF2F2F7),
                  child: Column(children: [
                    mainSwitch(),
                  ])),
              new Container(
                  margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                  child: new Column(
                    children: <Widget>[
                      isSwitched
                          ? new Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                new Expanded(
                                    flex: 11,
                                    child: Column(children: [
                                      individuals("Weather Forecast"),
                                      individuals("Weather Warning"),
                                      individuals("Hazard Warning"),
                                      individuals("New Forum Post"),
                                    ])),
                              ],
                            )
                          : new Container(),
                    ],
                  )),
            ],
          )),
    );
  }

  // Main notification setting
  Widget mainSwitch() {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(-0.2, 1.5), // changes position of shadow
              ),
            ]),
        child: Row(children: [
          Expanded(
              child: Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Allow Notifications",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("Get notified about updates from your loved spots",
                  style: TextStyle(fontSize: 12, color: Color(0xff75798C)))
            ]),
          )),
          // Second Col
          Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                      print(isSwitched);
                    });
                  },
                  activeTrackColor: Color(0xFF1276FF),
                  activeColor: Colors.white,
                )
              ]))
        ]));
  }

  // Individual notification settings
  Widget individuals(String str) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Row(children: [
          Expanded(
              child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(str,
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 14))
                ]),
          )),
          Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Switch(
                  value: getValue(str),
                  onChanged: (value) {
                    setState(() {
                      _changed(str, value);
                      print(getValue(str));
                    });
                  },
                  activeTrackColor: Color(0xFF1276FF),
                  activeColor: Colors.white,
                )
              ]))
        ]));
  }
}
