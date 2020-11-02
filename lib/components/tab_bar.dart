import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
//import '../backend/network.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:wesurf/components/daily_forecast.dart';
import 'package:wesurf/components/hourly_weather.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:wesurf/screens/forum_comment_screen.dart';

class TabBarWidget extends StatefulWidget {
  TabBarWidget(this.id, this.lat, this.long);

  final id;
  final lat;
  final long;

  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  bool moreInfo = false;
  TextEditingController commentController = TextEditingController();
  String appid = "1e884f92b81b9b1eb0c42487fe6e1584";
  double lat;
  double long;

  StreamController<List<Widget>> streamController = StreamController.broadcast();

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

  Future<List<Widget>> fetchPost(String locationUID) async {
    Firebase.initializeApp();
    var locationInstance = FirebaseFirestore.instance.collection('locations');
    var postInstance = FirebaseFirestore.instance.collection('posts');
    var userInstance = FirebaseFirestore.instance.collection('users');

    String postUID;
    String locationName;
    String content;
    var image = null;
    String mood;
    var timestamp;
    String userName;

    List<Widget> ForumCards = new List<Widget>();
    //fetch all post
    await locationInstance.doc(locationUID).get().then((value) async {
      locationName = value.data()['name'];
      //for each post fetch data
      for (var post in value.data()['posts']) {
        postUID = post;
        //print("postUID: $postUID");
        await postInstance.doc(post).get().then((postValue) async{
          content = postValue.data()['content'];
          image = postValue.data()['image'];
          mood = postValue.data()['mood'];
          timestamp = postValue.data()['timestamp'];
          String userUID = postValue.data()['userUID'];
          //for useUID fetch name
          await userInstance.doc(userUID).get().then((userValue) => userName = userValue.data()['name']);
        });
        ForumCards.add(_ForumCard(
            postUID,
            content,
            userName,
            'assets/profile_pic.png',
            image,
            locationName,
            timeFromNow(timestamp),
            getMood(mood)));
      }
      streamController.add(ForumCards);
    });
    return ForumCards.reversed.toList();
  }

  Widget getMood(String mood) {
    if (mood == 'happy')
      return Icon(TablerIcons.mood_happy, size: 15, color: Color(0xff4CD964));
    else if (mood == 'neutral')
      return Icon(TablerIcons.mood_neutral, size: 15, color: Color(0XFFFE9E12));
    return Icon(TablerIcons.mood_sad, size: 15, color: Colors.red);
  }

  String timeFromNow(String t) {
    DateTime timestamp = DateTime.parse(t);
    Duration duration = DateTime.now().difference(timestamp);
    if (duration.inSeconds > 60) {
      if (duration.inMinutes > 60) {
        if (duration.inHours > 24) {
          return '${duration.inDays} days ago';
        }
        else
          return '${duration.inHours} hours ago';
      }
      else
        return '${duration.inMinutes} minutes ago';
    }
    return 'Just now';
  }

  String today() {
    DateTime now = DateTime.now().toLocal();
    String formattedDate = DateFormat.yMd().format(now).toString();
    return formattedDate;
  }

  Image getRainIcon (double rainChance) {
    int chance;
    if (rainChance >= 0 && rainChance < 0.25)
      chance = 0;
    else if (rainChance >= 0.25 && rainChance < 0.50)
      chance = 25;
    else if (rainChance >= 0.50 && rainChance < 0.75)
      chance = 50;
    else if (rainChance >= 0.75 && rainChance < 1.00)
      chance = 75;
    else
      chance = 100;
    return Image.asset(
        'assets/rain-$chance.png',
        height: 20,
        width: 20,
        fit: BoxFit.fitWidth
    );
  }

  Image getWindIcon(int degree) {
    List<String> directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"];
    int index = (degree ~/ 45) + 1;
    String direction = directions[index];
    return Image.asset(
      'assets/wind-$direction.png',
      height: 20,
      width: 20,
      fit: BoxFit.fitWidth
    );
  }

  Image getWeatherIcon(int weatherCode, double size) {
    String weatherCondition = "";
    if (weatherCode >= 200 && weatherCode <= 299)
      weatherCondition = "storm";
    else if (weatherCode >= 300 && weatherCode <= 399)
      weatherCondition = "drizzle";
    else if (weatherCode >= 500 && weatherCode <= 599)
      weatherCondition = "rain";
    else if (weatherCode >= 700 && weatherCode <= 799)
      weatherCondition = "foggy";
    else if (weatherCode == 800)
      weatherCondition = "clear";
    else
      weatherCondition = "cloudy";

    return Image.asset(
      'assets/weather-$weatherCondition.png',
      height: size,
      width: size,
      fit: BoxFit.fitWidth,
    );
  }

