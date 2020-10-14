import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wesurf/components/tab_bar.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:http/http.dart';
import './new_post.dart';
import './report_danger.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class WeatherInformation extends StatelessWidget {
  WeatherInformation(this.id, this.lat, this.long);

  final String id;
  final lat;
  final long;
  dynamic locationData;

  _openMapForDirection(double lan, double lat) async {
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(lan, lat),
      title: "Ocean Beach",
    );
  }

  @override
  void initState() {
    locationData = getLocation();
    // Firebase.initializeApp();
    // User currentUser = FirebaseAuth.instance.currentUser;
    // print(currentUser.toString);
  }

  Future<dynamic> getLocation() async {
    Firebase.initializeApp();
    final _firebase = FirebaseFirestore.instance;
    dynamic data = _firebase.collection('locations').doc(id).get();
    return data;
  }

  Widget getSigns(List<String> signs) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < signs.length; i++) {
      list.add(new Image.asset('assets/${signs[i]}.png'));
      list.add(new SizedBox(width: 10.0));
    }
    return new Row(children: list);
  }

  @override
  Widget build(BuildContext context) {
    print("weather info lat: $lat, long: $long");
    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.2,
      maxChildSize: 0.94,
      expand: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            color: Colors.white,
          ),
          child: ListView.builder(
              controller: scrollController,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    Center(child: Icon(TablerIcons.minus)),
                    FutureBuilder(
                        future: getLocation(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          dynamic data;
                          bool safe = true;
                          List<String> signs = new List<String>();
                          if (snapshot.hasData) {
                            data = snapshot.data.data();

                            if (data['shark'] >= 2) {
                              safe = false;
                              signs.add('sharks');
                            }
                            if (data['bluebottle'] >= 2) {
                              safe = false;
                              signs.add('bluebottles');
                            }
                            if (data['current'] >= 2) {
                              safe = false;
                              signs.add('current');
                            }
                            if (data['wind'] >= 2) {
                              safe = false;
                              signs.add('winds');
                            }
                            if (data['wave'] >= 2) {
                              safe = false;
                              signs.add('waves');
                            }
                            if (data['uv'] >= 2) {
                              safe = false;
                              signs.add('UV');
                            }
                          }
                          return Container(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Wollongong Beach",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(TablerIcons.heart),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('12.6km'),
                                    Text(' • '),
                                    Text(
                                      safe ? "Safe" : "Warning",
                                      style: TextStyle(
                                          color:
                                              safe ? Colors.green : Colors.red),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: getSigns(signs)
                                    // Row(
                                    //   children: <Widget> [
                                    //     for (var sign in signs) {
                                    //       Image.asset('assets/$sign.png'),
                                    //     };
                                    //
                                    //     Image.asset(
                                    //       'assets/sharks.png',
                                    //       height: 40,
                                    //     ),
                                    //     SizedBox(
                                    //       width: 10.0,
                                    //     ),
                                    //     Image.asset(
                                    //       'assets/waves.png',
                                    //       height: 40,
                                    //     ),
                                    //     SizedBox(
                                    //       width: 10.0,
                                    //     ),
                                    //     Image.asset(
                                    //       'assets/current.png',
                                    //       height: 40,
                                    //     ),
                                    //   ],
                                    // ),
                                    ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 15, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _Btn(
                                          context,
                                          id,
                                          115,
                                          TablerIcons.alert_triangle,
                                          'Report',
                                          Colors.yellow,
                                          Colors.black),
                                      _Btn(
                                          context,
                                          id,
                                          125,
                                          TablerIcons.plus,
                                          'New Post',
                                          Colors.blue,
                                          Colors.white),
                                      GestureDetector(
                                        onTap: () async {
                                          final availableMaps =
                                              await MapLauncher.installedMaps;
                                          await availableMaps.first.showMarker(
                                            coords:
                                                Coords(-34.412040, 150.902282),
                                            title: "Ocean Beach",
                                          );
                                        },
                                        child: CustomButton(
                                          buttonIcon: TablerIcons.brand_safari,
                                          buttonLabel: 'Directions',
                                          buttonColor: Colors.white,
                                          textColor: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(child: TabBarWidget(lat, long)),
                                )
                              ],
                            ),
                          );
                        }),
                  ],
                );
              }),
        );
      },
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData buttonIcon;
  final String buttonLabel;
  final Color buttonColor;
  final Color textColor;

  CustomButton(
      {@required this.buttonIcon,
      @required this.buttonLabel,
      this.buttonColor,
      this.textColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: const Offset(0.0, 2.0),
            blurRadius: 5.0,
            spreadRadius: 1.0,
          ),
        ],
        color: buttonColor,
      ),
      child: Row(
        children: [
          Icon(
            buttonIcon,
            color: textColor,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            buttonLabel,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _Btn(
    BuildContext context,
    String id,
    double btn_width,
    final IconData buttonIcon,
    final String buttonLabel,
    final Color buttonColor,
    final Color textColor) {
  return Container(
      height: 45,
      width: btn_width,
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child: RaisedButton(
        textColor: textColor,
        color: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(children: <Widget>[
          Icon(
            buttonIcon,
            color: textColor,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(buttonLabel, style: TextStyle(fontWeight: FontWeight.w400))
        ]),
        onPressed: () {
          if (buttonIcon == TablerIcons.alert_triangle) {
            ReportDangerState reportDanger = new ReportDangerState(id: id);
            reportDanger.build(context);
          } else if (buttonIcon == TablerIcons.plus) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateNewPost()));
          }
        },
      ));
}
