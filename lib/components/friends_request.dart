import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class FriendRequest extends StatefulWidget {
  @override
  FriendRequestState createState() => new FriendRequestState();
}

class FriendRequestState extends State<FriendRequest> {
  @override
  Widget build(BuildContext context) {
    double appbar_h = MediaQuery.of(context).size.height * 0.08;
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    double textfield_icon_size = screen_width * 0.06;
    return new Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(appbar_h),
          child: AppBar(
            title: Row(children: [
              SizedBox(
                width: 52,
              ),
              Column(children: [
                Text('Friend Requests',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700))
              ])
            ]),
            backgroundColor: Colors.white,
          )),
      body: Container(
          color: Color(0xFFF2F2F7),
          child: new ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                  color: Color(0xFFF2F2F7),
                  child: Column(children: [
                    Text(
                      "NEW",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    _RequestCard("Henry Pham", "assets/profile_pic3.png",
                        "Wollongong, NSW 2500", 1, "Decline", "Accept",
                        msg: "Hi! Let's be friend!",
                        request_sent_date: "1w ago"),
                    SizedBox(height: 20),
                    Text(
                      "ALL REQUESTS",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    _RequestCard("Sirio Duran", "assets/profile_pic4.png",
                        "Wollongong, NSW 2500", 1, "Decline", "Accept",
                        msg: "Hi mate, I want to be your friend!",
                        request_sent_date: "2w ago"),
                    SizedBox(height: 10),
                    _RequestCard("Olena Skienjo", "assets/profile_pic5.png",
                        "Wollongong, NSW 2500", 3, "Decline", "Accept",
                        msg: "Would you like to go surfing together",
                        request_sent_date: "2w ago"),
                    SizedBox(height: 20),
                    Text(
                      "SUGGESTED USERS",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    _RequestCard(
                      "Aiony Haust",
                      "assets/profile_pic6.png",
                      "Wollongong, NSW 2500",
                      26,
                      "Remove",
                      "Add Mate",
                    ),
                    SizedBox(height: 10),
                    _RequestCard("Stefan Uddie", "assets/profile_pic7.png",
                        "Wollongong, NSW 2500", 12, "Remove", "Add Mate"),
                  ])),
            ],
          )),
    );
  }

  Widget _RequestCard(String username, String profile_img, String location,
      int mutual_mate, String leftBtnStr, String rightBtnStr,
      {String msg = "", String request_sent_date = ""}) {
    return Column(
      children: [
        Container(
          height: 112,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            Row(
              children: <Widget>[
                SizedBox(width: 15),
                Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Image.asset(
                      profile_img,
                      height: 60,
                      width: 60,
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(height: 10),
                  Text(
                    username,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Lived in " + location,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                  Text(
                    mutual_mate.toString() +
                        " mutual mate · " +
                        request_sent_date,
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                  SizedBox(height: 5),
                  Text(
                    msg,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ]),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                _cancelBtn(context, leftBtnStr),
                _postBtn(context, rightBtnStr),
              ],
            ),
          ]),
        ),
      ],
    );
  }

  Widget _cancelBtn(BuildContext context, String btnStr) {
    return Container(
        height: 30,
        child: FlatButton(
          textColor: Color(0xFF1276FF),
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
              side: BorderSide(color: Color(0xFFD6D6D6))),
          child: Row(children: [
            SizedBox(
              width: 53,
            ),
            Text(
              btnStr,
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(
              width: 53,
            )
          ]),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ));
  }

  Widget _postBtn(BuildContext context, String btnStr) {
    double space = 55;
    if (btnStr == "Accept") {
      space = 56;
    }
    if (btnStr == "Add Mate") {
      space = 46;
    }
    return Container(
        height: 30,
        child: FlatButton(
          textColor: Colors.white,
          color: Color(0xFF1276FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
          ),
          child: Row(children: [
            SizedBox(
              width: space,
            ),
            Text(btnStr, style: TextStyle(fontSize: 13)),
            SizedBox(
              width: space,
            )
          ]),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ));
  }
}
