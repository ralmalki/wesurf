import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

//import '../backend/network.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:wesurf/components/daily_forecast.dart';

import 'forecast_widget.dart';

class TabBarWidget extends StatefulWidget {
  TabBarWidget(this.lat, this.long);
  final lat;
  final long;

  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  bool tapped = false;
  TextEditingController commentController = TextEditingController();
  String appid = "1e884f92b81b9b1eb0c42487fe6e1584";
  Icon mood_happy =
      Icon(TablerIcons.mood_happy, size: 15, color: Color(0xff4CD964));

  Icon mood_neutral =
      Icon(TablerIcons.mood_neutral, size: 15, color: Color(0XFFFE9E12));

  Icon mood_sad = Icon(TablerIcons.mood_sad, size: 15, color: Colors.red);

  double lat;
  double long;

  Future<String> getForecast() async {
    String url =
        "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$long&appid=$appid&units=metric";

    Response response = await get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      return data;
    } else {
      print("error");
      return null;
    }
  }

  Image getWeatherIcon(int weatherCode) {
    String weatherCondition = "";
    if (weatherCode >= 200 && weatherCode <= 299)
      weatherCondition = "storm";
    else if (weatherCode >= 300 && weatherCode <= 399)
      weatherCondition = "drizzle";
    else if (weatherCode >= 500 && weatherCode <= 599)
      weatherCondition = "rain";
    else
      weatherCondition = "cloudy";

    return Image.asset(
      'assets/weather-$weatherCondition.png',
      height: 100,
      width: 100,
      fit: BoxFit.fitWidth,
    );
  }

  @override
  void initState() {
    super.initState();
    print("lat: ${widget.lat}, long: ${widget.long}");
    lat = widget.lat;
    long = widget.long;
  }

  @override
  Widget build(BuildContext context) {
    //print("tab-bar lat: $lat, long: $long");
    //NetworkHelper helper = NetworkHelper(lat, long);
    //dailyForecast = helper.getDaily();
    return Container(
        child: FutureBuilder(
      future: getForecast(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          dynamic data = jsonDecode(snapshot.data);

          int currentTemp = data['current']['temp'].round();
          int tempHigh = data['daily'][0]['temp']['max'].round();
          int tempLow = data['daily'][0]['temp']['min'].round();
          int pop = data['hourly'][0]['pop'].toInt();
          int humidity = data['current']['humidity'].toInt();
          String sky = data['current']['weather'][0]['main'];
          String skyDisc = data['current']['weather'][0]['description'];
          int weatherId = data['current']['weather'][0]['id'];
          int windSpeed = (data['current']['wind_speed'] * 3.6).round();
          int windDirection = data['current']['wind_deg'].toInt();
          int uv = data['current']['uvi'].toInt();

          return DefaultTabController(
            length: 3,
            child: SizedBox(
              height: 800.0,
              child: Column(
                children: <Widget>[
                  TabBar(
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          "TODAY",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "FORECAST",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "FORUM",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        Container(
                          //width: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 15.0),
                                child: Text(
                                  "NOW",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    getWeatherIcon(weatherId),
                                    Text(
                                      "$currentTemp℃",
                                      style: TextStyle(fontSize: 90.0),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                                child: Text("High $tempHigh℃ • Low $tempLow℃",
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Text(
                                  "$sky • $skyDisc",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              WeatherBreakDown(
                                iconData: TablerIcons.droplet,
                                label: "Chance of Rain",
                                result: "$pop%",
                              ),
                              Container(
                                width: 250.0,
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              WeatherBreakDown(
                                iconData: TablerIcons.arrow_up_right,
                                label: "Wind",
                                result: "$windSpeed km/h",
                              ),
                              Container(
                                width: 250.0,
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              WeatherBreakDown(
                                iconData: TablerIcons.layout_bottombar,
                                label: "Humidity",
                                result: "$humidity%",
                              ),
                              Container(
                                width: 250.0,
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              WeatherBreakDown(
                                iconData: TablerIcons.sun,
                                label: "UV",
                                result: "$uv",
                              ),
                            ],
                          ),
                        ),
                        //Forecast tab================================================
                        Container(
                          child: ListView.builder(
                              controller: ScrollController(),
                              itemCount: 7,
                              itemBuilder: (context, index) {
                                final day = data['daily'][index];
                                int time = day['dt'];
                                int temp = day['temp']['day'].toInt();
                                int weatherCode =
                                    day['weather'].elementAt(0)['id'];
                                double chanceOfRain = day['pop'].toDouble();
                                int windSpeed = day['wind_speed'].toInt();
                                int windDeg = day['wind_deg'];
                                int humidity = day['humidity'];
                                int uvi = day['uvi'].toInt();

                                if (tapped == false) {
                                  return GestureDetector(
                                    child: Container(
                                      child: WeatherWidget(
                                          time: time, // time of widget info
                                          temp: temp, // int temp
                                          weatherCode:
                                              weatherCode, // main weather descriptor
                                          rainChance: chanceOfRain,
                                          windSpeed: windSpeed,
                                          windDegree: windDeg,
                                          humidity: humidity,
                                          uvi: uvi // chance of rain
                                          ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        tapped == true;
                                      });
                                    },
                                  );
                                } else {
                                  return GestureDetector(
                                    child: Container(
                                      child: ExpandedWeatherWidget(
                                          time: time, // time of widget info
                                          temp: temp, // int temp
                                          weatherCode:
                                              weatherCode, // main weather descriptor
                                          rainChance: chanceOfRain,
                                          windSpeed: windSpeed,
                                          windDegree: windDeg,
                                          humidity: humidity,
                                          uvi: uvi),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        tapped == false;
                                      });
                                    },
                                  );
                                }
                              }),
                        ),
                        //============================================================

                        Container(
                          child: _myListView(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    ));
  }

  Widget _myListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        _ForumCard("Amanda", 'assets/profile_pic.png', 'assets/forum_pic.png',
            "Towradgi Beach", "2h", mood_happy),
        _ForumCard("Alex Suprun", 'assets/profile_pic2.png',
            'assets/forum_pic2.png', "Towradgi Beach", "2h", mood_neutral),
        _ForumCard("Amanda", 'assets/profile_pic.png', 'assets/forum_pic.png',
            "Towradgi Beach", "2", mood_sad),
        _ForumCard("Alex Suprun", 'assets/profile_pic2.png',
            'assets/forum_pic2.png', "Towradgi Beach", "2h", mood_happy),
      ],
    );
  }

  Widget _ForumCard(String username, String profile_img, String forum_img,
      String location, String post_time, Icon mood_icon) {
    const String str =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi congue felis ut elit dictum tincidunt. In nec orci. Phasellus at nisi vitae lorem feugiat interdum. Curabitur ultricies odio eu dolor efficitur, sit amet pretium sem elementum.";
    return Column(children: [
      Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _userInfo(username, profile_img, location, post_time, mood_icon),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 10),
              child: new Text(
                str,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            Image.asset(forum_img),
            Container(
              padding: EdgeInsets.fromLTRB(14, 5, 0, 0),
              child: _forumBottomTable(),
            ),
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(height: 5),
                    Container(
                        height: 40,
                        width: 328,
                        padding: const EdgeInsets.fromLTRB(10.0, 2, 0, 10),
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xffF2F2F7),
                            filled: true,
                            hintText: 'Write your comment',
                            hintStyle: TextStyle(fontSize: 12, height: 0.5),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                        )),
                  ],
                ),
                MaterialButton(
                  minWidth: 5,
                  height: 10,
                  textColor: const Color(0xff007AFF),
                  padding: EdgeInsets.all(2.0),
                  onPressed: () {},
                  child: const Text('Post',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: 10)
    ]);
  }

  Widget _userInfo(String username, String profile_pic_path, String location,
      String post_time, Icon mood_icon) {
    String location_str = location + ' · ' + post_time + " ago";
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 1, 0),
      child: Row(
        children: <Widget>[
          Image.asset(
            profile_pic_path,
            height: 40,
            width: 40,
          ),
          SizedBox(
            width: 5,
          ),
          Container(
              height: 70,
              child: Table(
                defaultColumnWidth: FixedColumnWidth(156),
                border: TableBorder.all(
                    color: Colors.black26, width: 1, style: BorderStyle.none),
                children: [
                  TableRow(children: [
                    TableCell(
                        child: Align(
                            child: Column(
                      children: [
                        SizedBox(
                          height: 18,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Row(children: [
                              Text(username,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(width: 5),
                              mood_icon,
                            ])),
                        SizedBox(
                          height: 1,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(location_str,
                                style: TextStyle(
                                    color: Color(0xff999999),
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal))),
                      ],
                    ))),
                    TableCell(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Column(children: [
                              SizedBox(
                                height: 4,
                              ),
                              MaterialButton(
                                minWidth: 70,
                                height: 20,
                                textColor: const Color(0xff007AFF),
                                padding: EdgeInsets.all(2.0),
                                onPressed: () {},
                                child: const Text('Add Friend',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ]))),
                  ]),
                ],
              )),
        ],
      ),
    );
  }

  Widget _forumBottomTable() {
    return Table(
        //defaultColumnWidth:FixedColumnWidth(100),
        border: TableBorder.all(
            color: Colors.black26, width: 1, style: BorderStyle.none),
        children: [
          TableRow(children: [
            TableCell(
                child: Row(children: [
              Align(
                alignment: Alignment.topLeft,
                child: Icon(TablerIcons.droplet, size: 25),
              ),
              SizedBox(width: 10),
              Align(
                alignment: Alignment.topLeft,
                child: Icon(TablerIcons.message_circle, size: 25),
              ),
              SizedBox(width: 10),
              Align(
                alignment: Alignment.topLeft,
                child: Icon(TablerIcons.share, size: 25),
              ),
              SizedBox(width: 95),
              Text("126",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              SizedBox(width: 1),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text("drops",
                    style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal)),
              ),
              SizedBox(width: 10),
              Text("83",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              SizedBox(width: 1),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text("replies",
                    style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal)),
              ),
              SizedBox(width: 10),
              Text("200",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              SizedBox(width: 1),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text("views",
                    style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal)),
              ),
            ])),
          ]),
        ]);
  }
}

class WeatherBreakDown extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String result;
  WeatherBreakDown(
      {@required this.iconData, @required this.label, @required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
        width: 250.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(iconData),
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
                ),
              ],
            ),
            Text(
              result,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
