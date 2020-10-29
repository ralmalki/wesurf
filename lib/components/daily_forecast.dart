import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
// // Add the custom ExpansionTile file to project and import
// import 'package:-localprojectname-/CustomExpansionTile.dart' as custom;
import 'CustomExpansionTile.dart' as custom;

class WeatherWidget extends StatefulWidget {
  WeatherWidget(
      {this.time,
      this.temp,
      this.weatherCode,
      this.rainChance,
      this.windSpeed,
      this.windDegree,
      this.humidity,
      this.uvi});

  final int time;
  final int temp;
  final int weatherCode;
  final double rainChance;
  final int windSpeed;
  final int windDegree;
  final int humidity;
  final int uvi;

  @override
  WeatherWidgetState createState() => new WeatherWidgetState();
}

class WeatherWidgetState extends State<WeatherWidget> {
  Color _textcolor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return WeatherWidget(
        widget.time,
        widget.temp,
        widget.weatherCode,
        widget.rainChance,
        widget.windSpeed,
        widget.windDegree,
        widget.humidity,
        widget.uvi);
  }

  // Function returning the collapsed weather widget with the main information
  Widget Collapsed(
      String time, int temp, String condition, int rainChance, int rainLevel) {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Text(time,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _textcolor,
              )),
          SizedBox(width: 20),
          Image.asset(
            'assets/weather-' + condition.toLowerCase() + '.png',
            height: 50,
            width: 50,
          ),
          SizedBox(width: 5),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(temp.toString() + "°C",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textcolor)),
            Text(condition, style: TextStyle(fontSize: 13, color: _textcolor))
          ]),
          SizedBox(width: 25),
          Column(
            children: [
              Text("Chance of rain",
                  style: TextStyle(fontSize: 13, color: _textcolor)),
              Row(
                children: [
                  Image.asset(
                    'assets/rain-$rainLevel.png',
                    height: 20,
                    width: 20,
                  ),
                  Text(rainChance.toString() + "%",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _textcolor)),
                ],
              ),
            ],
          ),
        ]));
  }

  // Function which returns the expanded weather widget with additional information
  Widget Expanded(int windSpeed, String windDirection, int humidity, int uvi) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 15, 10, 5),
        padding: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/wind-' + windDirection.toUpperCase() + '.png',
                height: 20,
                width: 20,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Wind",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                        )),
                    Text(windSpeed.toString() + "km/h",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))
                  ]),
              Image.asset(
                'assets/humidity.png',
                height: 30,
                width: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Humidity", style: TextStyle(fontSize: 13)),
                  Text(humidity.toString() + "%",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                ],
              ),
              Image.asset(
                'assets/UV-' + uvi.toString() + '.png',
                height: 30,
                width: 30,
              ),
              Column(
                children: [
                  Text("UV", style: TextStyle(fontSize: 13)),
                  Text(uvi.toString() + " of 10",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
        ));
  }

  // Main function called
  Widget WeatherWidget(int time, int temp, int weatherCode, double rainChance,
      int windSpeed, int windDegree, int humidity, int uvi) {
    WeatherInfo weatherInfo = new WeatherInfo();
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
          title: Collapsed(
              weatherInfo.getDate(time),
              temp,
              weatherInfo.getWeatherCondition(weatherCode),
              weatherInfo.convertChanceOfRain(rainChance),
              weatherInfo.getRainChance(rainChance)),
          children: <Widget>[
            // Then call the function returning the expanded widget
            Expanded(windSpeed, weatherInfo.getWindDirection(windDegree),
                humidity, uvi)
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

  //------DELETE IF WIND SPEED IS ALREADY CONVERTED------
  //Wind speed from m/s to km/h
  // double convertWindSpeed(int windspeed) {
  //   return windspeed * 3.6;
  // }
  //------------------------------------------------------

  //Convert chance of rain
  int convertChanceOfRain(double pop) {
    int chanceOfRain = (pop * 100).toInt();
    print(chanceOfRain);
    return chanceOfRain;
  }

  //Get icon according to chance of rain
  int getRainChance(double rainChance) {
    if (rainChance >= 0 && rainChance < 25)
      return 0;
    else if (rainChance >= 25 && rainChance < 50)
      return 25;
    else if (rainChance >= 50 && rainChance < 75)
      return 50;
    else if (rainChance >= 75 && rainChance < 100) return 75;
    return 100;
  }

  //Get condition + icon according to weather condition
  String getWeatherCondition(int weatherCode) {
    if (weatherCode >= 200 && weatherCode <= 299)
      return "Storm";
    else if (weatherCode >= 300 && weatherCode <= 399)
      return "Drizzle";
    else if (weatherCode >= 500 && weatherCode <= 599) return "Rain";
    return "Cloudy";
  }

  //DELETE AS HUMIDITY SHARE THE UNIVERSAL ICON NOW
  // int getHumidityLevel(int humidity) {
  //   return (humidity / 100).toInt() + 1;
  // }

  //Get icon according to direction
  String getWindDirection(int degree) {
    List<String> directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"];
    int index = (degree ~/ 45) + 1;
    // print(directions[index]);
    return directions[index];
  }
}
