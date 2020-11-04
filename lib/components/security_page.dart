import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import "package:flutter/material.dart";
import 'package:wesurf/backend/user_data.dart';

class SecurityPage extends StatefulWidget {
  @override
  SecurityPageState createState() => new SecurityPageState();
}

class SecurityPageState extends State<SecurityPage> {
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

  Future<void> sendRestEmail() async {
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String email = user.email;
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }
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
                size: 17,
                color: Color(0xFFFF1300),
              ),
              SizedBox(
                width: 5,
              ),
              Text('Settings',
                  style: TextStyle(
                      color: Color(0xFFFC2D54), fontWeight: FontWeight.w700))
            ]),
          ),
        ]),
        leadingWidth: 120,
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
                    _loginInfoBtn("Save Login Information"),
                    SizedBox(
                      height: 20,
                    ),
                    _changePwdBtn("Change Password"),
                    SizedBox(
                      height: 25,
                    ),
                  ])),
              new Container(
                  margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                  child: new Column(
                    children: <Widget>[
                      visibilityObs
                          ? new Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                new Expanded(
                                    flex: 11,
                                    child: Column(children: [
                                      Text('PASSWORD',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 9,
                                              color: Color(0xff898989))),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      _textfield(
                                          "Current Password",
                                          currentPwdController,
                                          textfield_icon_size,
                                          Icons.lock_outline),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      _save_btn("Send Reset Email"),
                                      SizedBox(
                                        height: 230,
                                      ),
                                      _resetPwd(),
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

  Widget _textfield(
      String labelString,
      TextEditingController textfieldController,
      double textfield_icon_size,
      IconData iconType,
      {bool isPassword = false}) {
    return new TextField(
      style: TextStyle(height: 0.5, color: Colors.black),
      controller: textfieldController,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(
          iconType,
          size: textfield_icon_size,
        ),
        fillColor: Colors.white,
        filled: true,
        labelText: labelString,
        isDense: true,
        labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xffB0B0B8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _changePwdBtn(String btn_str) {
    return FlatButton(
      child: Column(
        children: [
          SizedBox(height: 17),
          Row(children: <Widget>[
            Text(
              btn_str,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
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
        visibilityObs ? null : _changed(true, "obs");
      },
    );
  }

  Widget _save_btn(String btn_str) {
    return FlatButton(
      child: Column(
        children: [
          SizedBox(height: 17),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              btn_str,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ]),
          SizedBox(height: 17),
        ],
      ),
      textColor: Colors.white,
      color: Color(0xFF1276FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: () {
        sendRestEmail();
        showAlertDialog(context, "Password rest",
            "An email has been sent to you. Please follow the steps to reset your password");
      },
    );
  }

  Widget _resetPwd() {
    double pad_left = MediaQuery.of(context).size.width * 0.17;
    double pad_top = MediaQuery.of(context).size.height * 0.0056;
    return Container(
        padding: EdgeInsets.only(left: pad_left, top: pad_top),
        child: Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 22),
              Text(
                "Forgot password?",
                style: TextStyle(color: Color(0xFF999999), fontSize: 12),
              ),
              SizedBox(width: 3),
              FlatButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {},
                textColor: Color(0xFF3478F6),
                child: Container(
                    margin: const EdgeInsets.all(0),
                    child: Text('Reset by Email',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold))),
              )
            ]));
  }

  Widget _loginInfoBtn(String str) {
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                //crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(str,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        SizedBox(height: 3),
                        Text("Remember your account on this device",
                            style: TextStyle(
                                color: Color(0xff75798C),
                                fontSize: 12,
                                fontWeight: FontWeight.w300)),
                        SizedBox(height: 10),
                      ]),
                  SizedBox(
                    width: 64,
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
}
