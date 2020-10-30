import 'package:flutter/material.dart';
import 'package:kumi_popup_window/kumi_popup_window.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/cupertino.dart';
import './new_post.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportDanger extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ReportDangerState();
  }
}

class ReportDangerState extends State<ReportDanger> {
  ReportDangerState({this.id});
  final String id;

  GlobalKey btnKey = GlobalKey();
  KumiPopupWindow popupWindow;
  String beach_info = "Towradgi Beach";
  String btn_click = "false";

  final ValueNotifier<bool> sharkHasBeenPressed = ValueNotifier(false);
  final ValueNotifier<bool> bbHasBeenPressed = ValueNotifier(false);
  final ValueNotifier<bool> uwHasBeenPressed = ValueNotifier(false);
  final ValueNotifier<bool> windHasBeenPressed = ValueNotifier(false);
  final ValueNotifier<bool> scHasBeenPressed = ValueNotifier(false);
  final ValueNotifier<bool> huvHasBeenPressed = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    //_hasBeenPressed = false;
    return Scaffold(
        body: showPopupWindow(
      context,
      gravity: KumiPopupGravity.center,
      bgColor: Colors.grey.withOpacity(0.5),
      clickOutDismiss: true,
      clickBackDismiss: true,
      customAnimation: false,
      customPop: false,
      customPage: false,
      underStatusBar: false,
      underAppBar: true,
      offsetX: 5,
      offsetY: 5,
      duration: Duration(milliseconds: 200),
      childFun: (pop) {
        return GestureDetector(
          key: GlobalKey(),
          onTap: () {
            isSelect.value = !isSelect.value;
          },
          child: new Container(
            padding: EdgeInsets.all(0),
            height: 360,
            width: 370,
            color: Colors.white,
            alignment: Alignment.center,
            child: ValueListenableBuilder(
                valueListenable: isSelect,
                builder: (context, bool select, child) {
                  return Column(children: <Widget>[
                    _title("Report"),
                    _beachInfo(beach_info),
                    _reportTypeTable(context),
                    _divider(),
                    Container(
                      height: 20,
                      child: new SizedBox(
                          height: 40,
                          width: 370.0,
                          child: FlatButton(
                            onPressed: () {
                              pop.dismiss(context);

                              //Firebase.initializeApp();
                              final _firestore = FirebaseFirestore.instance;

                              if (sharkHasBeenPressed.value == true) {
                                print("shark btn pressed: " +
                                    sharkHasBeenPressed.value.toString());
                                _firestore
                                    .collection('locations')
                                    .doc(id)
                                    .update({'shark': FieldValue.increment(1)});
                              }
                              if (bbHasBeenPressed.value == true) {
                                print("blue bottle btn pressed: " +
                                    bbHasBeenPressed.value.toString());
                                _firestore
                                    .collection('locations')
                                    .doc(id)
                                    .update({
                                  'bluebottle': FieldValue.increment(1)
                                });
                              }
                              if (uwHasBeenPressed.value == true) {
                                print("unexpected waves btn pressed: " +
                                    uwHasBeenPressed.value.toString());
                                _firestore
                                    .collection('locations')
                                    .doc(id)
                                    .update({'wave': FieldValue.increment(1)});
                              }
                              if (windHasBeenPressed.value == true) {
                                print("winds btn pressed: " +
                                    windHasBeenPressed.value.toString());
                                _firestore
                                    .collection('locations')
                                    .doc(id)
                                    .update({'wind': FieldValue.increment(1)});
                              }
                              if (scHasBeenPressed.value == true) {
                                print("strong current btn pressed: " +
                                    scHasBeenPressed.value.toString());
                                _firestore
                                    .collection('locations')
                                    .doc(id)
                                    .update(
                                        {'current': FieldValue.increment(1)});
                              }
                              if (huvHasBeenPressed.value == true) {
                                print("high uv btn pressed: " +
                                    huvHasBeenPressed.value.toString());
                                _firestore
                                    .collection('locations')
                                    .doc(id)
                                    .update({'uv': FieldValue.increment(1)});
                              }

                              print("\n");
                            },
                            textColor: Color(0xFF343434),
                            child: Text('Close', style: TextStyle()),
                          )),
                    ),
                  ]);
                }),
          ),
        );
      },
    ));
  }

  Widget _title(String title_str) {
    return Container(
        width: 370,
        height: 40,
        color: Color(0xFFF9F016),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(TablerIcons.alert_triangle),
          SizedBox(width: 5),
          Text(title_str, style: TextStyle(fontSize: 16))
        ]));
  }

  Widget _beachInfo(String beach_info) {
    return Container(
        width: 360,
        height: 40,
        padding: EdgeInsets.only(top: 10, bottom: 5),
        child: Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 12),
              Icon(
                TablerIcons.map_pin,
                color: Color(0xFF2888FF),
              ),
              SizedBox(width: 5),
              Text(beach_info,
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2888FF),
                      fontWeight: FontWeight.w500))
            ]));
  }

  Widget _typeBtn(
      BuildContext context,
      final ValueNotifier<bool> hasBeenPressed,
      String btnStr,
      String imgPath,
      double padding_right,
      double space) {
    return Container(
        height: 85,
        width: 115,
        padding: EdgeInsets.only(top: 5, left: 10, right: padding_right),
        child: ValueListenableBuilder(
            valueListenable: hasBeenPressed,
            builder: (context, bool pressed, child) {
              return RaisedButton(
                textColor: Colors.black,
                elevation: 4.0,
                color: hasBeenPressed.value ? Colors.red : Color(0xFFF2F2F7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(children: <Widget>[
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      btnStr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                      ),
                    ),
                  ),
                  SizedBox(height: space),
                  Image.asset(
                    imgPath,
                    height: 45,
                    width: 45,
                  ) //height:45,width: 45,
                ]),
                onPressed: () {
                  _handleClickMe(context, hasBeenPressed, btnStr);
                },
              );
            }));
  }

  Widget _reportTypeTable(BuildContext context) {
    return Container(
        width: 370,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            _typeBtn(context, sharkHasBeenPressed, "SHARKS",
                "assets/sharks.png", 0, 15),
            SizedBox(width: 5),
            _typeBtn(context, bbHasBeenPressed, "BLUEBOTTLES",
                "assets/bluebottles.png", 0, 15),
            SizedBox(width: 5),
            _typeBtn(context, uwHasBeenPressed, "UNEXPECTED WAVES",
                "assets/waves.png", 5, 5), //UNEXPECTED WAVES
          ]),
          SizedBox(height: 10),
          Row(children: <Widget>[
            _typeBtn(context, windHasBeenPressed, "WINDS", "assets/winds.png",
                0, 15),
            SizedBox(width: 5),
            _typeBtn(context, scHasBeenPressed, "STRONG CURRENTS",
                "assets/current.png", 0, 5),
            SizedBox(width: 5),
            _typeBtn(
                context, huvHasBeenPressed, "HIGH UV", "assets/UV.png", 5, 15),
          ]),
          SizedBox(height: 5),
          Row(children: <Widget>[
            SizedBox(width: 10),
            Text(
              "Other danger?",
              style: TextStyle(color: Color(0xFF999999), fontSize: 13),
            ),
            FlatButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateNewPost(id)));
              },
              textColor: Color(0xFF3478F6),
              child: Container(
                  margin: const EdgeInsets.all(0),
                  child: Text('Create Post',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold))),
            )
          ]),
        ]));
  }

  Widget _divider() {
    return Container(
        padding: EdgeInsets.all(0),
        child: Divider(
          color: Color(0xFFD6D6D6),
          thickness: 1,
        ));
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String s(String str) {
    String ori_str = str.toLowerCase();
    String caplitalise = ori_str[0].toUpperCase() + ori_str.substring(1);
    return caplitalise;
  }

  Future<void> _handleClickMe(BuildContext context,
      final ValueNotifier<bool> hasBeenPressed, String report_type) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CupertinoAlertDialog(
            title: Text(""),
            content: Text(
                'Add an alert for ' +
                    s(report_type) +
                    " at " +
                    beach_info +
                    " ?",
                style: TextStyle(fontSize: 14)),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text('Confirm'),
                onPressed: () {
                  hasBeenPressed.value = !hasBeenPressed.value;
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        ]);
      },
    );
  }

  ValueNotifier<bool> isSelect = ValueNotifier(false);

// Future<int> getData(String record) async{
//   await Firebase.initializeApp();
//   final _firestore = FirebaseFirestore.instance;
//   final doc = _firestore.collection('locations').doc(id).get();
//   print();
//   return 0;
// }

}
