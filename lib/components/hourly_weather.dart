import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
// Add the custom ExpansionTile file to project and import
import 'CustomExpansionTile.dart' as custom;
import 'package:intl/intl.dart';
import 'dart:convert';

// Updated Expandable weather widget class

class HourlyWeatherWidget extends StatefulWidget{
  HourlyWeatherWidget({
    this.time,
    this.temp,
    this.weatherCode,
    this.rainChance,
    this.windSpeed,
    this.windDegree,
    this.humidity
  });

  final int time;
  final int temp;
  final int weatherCode;
  final double rainChance;
  final int windSpeed;
  final int windDegree;
  final int humidity;

  @override
  HourlyWeatherWidgetState createState() => HourlyWeatherWidgetState();
}

class HourlyWeatherWidgetState extends State<HourlyWeatherWidget>{

  Color _textcolor = Colors.black;
  WeatherInfo weatherInfo;

  @override
  void initState() {
    weatherInfo = new WeatherInfo();
  }

  // The collapsed weather widget with the main information
  Widget Collapsed() {
    return Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Text(weatherInfo.getHour(widget.time),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _textcolor,
              )),
          SizedBox(width: 10),
          Image.asset(
            'assets/weather-' +
                weatherInfo
                    .getWeatherCondition(widget.weatherCode)
                    .toLowerCase() +
                '.png',
            height: 50,
            width: 50,
          ),
          SizedBox(width: 5),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.temp.toString() + "°C",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textcolor)),
            Text(weatherInfo.getWeatherCondition(widget.weatherCode),
                style: TextStyle(
                    fontSize: 13,
                    color: _textcolor))
          ]),
          SizedBox(width: 35),
          Column(
            children: [
              Text("Chance of rain",
                  style: TextStyle(fontSize: 13, color: _textcolor)),
              Row(
                children: [
                  Image.asset(
                    'assets/rain-${weatherInfo.getRainChance(widget.rainChance).toString()}.png',
                    height: 15,
                    width: 15,
                  ),
                  Text(
                      weatherInfo
                              .convertChanceOfRain(widget.rainChance)
                              .toString() +
                          "%",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _textcolor))
                ],
              ),
            ],
          ),
        ]));
  }

  // The expanded weather widget with additional information
  Widget ExpandedWidget() {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/wind-' +
                        weatherInfo
                            .getWindDirection(widget.windDegree)
                            .toUpperCase() +
                        '.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Wind",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 13,
                          )),
                      Text(widget.windSpeed.toString() + " m/s",
                          textAlign: TextAlign.left,
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                    ]
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/humidity.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Humidity", style: TextStyle(fontSize: 13)),
                    Text(widget.humidity.toString() + "%",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                ),
              ],
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // Main widget returned
    return Container(
        margin: EdgeInsets.fromLTRB(10, 15, 10, 5),
        padding: EdgeInsets.all(8),
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
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: custom.ExpansionTile(
          // Keep the font colour unchanged when expanding the tile
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                _textcolor = Colors.black;
              } else {
                _textcolor = Colors.black;
              }
            });
          },
          iconColor: Colors.white,
          // The title widget is the collapsed widget
          title: Collapsed(),
          children: <Widget>[
            // Then call the function returning the expanded widget
            ExpandedWidget()
          ],
        ));
  }
}

class WeatherInfo {
  String getHour(int time) {
    DateTime dateTime =
        new DateTime.fromMillisecondsSinceEpoch(time * 1000).toLocal();
    var format = new DateFormat("j");
    var hourString = format.format(dateTime);
    return hourString;
  }

  //Convert chance of rain
  int convertChanceOfRain(double pop) {
    int chanceOfRain = (pop * 100).toInt();
    return chanceOfRain;
  }

  //Get icon according to chance of rain
  int getRainChance(double rainChance) {
    if (rainChance >= 0 && rainChance < 0.25)
      return 0;
    else if (rainChance >= 0.25 && rainChance < 0.50)
      return 25;
    else if (rainChance >= 0.50 && rainChance < 0.75)
      return 50;
    else if (rainChance >= 0.75 && rainChance < 1.00)
      return 75;
    return 100;
  }

  //Get condition + icon according to weather condition
  String getWeatherCondition(int weatherCode) {
    if (weatherCode >= 200 && weatherCode <= 299)
      return "Storm";
    else if (weatherCode >= 300 && weatherCode <= 399)
      return "Drizzle";
    else if (weatherCode >= 500 && weatherCode <= 599)
      return "Rain";
    else if (weatherCode >= 700 && weatherCode <= 799)
      return "Foggy";
    else if (weatherCode == 800) return "Clear";
    return "Cloudy";
  }

  //Get icon according to direction
  String getWindDirection(int degree) {
    List<String> directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"];
    int index = (degree ~/ 45) + 1;
    // print(directions[index]);
    return directions[index];
  }
}
