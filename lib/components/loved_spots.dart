import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wesurf/backend/user_data.dart';
import 'package:wesurf/backend/location_data.dart';

class LovedSpots extends StatefulWidget {
  @override
  _LovedSpotState createState() => _LovedSpotState();
}

class _LovedSpotState extends State {
  // Safe Spot Switch
  bool switchValue = false;

  // List<SavedSpot> spots = <SavedSpot>[
  //   SavedSpot('Fairy Meadow Beach', true),
  //   SavedSpot('North Wollongong Beach', false),
  //   SavedSpot('Towradgi Beach', true),
  //   SavedSpot('Warilla Beach', false),
  //   SavedSpot('Wollongong Beach', true),
  // ];

  Future<List> fetchFavSpots() async {
    Firebase.initializeApp();
    CollectionReference locationCollection = FirebaseFirestore.instance.collection('locations');

    List<dynamic> favSpots =
      await UserData(uid: FirebaseAuth.instance.currentUser.uid).getFavSpots();

    List<SavedSpot> savedSpotList = List<SavedSpot>();
    for (var spotUID in favSpots) {
      LocationData location = LocationData(locationUID: spotUID);
      String spotName = await location.getLocationName();
      bool dangerous = await location.getDangerous();
      savedSpotList.add(SavedSpot(spotName, dangerous));
    }
    return savedSpotList;
  }

  @override
  void initState() {
    fetchFavSpots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text('Back',
                  style: TextStyle(
                      color: Color(0xFFFC2D54), fontWeight: FontWeight.w700))
            ]),
          ),
        ]),
        leadingWidth: 135,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFF2F2F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 00, 10, 10),
            child: Column(
              children: [
                // Main function
                _buildResultArea(switchValue),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildResultArea(bool v) {
    return FutureBuilder(
      future: fetchFavSpots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return createList(getLocations(snapshot.data, v), v);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  /* Generate the widgets to display on the page */
  Widget createList(List<Widget> widget_list, bool v) {
    return Column(children: [
      SearchBarLovedSpots(),
      buildFilterArea(
        widget_list.length,
      ),
      Container(
        child: Column(children: widget_list),
      )
    ]);
  }

/* Function to take the list of spots with bool value for safe or dangerous, and convert them to widgets to display */
  List<Widget> getLocations(List<SavedSpot> spots, bool v) {
    List<Widget> list = new List<Widget>();
    if (v == true) {
      // if true, safe spot
      for (var i = 0; i < spots.length; i++) {
        if (!spots[i].dangerous) {
          list.add(LocationWidget(
              spots[i].name, spots[i].dangerous));
        }
      }
    } else {
      // else normal list
      for (var i = 0; i < spots.length; i++) {
        list.add(LocationWidget(
            spots[i].name, spots[i].dangerous));
      }
    }
    return list;
  }

  /* Update switch value */
  void _updateSwitch(bool newValue) {
    setState(() {
      switchValue = newValue;
    });
  }

  /* Function returning the filter area widget */
  // takes the number of saved locations of the user as a parameter
  // has main switch
  Widget buildFilterArea(int beachNum) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(218, 218, 219, 1),
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
      child: Row(
        children: [
          Text("Total " + beachNum.toString() + " spots",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 12, color: Colors.black38)),
          Text(" ● ",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 10, color: Colors.black38)),
          Text("Sort by: ",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 12, color: Colors.black38)),
          dropdownWidget(),
          Spacer(),
          Row(children: [
            Text(
              "Only safe spots",
              style: TextStyle(color: Colors.black38, fontSize: 12),
            ),
            Transform.scale(
                scale: 0.8,
                child: Switch(
                  inactiveTrackColor: Color.fromRGBO(215, 215, 213, 1),
                  value: switchValue,
                  onChanged: _updateSwitch,
                ))
          ])
        ],
      ),
    );
  }
}

