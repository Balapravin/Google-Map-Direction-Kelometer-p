// ignore_for_file: non_constant_identifier_names, unnecessary_statements

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:maptrack/Categorys/Allpage_button.dart';
import 'package:maptrack/config.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CommonButton(),
    );
  }
}













//=============== NOT USED =========================================
class MapRoureTracker extends StatefulWidget {
  @override
  State<MapRoureTracker> createState() => MapRoureTrackerState();
}

class MapRoureTrackerState extends State<MapRoureTracker> {
  double CAMERA_ZOOM = 16;
  double CAMERA_TILT = 60;
  double CAMERA_BEARING = 20;
  PickResult? fromAddress;
  PickResult? toAddress;

  LatLng fromLatLng = LatLng(11.0551709, 77.0151313);
  LatLng toLatLng = LatLng(11.0254458, 77.0100475);

  TextEditingController sourceAddress = TextEditingController();
  TextEditingController destinationAddress = TextEditingController();

  Completer<GoogleMapController> mapController = Completer();
  LocationData? currentLocation;

  //============== Get Current Location ====================
  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) => currentLocation = location);

    GoogleMapController googleMapController = await mapController.future;
    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      print('current Location0 : $currentLocation');

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: CAMERA_ZOOM,
              tilt: CAMERA_TILT,
              bearing: CAMERA_BEARING,
              target: LatLng(newLoc.latitude!, newLoc.longitude!))));

    
      polylineCoordinates=[];
      getpolypoints();
      setState(() {});
      
    });
  }

// ================= Polyline =================

  List<LatLng> polylineCoordinates = [];
  void getpolypoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapApiKey,
        PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        PointLatLng(toLatLng.latitude, toLatLng.longitude));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));

      // setState(() {});
    }
  }
  //--------------- X X X ---------------

  @override
  void initState() {
    getCurrentLocation();
    // setCustomIcon();
    // getpolypoints();
    super.initState();
  }

  bool pageload = true;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      pageload = false;
      setState(() {
        getpolypoints();
      });
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Truck Route',
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
       
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: sourceAddress,
                decoration: InputDecoration(hintText: 'Search'),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) => print(value),
              )),
              //--------------------------------  From place select on google map --------------------------
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PlacePicker(
                            resizeToAvoidBottomInset:
                                false, // only works on fullscreen, less flickery
                            apiKey: googleMapApiKey,
                            hintText: "Find a place ...",
                            searchingText: "Please wait ...",
                            selectText: "Select place",
                            outsideOfPickAreaText: "Place not in area",
                            initialPosition: LatLng(0, 0),
                            useCurrentLocation: true,
                            selectInitialPosition: true,
                            usePinPointingSearch: true,
                            usePlaceDetailSearch: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            onMapCreated: (GoogleMapController controller) {
                              print("Map created");
                            },
                            onPlacePicked: (PickResult result) {
                              print("Place picked: ${result.formattedAddress}");
                              setState(() {
                                fromAddress = result;
                                sourceAddress.text =
                                    // '${fromAddress!.geometry!.location.lat} , ${fromAddress!.geometry!.location.lng}';
                                    result.formattedAddress!;

                                fromLatLng = LatLng(
                                    fromAddress!.geometry!.location.lat,
                                    fromAddress!.geometry!.location.lng);
                                Navigator.of(context).pop();

                                getpolypoints();
                              });
                            },
                            onMapTypeChanged: (MapType mapType) {
                              print(
                                  "Map type changed to ${mapType.toString()}");
                            },
                          );
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: destinationAddress,
                decoration: InputDecoration(hintText: 'Search'),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) => print(value),
              )),

              //--------------------------------  To place select on google map --------------------------
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PlacePicker(
                            resizeToAvoidBottomInset:
                                false, // only works on fullscreen, less flickery
                            apiKey: googleMapApiKey,
                            hintText: "Find a place ...",
                            searchingText: "Please wait ...",
                            selectText: "Select place",
                            outsideOfPickAreaText: "Place not in area",
                            initialPosition: LatLng(0, 0),
                            useCurrentLocation: true,
                            selectInitialPosition: true,
                            usePinPointingSearch: true,
                            usePlaceDetailSearch: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,

                            onMapCreated: (GoogleMapController controller) {
                              print("Map created");
                            },
                            onPlacePicked: (PickResult result) {
                              print("Place picked: ${result.formattedAddress}");
                              setState(() {
                                toAddress = result;
                                destinationAddress.text =
                                    result.formattedAddress!;

                                toLatLng = LatLng(
                                    toAddress!.geometry!.location.lat,
                                    toAddress!.geometry!.location.lng);

                                Navigator.of(context).pop();

                                getpolypoints();
                              });
                            },
                            onMapTypeChanged: (MapType mapType) {
                              print(
                                  "Map type changed to ${mapType.toString()}");
                            },
                          );
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          //----------------------- MAP ----------------
         currentLocation!.latitude ==null 
              ? Center(
                  child: Text('L O A D I N G . . . . '),
                )
              : Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                      // zoom: CAMERA_ZOOM,
                      tilt: CAMERA_TILT,
                      bearing: CAMERA_BEARING,
                    ),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    scrollGesturesEnabled: true,
                    markers: {
                      Marker(
                          markerId: MarkerId("Source"),
                          position: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!)),
                      Marker(
                          markerId: MarkerId("Destination"),
                          position: toLatLng),
                      Marker(
                          markerId: MarkerId("Driver Location"),
                          position: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!)),
                    },
                    polylines: {
                      Polyline(
                          polylineId: PolylineId("Route"),
                          points: polylineCoordinates,
                          width: 6,
                          color: mapColor)
                    },
                    onMapCreated: (controller) {
                      mapController.complete(controller);
                    },
                  ),
                ),
        ],
      ),
      // ),
    );
  }
}