  @override
  void initState() {
    super.initState();
    // print("lat: ${widget.lat}, long: ${widget.long}");
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
          int pop = (data['hourly'][0]['pop']*100).toInt();
          int humidity = data['current']['humidity'].toInt();
          String sky = data['current']['weather'][0]['main'];
          String skyDesc = data['current']['weather'][0]['description'];
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
                        moreInfo
                        ? Container(
                        child: Column(children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                moreInfo = !moreInfo;
                              });
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                  child: Row(children: [
                                    Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.redAccent,
                                    ),
                                    Container(
                                        child: Text("Back",
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.w700))),
                                  ]),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height * 0.08,
                                    width: MediaQuery.of(context).size.width * 0.90,
                                    padding: EdgeInsets.all(8),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          child: getWeatherIcon(weatherId, 60)),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                        child: Text("${currentTemp.toString()}℃",
                                            style: TextStyle(fontSize: 45, fontWeight: FontWeight.w600)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(1.0),
                                                child: Row(children: [
                                                  Text(
                                                    "High ${tempHigh.toString()}℃ • Low ${tempLow.toString()}℃",
                                                    style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                                                  ),
                                                  Text("")
                                                ]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(1.0),
                                                child: Row(children: [
                                                  Text("$sky • $skyDesc",
                                                      style: TextStyle(color: Colors.blueGrey, fontSize: 14)),
                                                  Text("")
                                                ]),
                                              )
                                            ]),
                                      )
                                    ]))
                              ],
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: 13,
                                  itemBuilder: (context, index) {
                                    final hour = data['hourly'][index];
                                    // print(hour);
                                    int time = hour['dt'];
                                    int temp = hour['temp'].toInt();
                                    int weatherCode = hour['weather'].elementAt(0)['id'];
                                    double chanceOfRain = hour['pop'].toDouble();
                                    int windSpeed = (hour['wind_speed']* 3.6).round();
                                    int windDeg = hour['wind_deg'];
                                    int humidity = hour['humidity'];

                                    // print("time: $time");
                                    // print("temp: $temp");
                                    // print("weatherCode: $weatherCode");
                                    // print("rain: $chanceOfRain");
                                    // print("wind: $windSpeed");

                                    return HourlyWeatherWidget(
                                      time: time, // time of widget info
                                      temp: temp, // int temp
                                      weatherCode: weatherCode, // main weather descriptor
                                      rainChance: chanceOfRain,
                                      windSpeed: windSpeed,
                                      windDegree: windDeg,
                                      humidity: humidity,
                                    );
                                  }
                              )
                          ),
                        ]))
                        : Container(
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
                                getWeatherIcon(weatherId, 100),
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
                              "$sky • $skyDesc",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          WeatherBreakDown(
                            iconData: getRainIcon(pop.toDouble()),
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
                            iconData: getWindIcon(windDirection),
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
                            iconData: Image.asset(
                              'assets/humidity.png',
                              height: 20,
                              width: 20,
                              fit: BoxFit.fitWidth
                            ),
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
                            iconData: Image.asset(
                                'assets/UV-$uv.png',
                                height: 20,
                                width: 20,
                                fit: BoxFit.fitWidth
                            ),
                            label: "UV",
                            result: "$uv",
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Container(
                                child: Text(today(), style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey)
                                )
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                moreInfo = !moreInfo;
                              });
                            },
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 8, 8, 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        child: Text("Hourly forecast", style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w700)
                                        )
                                    ),
                                    Icon(Icons.arrow_forward_ios, color: Colors.redAccent)
                                  ],
                                )
                            ),
                          )
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
                                int windSpeed = (day['wind_speed']*3.6).toInt();
                                int windDeg = day['wind_deg'];
                                int humidity = day['humidity'];
                                int uvi = day['uvi'].toInt();

                                  return WeatherWidget(
                                      time: time, // time of widget info
                                      temp: temp, // int temp
                                      weatherCode:
                                          weatherCode, // main weather descriptor
                                      rainChance: chanceOfRain,
                                      windSpeed: windSpeed,
                                      windDegree: windDeg,
                                      humidity: humidity,
                                      uvi: uvi);
                                }
                              ),
                        ),
                        //============================================================

                        Container(
                          child: _postListView(context),
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

  Widget _postListView(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          return FutureBuilder(
            future: fetchPost(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Widget> postList = snapshot.data;
                List<Widget> postListR = postList;
                return ListView.builder(
                    itemCount: postList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return postListR[index];
                    }
                );
              } else {
                return SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }

  Widget _ForumCard(String postUID, String content, String username, String profile_img, String forum_img,
      String location, String post_time, Icon mood_icon) {
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
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 15, 15),
                child: new Text(
                  content,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
              ),
            ),
            forum_img != ""
                ? Image.network(
                    forum_img,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth
                  )
                : Container()
            ,
            Container(
              padding: EdgeInsets.fromLTRB(14, 5, 0, 0),
              child: _forumBottomTable(
                  postUID,
                  content,
                  username,
                  profile_img,
                  forum_img,
                  location,
                  post_time,
                  mood_icon
              ),
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
                                    child: Text(location,
                                        style: TextStyle(
                                            color: Color(0xff999999),
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal))),
                                SizedBox(
                                  height: 1,
                                ),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(post_time,
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

  Widget _forumBottomTable(String postUID, String content, String username, String profile_img, String forum_img,
      String location, String post_time, Icon mood_icon) {
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
                    child: GestureDetector(
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Forum_comment()));
                          Navigator.of(context).push(CommentRoute(
                              postUID,
                              content,
                              username,
                              profile_img,
                              forum_img,
                              location,
                              post_time,
                              mood_icon

                          ));
                        },
                        child: Icon(TablerIcons.message_circle, size: 25)),
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

  Route CommentRoute(String postUID,String content, String username, String profile_img, String forum_img,
      String location, String post_time, Icon mood_icon) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation)
        => Forum_comment(
            postUID,
            content,
            username,
            profile_img,
            forum_img,
            location,
            post_time,
            mood_icon
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin= Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeIn;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
              position: animation.drive(tween),
              child: child
          );
        }
    );
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

}

class WeatherBreakDown extends StatelessWidget {
  final Widget iconData;
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: iconData,
                ),
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
