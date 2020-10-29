import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:wesurf/components/friends_request.dart';

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  bool visibilityTag = false;
  bool visibilityObs = false;
  bool isSwitched = false;

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
            leading: new Row(children: [
              SizedBox(
                width: 20,
              ),
              Column(children: [
                SizedBox(
                  height: 20,
                ),
                Text('Mates',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w700))
              ])
            ]),
            leadingWidth: 130,
            backgroundColor: Colors.white,
            actions: <Widget>[
              Container(
                width: 148,
                padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FriendRequest()));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textColor: Color(0xFF1A7EFF),
                  color: Color(0xFF1276FF),
                  child: Row(children: [
                    Icon(
                      TablerIcons.mail,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Column(children: [
                      SizedBox(height: 5),
                      Text("Friend", style: TextStyle(color: Colors.white)),
                      Text("Requests", style: TextStyle(color: Colors.white)),
                    ])
                  ]),
                ),
              ),
            ],
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
                    _searchBar(),
                    //SizedBox(height:20),

                    /*  Text("NEW",style: TextStyle(color:Colors.grey[500], fontSize:10, fontWeight:FontWeight.bold),),
                  SizedBox(height:5),
                  _RequestCard("Henry Pham","assets/profile_pic3.png","Wollongong, NSW 2500", 1,"Decline","Accept" ,msg:"Hi! Let's be friend!",request_sent_date: "1w ago"),
                  SizedBox(height:20),

                  Text("ALL REQUESTS",style: TextStyle(color:Colors.grey[500], fontSize:10, fontWeight:FontWeight.bold),),
                  SizedBox(height:5),
                  _RequestCard("Sirio Duran","assets/profile_pic4.png","Wollongong, NSW 2500", 1,"Decline","Accept" ,msg:"Hi mate, I want to be your friend!",request_sent_date: "2w ago"),
                  SizedBox(height:10),
                  _RequestCard("Olena Skienjo","assets/profile_pic5.png","Wollongong, NSW 2500", 3, "Decline","Accept" ,msg:"Would you like to go surfing together",request_sent_date: "2w ago"),
                  SizedBox(height:20),

                  Text("SUGGESTED USERS",style: TextStyle(color:Colors.grey[500], fontSize:10, fontWeight:FontWeight.bold),),
                  SizedBox(height:5),
                  _RequestCard("Aiony Haust","assets/profile_pic6.png","Wollongong, NSW 2500", 26, "Remove","Add Mate",),
                  SizedBox(height:10),
                  _RequestCard("Stefan Uddie","assets/profile_pic7.png","Wollongong, NSW 2500", 12,"Remove","Add Mate" ),*/
                  ])),
              Container(
                padding: EdgeInsets.fromLTRB(20, 8, 0, 0),
                child: Row(
                  children: [
                    Text("Total 30 mates · Sort by ",
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 11)),
                    SizedBox(width: 5),
                    DropDown(),
                    SizedBox(width: 35),
                    _switchBtn(),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Divider(
                    color: Colors.grey[700],
                    thickness: 0.3,
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      _FriendCard(
                          "Willy Dade", "assets/profile_pic.png", 23, "Online"),
                      SizedBox(
                        height: 15,
                      ),
                      _FriendCard("Black Cheek", "assets/profile_pic2.png", 23,
                          "Offline"),
                      SizedBox(
                        height: 15,
                      ),
                      _FriendCard("Catherine Health", "assets/profile_pic3.png",
                          23, "Offline"),
                      SizedBox(
                        height: 15,
                      ),
                      _FriendCard("Sharon Christena Rorvik",
                          "assets/profile_pic4.png", 23, "Offline"),
                      SizedBox(
                        height: 15,
                      ),
                      _FriendCard("Kodi Petty", "assets/profile_pic5.png", 23,
                          "Online"),
                      SizedBox(
                        height: 15,
                      ),
                      _FriendCard("Rhian Forrest", "assets/profile_pic6.png",
                          23, "Offline"),
                      SizedBox(
                        height: 15,
                      ),
                      _FriendCard("Christopher Chambel",
                          "assets/profile_pic7.png", 23, "Online"),
                      SizedBox(
                        height: 15,
                      ),
                      _FriendCard("Sharon Christena Rorvik",
                          "assets/profile_pic6.png", 23, "Offline"),
                      SizedBox(
                        height: 15,
                      ),
                      _FriendCard("Kodi Petty", "assets/profile_pic3.png", 23,
                          "Online"),
                      SizedBox(
                        height: 15,
                      ),
                      _FriendCard("Rhian Forrest", "assets/profile_pic4.png",
                          23, "Offline"),
                    ],
                  )),
            ],
          )),
    );
  }

  Widget _searchBar() {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: const Offset(0.0, 2.0),
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
              borderSide: BorderSide(style: BorderStyle.none, width: 0),
            ),
            hintText: 'Search here',
            prefixIcon: Icon(
              TablerIcons.search,
              color: Colors.black,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _switchBtn() {
    return Row(
      children: [
        Text("Only online",
            style: TextStyle(color: Colors.grey[600], fontSize: 11)),
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
      ],
    );
  }

  String dropdownValue = 'Newest First';
  Widget DropDown() {
    return DropdownButton<String>(
      value: dropdownValue,
      //elevation: 6,
      style: TextStyle(
          fontSize: 10, color: Color(0xFF1276FF), fontWeight: FontWeight.bold),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Newest First', 'Name Z-A', 'Name A-Z']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _FriendCard(String username, String profile_img, int mutual_mate,
      String onlineStatus) {
    Color statusColor = Colors.white;
    if (onlineStatus == "Online") {
      statusColor = Color(0xff76D672);
    } else if (onlineStatus == "Offline") {
      statusColor = Color(0xffEB4D3D);
    }

    return Column(
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400],
                blurRadius: 2.0, // soften the shadow
                spreadRadius: 1.0, //extend the shadow
                offset: Offset(
                  1.0, // Move to right 10  horizontally
                  1.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: [
                  SizedBox(width: 15),
                  Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        profile_img,
                        height: 38,
                        width: 38,
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          username,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              mutual_mate.toString() + " mutual mate · ",
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey[600]),
                            ),
                            Text(
                              onlineStatus,
                              style:
                                  TextStyle(fontSize: 11, color: statusColor),
                            ),
                            SizedBox(height: 5),
                          ],
                        )
                      ]),
                ]),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ),
      ],
    );
  }
}
