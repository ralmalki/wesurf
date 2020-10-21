import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wesurf/components/search_bar.dart';
import 'package:wesurf/components/weather_information.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;
  MapType _currentMapType = MapType.normal;
  //List<Marker> allMarkers = [];
  Set<Marker> allMarkers = {};
  BitmapDescriptor pinLocationIcon;
  LatLng currentLocation = LatLng(-34.41204, 150.902282);
  String _mapStyle;

  //geo Fire
  //final geo = Geoflutterfire();
  //final _firestore = FirebaseFirestore.instance;

  Future<void> addGeoFireLocation() async {
    await Firebase.initializeApp();
    //final _firestore = FirebaseFirestore.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    firebaseFirestore
        .collection('locations')
        .add({'name': 'random name', 'position': currentLocation});
  }

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

  void getLocations() async {
    await Firebase.initializeApp();
    final _firestore = FirebaseFirestore.instance;
    final locations = await _firestore.collection('locations').get();
    Set<Marker> _allMarkers = {};

    for (var location in locations.docs) {
      GeoPoint geo = location.get('coord');
      //print(location.get('name'));
      //print(geo.latitude);
      //print(geo.longitude);

      _allMarkers.add(
        Marker(
            markerId: MarkerId(location.get('name')),
            draggable: false,
            position: LatLng(geo.latitude, geo.longitude),
            icon: pinLocationIcon,
            //icon: setCustomMapPin(color);
            onTap: () {
              print(location.get('name'));
              print(location.id);
              print("lat: ${geo.latitude}, long: ${geo.longitude}");
              _showModalBottomBox(
                  context, location.id, geo.latitude, geo.longitude);
            }),
      );
    }
    setState(() {
      allMarkers = _allMarkers;
    });

    /*for (var location in locations.docs) {
      GeoPoint geo = location.get('coord');
      print(location.get('name'));
      print(geo.latitude);
      print(geo.longitude);
      allMarkers.add(
        Marker(
            markerId: location.get('name'),
            draggable: false,
            position: LatLng(geo.latitude, geo.longitude),
            icon: pinLocationIcon,
            onTap: () {
              _showModalBottomBox(context);
            }),
      );
    } */ //for
  }

/*
  void getAllMarkers() {
    StreamBuilder(
      stream: Firestore.instance.collection('locations').snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading');
        for (int i = 0; i < snapshot.data.documents.length; i++) {
          allMarkers.add(
            Marker(
                markerId: MarkerId(snapshot.data.documents[i]['name']),
                draggable: false,
                onTap: () {
                  _showModalBottomBox(context);
                  print('tapped');
                },
                position: LatLng(snapshot.data.documents[i]['coord'].Latitude,
                    snapshot.data.documents[i]['coord'].Longitude)),
            // ignore: missing_return
          );
        }
      },
    );
  }
*/

  @override
  void initState() {
    setCustomMapPin();
    super.initState();
    rootBundle.loadString('assets/map-style.txt').then((string) {
      _mapStyle = string;
    });
    getLocations();
  }

  // Future<BitmapDescriptor> setCustomMapPin(String color) async {
  //   BitmapDescriptor pinLocationIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(devicePixelRatio: 2.5), 'assets/map-$color.png');
  //   return pinLocationIcon;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/map-red.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapController.setMapStyle(_mapStyle);
              allMarkers.forEach((element) {
                print(element.toString());
              });
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
          SearchBar(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getCurrentLocation();
          //getAllMarkers();
          getLocations();
          //addGeoFireLocation();

          allMarkers.forEach((element) {
            print(element);
          });
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
  return null;
}
