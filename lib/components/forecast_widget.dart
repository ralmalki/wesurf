import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';

/* # example collapsed widget and expanded widgets

CollapsedWeatherWidget(
              time: "11 AM",  // time of widget info
              temp: 13, // int temp
              weatherDesc: "Rain",  // main weather descriptor
              rainChance: 97,  // chance of rain
            ),

ExpandedWeatherWidget(
              time: "10 AM",  // time of widget info
              temp: 13, // int temp
              weatherDesc: "Snow",  // main weather descriptor
              rainChance: 80,  // chance of rain
              wind: 40, // int wind kmh
              windDirection: "NE", // string direction
              swellLevel: 1, // for the icon selection ( has to be 1 - 4 )
              swell: 1.77, // double swell m
              UV: 3, // int uv level
            ),

 */

//use day as temperature

/*
class WeatherWidgetController extends StatelessWidget {
  Widget currentWidget = CollapsedWeatherWidget();

  @override
  Widget build(BuildContext context) {
    return
  }
}*/

class CollapsedWeatherWidget extends StatefulWidget {
  CollapsedWeatherWidget(
      {Key key,
      this.time,
      this.temp,
      this.weatherCode,
      this.rainChance,
      this.windSpeed,
      this.windDegree,
      this.humidity,
      this.uvi})
      : super(key: key);

  final int time;
  final int temp;
  final int weatherCode;
  final double rainChance;
  final int windSpeed;
  final int windDegree;
  final int humidity;
  final int uvi;

  @override
  _CollapsedWeatherWidgetState createState() => _CollapsedWeatherWidgetState();
}

class _CollapsedWeatherWidgetState extends State<CollapsedWeatherWidget> {
  Widget build(BuildContext context) {
    WeatherInfo weatherInfo = WeatherInfo();
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 10, 5),
      padding: EdgeInsets.all(18),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              child: Column(children: <Widget>[
            Text(weatherInfo.getDate(widget.time),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
          ])),
          Spacer(),
          Spacer(),
          Spacer(),
          Container(
            child: Image.asset(
              'assets/weather-' +
                  weatherInfo
                      .getWeatherCondition(widget.weatherCode)
                      .toLowerCase() +
                  '.png',
              height: 50,
              width: 50,
            ),
          ),
          Spacer(),
          Spacer(),
          Container(
              child: Column(children: <Widget>[
            Text(this.widget.temp.toString() + "°C",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(weatherInfo.getWeatherCondition(widget.weatherCode),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))
          ])),
          Spacer(),
          Spacer(),
          Spacer(),
          Container(
              child: Row(children: [
            Container(
                child: Column(children: <Widget>[
              Text("Chance of rain", style: TextStyle(fontSize: 15)),
              Row(
                children: [
                  Image.asset(
                    'assets/rain-100.png',
                    height: 15,
                    width: 15,
                  ),
                  Text(
                      weatherInfo
                              .convertChanceOfRain(widget.rainChance)
                              .toString() +
                          "%",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              )
            ])),
          ])),
          Spacer(),
          Spacer(),
          Container(child: Column(children: [Icon(TablerIcons.chevron_down)])),
        ],
      ),
    );
  }
}

class ExpandedWeatherWidget extends StatefulWidget {
  ExpandedWeatherWidget(
      {Key key,
      this.time,
      this.temp,
      this.weatherCode,
      this.rainChance,
      this.windSpeed,
      this.windDegree,
      this.humidity,
      this.uvi})
      : super(key: key);

  final int time;
  final int temp;
  final int weatherCode;
  final double rainChance;
  final int windSpeed;
  final int windDegree;
  final int humidity;
  final int uvi;

  @override
  _ExpandedWeatherWidgetState createState() => _ExpandedWeatherWidgetState();
}

class _ExpandedWeatherWidgetState extends State<ExpandedWeatherWidget> {
  Widget build(BuildContext context) {
    WeatherInfo weatherInfo = WeatherInfo();
    return Container(
        margin: EdgeInsets.fromLTRB(10, 15, 10, 5),
        padding: EdgeInsets.all(15),
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      child: Column(children: <Widget>[
                    Text(weatherInfo.getDate(widget.time),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold))
                  ])),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  Container(
                    child: Image.asset(
                      'assets/weather-' +
                          weatherInfo
                              .getWeatherCondition(widget.weatherCode)
                              .toLowerCase() +
                          '.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                  Spacer(),
                  Spacer(),
                  Container(
                      child: Column(children: <Widget>[
                    Text(this.widget.temp.toString() + "°C",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(weatherInfo.getWeatherCondition(widget.weatherCode),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400))
                  ])),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  Container(
                      child: Row(children: [
                    Container(
                        child: Column(children: <Widget>[
                      Text("Chance of rain", style: TextStyle(fontSize: 15)),
                      Row(
                        children: [
                          Image.asset(
                            'assets/rain-100.png',
                            height: 15,
                            width: 15,
                          ),
                          Text(
                              weatherInfo
                                      .convertChanceOfRain(widget.rainChance)
                                      .toString() +
                                  "%",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ])),
                  ])),
                  Spacer(),
                  Spacer(),
                  Container(
                      child: Column(children: [Icon(TablerIcons.chevron_up)])),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(6, 3, 14, 14),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
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
                      SizedBox(width: 5),
                      Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Text("Wind",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                )),
                            Text(
                                weatherInfo
                                        .convertWindSpeed(widget.windSpeed)
                                        .toString() +
                                    "km/h",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold))
                          ])),
                      Spacer(),
                      Container(
                        child: Image.asset(
                          'assets/swell-' +
                              weatherInfo
                                  .getHumidityLevel(widget.humidity)
                                  .toString() +
                              '.png',
                          height: 20,
                          width: 20,
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Text("Swell",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                )),
                            Text(widget.humidity.toString() + "%",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold))
                          ])),
                      Spacer(),
                      Container(
                        child: Image.asset(
                          'assets/UV-' + widget.uvi.toString() + '.png',
                          height: 20,
                          width: 20,
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Text("UV",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                )),
                            Text(widget.uvi.toString() + " of 10",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold))
                          ])),
                    ]))
          ],
        ));
  }
}

class WeatherInfo {
  //add code to convert unix time to date
  String getDate(int time) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(time * 1000);
    //print("date: $date");
    var format = new DateFormat("EEEE");
    var dateString = format.format(date);
    //print("dateString: $dateString");
    return dateString.toUpperCase().substring(0, 3);
  }

  //Wind speed from m/s to km/h
  double convertWindSpeed(int windspeed) {
    return windspeed * 3.6;
  }

  int convertChanceOfRain(double pop) {
    int chanceOfRain = (pop * 100).toInt();
    return chanceOfRain;
  }

  String getWeatherCondition(int weatherCode) {
    if (weatherCode >= 200 && weatherCode <= 299)
      return "Storm";
    else if (weatherCode >= 300 && weatherCode <= 399)
      return "Drizzle";
    else if (weatherCode >= 500 && weatherCode <= 599) return "Rain";
    return "Cloudy";
  }

  int getHumidityLevel(int humidity) {
    return (humidity / 100).toInt() + 1;
  }

  String getWindDirection(int degree) {
    List<String> directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"];
    int index = (degree ~/ 45) + 1;
    print(directions[index]);
    return directions[index];
  }
}

void expandWidget() {}

void collapseWidget() {}
