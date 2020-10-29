import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class AccessibilityPage extends StatefulWidget {
  @override
  AccessibilityPageState createState() => new AccessibilityPageState();
}

class AccessibilityPageState extends State<AccessibilityPage> {
  bool visibilityTag = false;
  bool visibilityObs = false;
  bool isSwitched = false;
  TextEditingController currentPwdController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirdPwdController = TextEditingController();
  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "tag") {
        visibilityTag = visibility;
      }
      if (field == "obs") {
        visibilityObs = visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    double textfield_icon_size = screen_width * 0.06;
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
                    _switchBtn("High Contrast Theme"),
                  ])),
            ],
          )),
    );
  }

  Widget _switchBtn(String str) {
    return RaisedButton(
      textColor: Colors.black,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 10),
                Text(str,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
              ]),
              SizedBox(
                width: 133,
              ),
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
              ),
            ]),
          ],
        ),
      ),
      onPressed: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      },
    );
  }
}
