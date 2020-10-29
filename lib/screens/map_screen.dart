import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wesurf/components/search_bar.dart';
import 'package:wesurf/components/weather_information.dart';

import 'notification_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;
  MapType _currentMapType = MapType.normal;
  Set<Marker> allMarkers = {};
  BitmapDescriptor pinLocationIcon;
  LatLng currentLocation = LatLng(-34.41204, 150.902282);
  String _mapStyle;
  BitmapDescriptor greenPin;
  BitmapDescriptor redPin;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
/*
  Future<void> addGeoFireLocation() async {
    //await Firebase.initializeApp();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    firebaseFirestore
        .collection('locations')
        .add({'name': 'random name', 'position': currentLocation});
  }
*/
  Future<void> _getCurrentLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final GoogleMapController controller = await mapController;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    setCustomMapPin();
    super.initState();
    rootBundle.loadString('assets/map-style.txt').then((string) {
      _mapStyle = string;
    });

    // MessageHandler messageHandler = new MessageHandler();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        print(data);
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.amber,
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationScreen()));
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationScreen()));
      },
    );
  }

  void setCustomMapPin() async {
    greenPin = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/map-green.png');
    redPin = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/map-red.png');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('locations').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          for (var location in snapshot.data.documents) {
            BitmapDescriptor pin = greenPin;
            if (location.get('dangerous')) pin = redPin;
            GeoPoint geo = location.get('coord');
            allMarkers.add(
              Marker(
                  markerId: MarkerId(location.get('name')),
                  draggable: false,
                  position: LatLng(geo.latitude, geo.longitude),
                  icon: pin,
                  //icon: setCustomMapPin(color);
                  onTap: () {
                    _showModalBottomBox(
                        context, location.id, geo.latitude, geo.longitude);
                  }),
            );
          }
          return Scaffold(
            body: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                mapController.setMapStyle(_mapStyle);
                allMarkers.forEach((element) {});
              },
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 12,
              ),
              mapType: _currentMapType,
              myLocationButtonEnabled: false,
              //markers: Set.from(allMarkers),
              markers: allMarkers,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _getCurrentLocation();
              },
              child: Icon(
                TablerIcons.location,
                color: Color(0xff007AFF),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13.0))),
              mini: true,
              backgroundColor: Colors.white,
            ),
          );
        });
  }
}

Widget _showModalBottomBox(context, id, lat, long) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return WeatherInformation(id, lat, long);
      });
}