/* Saved Spot Location Widget */
  Widget LocationWidget(String beachName, bool dangerous) {
    if (dangerous) {
      return Container(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
          padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 59, 48, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                child: Icon(TablerIcons.mood_sad, color: Colors.white),
              ),
            ),
            SizedBox(width: 5, height: 5),
            Container(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(beachName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white)),
                Container(
                    child: Row(
                      children: [
                        // Text(distance.toString() + " km",
                        //     textAlign: TextAlign.left,
                        //     style: TextStyle(fontSize: 12, color: Colors.white)),
                        // Text("   ●   ",
                        //     textAlign: TextAlign.left,
                        //     style: TextStyle(fontSize: 10, color: Colors.white)),
                        Text("Danger warning",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12, color: Colors.white))
                      ],
                    ))
              ]),
            ),
            Spacer(),
            Container(
              child: IconButton(
                icon: Icon(TablerIcons.dots),
                color: Colors.black,
                onPressed: () {
                  print("You Pressed the icon!");
                },
              ),
            )
          ]));
    } else {
      return Container(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
          padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                child: Icon(TablerIcons.mood_happy, color: Color(0XFF52DB69)),
              ),
            ),
            SizedBox(width: 5, height: 5),
            Container(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(beachName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    )),
                Container(
                    child: Row(
                      children: [
                        // Text(distance.toString() + " km",
                        //     textAlign: TextAlign.left,
                        //     style: TextStyle(
                        //       fontSize: 12,
                        //     )),
                        // Text("   ●   ",
                        //     textAlign: TextAlign.left,
                        //     style: TextStyle(
                        //       fontSize: 10,
                        //     )),
                        Text("Safe",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12, color: Color.fromRGBO(76, 217, 100, 1)))
                      ],
                    ))
              ]),
            ),
            Spacer(),
            Container(
              child: IconButton(
                icon: Icon(TablerIcons.dots),
                color: Colors.black,
                onPressed: () {},
              ),
            )
          ]));
    }
  }

/* Class SavedSpot and list of SavedSpot objects to populate widgets */
class SavedSpot {
  const SavedSpot(this.name, this.dangerous);
  final String name;
  final bool dangerous;
  // final double distance;
}

// List<SavedSpot> spots = <SavedSpot>[
//   SavedSpot('Wollongong Beach', 30, 1),
// ];

/* Search Bar */
Widget SearchBarLovedSpots() {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
    child: Container(
      height: 60.0,
      decoration: BoxDecoration(),
      child: CupertinoTextField(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(-2.3, 3), // changes position of shadow
                )
              ]),
          style: TextStyle(fontSize: 16.0),
          placeholder: "Search here",
          prefix: Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                TablerIcons.search,
                color: Colors.black,
              )),
          suffix: Padding(
              padding: EdgeInsets.all(15),
              child: Icon(
                TablerIcons.microphone,
                color: Colors.black,
              ))),
    ),
  );
}

/* Filter menu */

class Item {
  const Item(this.name);
  final String name;
}

class dropdownWidget extends StatefulWidget {
  dropdownWidget({Key key}) : super(key: key);
  @override
  _dropdownWidget createState() {
    return _dropdownWidget();
  }
}

class _dropdownWidget extends State<dropdownWidget> {
  Item selectedOption;
  List<Item> options = <Item>[
    const Item('Name A-Z'),
    const Item('Closest'),
    const Item('Safest'),
  ];
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Item>(
      hint: Text(
        "Select item",
        style: TextStyle(
            color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
      ),
      value: selectedOption,
      onChanged: (Item Value) {
        setState(() {
          selectedOption = Value;
        });
      },
      items: options.map((Item option) {
        return DropdownMenuItem<Item>(
          value: option,
          child: Row(
            children: <Widget>[
              Text(
                option.name,
                style: TextStyle(
                    color: Color.fromRGBO(0, 122, 255, 1),
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
