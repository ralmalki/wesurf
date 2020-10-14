import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
//import '../components/search-bar.dart';

void main() => runApp(MyApp());

/* Saved Spot Location Widget */
class LocationWidget extends StatelessWidget {
  LocationWidget({this.beachName, this.dangerLevel, this.distance});

  final String beachName;
  final int dangerLevel;
  final double distance;

  String getSafety(int dangerLevel) {
    if (dangerLevel > 0 && dangerLevel < 60) {
      return "Safe";
    } else if (dangerLevel > 0 && dangerLevel > 70) {
      return "Dangerous";
    } else if (dangerLevel < 70 && dangerLevel > 60) {
      return "Warning";
    } else {
      return "No data";
    }
  }

  String getSafetyFlagColor(int dangerLevel) {
    if (dangerLevel > 0 && dangerLevel < 70) {
      return "green";
    } else if (dangerLevel > 0 && dangerLevel > 70) {
      return "red";
    } else {
      return "white";
    }
  }

  Color getSafetyColor(int dangerLevel) {
    if (dangerLevel < 70 && dangerLevel > 60)
      return Colors.orange;
    else if (dangerLevel > 0 && dangerLevel < 60) return Colors.green;
  }

  // Returns widget for danger level

  Widget build(BuildContext context) {
    if (dangerLevel > 70) {
      return Container(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          decoration: BoxDecoration(
              color: Colors.red,
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
                  'assets/flag-red.png',
                  height: 43,
                  width: 43,
                )
              ]),
            ),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DANGEROUS!",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text(this.beachName,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Row(
                          children: [
                            Text(this.distance.toString() + " km",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ],
                        ))
                  ]),
            ),
            Spacer(),
            Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Icon(TablerIcons.dots)]))
          ]));
    } else {
      return Container(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
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
                  'assets/flag-' +
                      getSafetyFlagColor(this.dangerLevel) +
                      '.png',
                  height: 45,
                  width: 45,
                )
              ]),
            ),
            SizedBox(width: 4, height: 4),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(this.beachName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Row(
                          children: [
                            Text(this.distance.toString() + " km",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            Text("   ●   ",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                )),
                            Text(this.getSafety(this.dangerLevel),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: getSafetyColor(this.dangerLevel)))
                          ],
                        ))
                  ]),
            ),
            Spacer(),
            Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Icon(TablerIcons.dots)]))
          ]));
    }
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
  SavedSpot('Wollongong Beach', 67, 1),
];

/* Function to take the list of spots with bool value for safe or dangerous, and convert them to widgets to display */
List<Widget> getLocations(List<SavedSpot> spots, bool v) {
  List<Widget> list = new List<Widget>();
  if (v == true) {
    // if true, safe spot
    for (var i = 0; i < spots.length; i++) {
      if (spots[i].dangerLevel > 0 && spots[i].dangerLevel < 60) {
        list.add(LocationWidget(
            beachName: spots[i].name,
            dangerLevel: spots[i].dangerLevel,
            distance: spots[i].distance));
      }
    }
  } else {
    // else normal list
    for (var i = 0; i < spots.length; i++) {
      list.add(LocationWidget(
          beachName: spots[i].name,
          dangerLevel: spots[i].dangerLevel,
          distance: spots[i].distance));
    }
  }
  return list;
}

/* Generate the widgets to display on the page */
Widget createList(List<Widget> l, bool v) {
  return Column(children: [
    //SearchBar(),
    FilterAreaWidget(
      beachNum: spots.length,
    ),
    Container(
      child: Column(children: getLocations(spots, v)),
    )
  ]);
}

/* Filter Area Widget */
class FilterAreaWidget extends StatelessWidget {
  FilterAreaWidget({this.beachNum});
  final int beachNum;

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black26,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
      child: Row(
        children: [
          Text("Total " + this.beachNum.toString() + " spots",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15, color: Colors.black54)),
          Text("   ●   ",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 10, color: Colors.black54)),
          Text("Sort by: ",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15, color: Colors.black54)),
          dropdownWidget(),
        ],
      ),
    );
  }
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
        style: TextStyle(color: Colors.blue),
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
              SizedBox(
                width: 10,
              ),
              Text(
                option.name,
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LovedSpots(),
    );
  }
}

class LovedSpots extends StatefulWidget {
  @override
  _LovedSpotState createState() => _LovedSpotState();
}

class _LovedSpotState extends State {
  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Loved Spots",
              style: TextStyle(
                  color: Color.fromRGBO(255, 45, 87, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(TablerIcons.chevron_left),
            color: Color.fromRGBO(255, 45, 87, 1),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              children: [
                _buildSwitch(),
                _buildResultArea(switchValue),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildSwitch() {
    return Container(
        child: Row(
      children: [
        Text("Only safe spots",
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.black54)),
        Align(
          child: Transform.scale(
              scale: 0.7,
              child: Container(
                alignment: Alignment.topRight,
                child: CupertinoSwitch(
                  value: switchValue,
                  onChanged: _updateSwitch,
                ),
              )),
        )
      ],
    ));
  }

  Widget _buildResultArea(bool v) {
    return Column(
      children: [createList(getLocations(spots, v), v)],
    );
  }

  void _updateSwitch(bool newValue) {
    setState(() {
      switchValue = newValue;
    });
  }
}
