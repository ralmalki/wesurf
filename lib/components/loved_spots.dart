import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class LovedSpots extends StatefulWidget {
  @override
  _LovedSpotState createState() => _LovedSpotState();
}

class _LovedSpotState extends State {
  // Safe Spot Switch
  bool switchValue = false;
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
    return Column(
      children: [
        // Generate widgets based on whether only safe spots or not
        createList(getLocations(spots, v), v)
      ],
    );
  }

  /* Generate the widgets to display on the page */
  Widget createList(List<Widget> widget_list, bool v) {
    return Column(children: [
      SearchBarLovedSpots(),
      buildFilterArea(
        spots.length,
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
        if (spots[i].dangerLevel > 0 && spots[i].dangerLevel < 60) {
          list.add(LocationWidget(
              spots[i].name, spots[i].dangerLevel, spots[i].distance));
        }
      }
    } else {
      // else normal list
      for (var i = 0; i < spots.length; i++) {
        list.add(LocationWidget(
            spots[i].name, spots[i].dangerLevel, spots[i].distance));
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
Widget LocationWidget(String beachName, int dangerLevel, double distance) {
  String getSafety(int dangerLevel) {
    if (dangerLevel > 0 && dangerLevel < 60) {
      return "Safe";
    } else if (dangerLevel > 0 && dangerLevel > 70) {
      return "Danger Warning";
    } else if (dangerLevel < 70 && dangerLevel > 60) {
      return "Warning";
    } else {
      return "No data";
    }
  }

  // Gets the image for danger level
  String getSmiley(int dangerLevel) {
    if (dangerLevel > 0 && dangerLevel > 70) {
      return 'assets/face-sad-white.png';
    } else if (dangerLevel > 0 && dangerLevel < 60) {
      return 'assets/face-smile-green.png';
    } else if (dangerLevel < 70 && dangerLevel > 60) {
      return 'assets/face-neutral-orange.png';
    } else {
      return "white";
    }
  }

  // Gets colour for text
  Color getSafetyColor(int dangerLevel) {
    if (dangerLevel < 70 && dangerLevel > 60)
      return Color.fromRGBO(255, 164, 53, 1);
    else if (dangerLevel > 0 && dangerLevel < 60)
      return Color.fromRGBO(76, 217, 100, 1);
  }

  if (dangerLevel > 70) {
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
          Container(
            child: Column(children: [
              Image.asset(
                'assets/face-sad-white.png',
                height: 40,
                width: 40,
              )
            ]),
          ),
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
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      Text(distance.toString() + " km",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                      Text("   ●   ",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 10, color: Colors.white)),
                      Text(getSafety(dangerLevel),
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
          Container(
            child: Column(children: [
              Image.asset(
                getSmiley(dangerLevel),
                height: 40,
                width: 40,
              )
            ]),
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
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    children: [
                      Text(distance.toString() + " km",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                          )),
                      Text("   ●   ",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 10,
                          )),
                      Text(getSafety(dangerLevel),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12, color: getSafetyColor(dangerLevel)))
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
  const SavedSpot(this.name, this.dangerLevel, this.distance);
  final String name;
  final int dangerLevel;
  final double distance;
}

List<SavedSpot> spots = <SavedSpot>[
  SavedSpot('Fairy Meadow Beach', 19, 2),
  SavedSpot('North Wollongong Beach', 79, 0.95),
  SavedSpot('Towradgi Beach', 77, 12.6),
  SavedSpot('Warilla Beach', 0, 15),
  SavedSpot('Wollongong Beach', 30, 1),
];

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
