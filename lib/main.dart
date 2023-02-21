// ignore_for_file: non_constant_identifier_names, unnecessary_statements, prefer_const_constructors, prefer_collection_literals, prefer_final_fields

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:location/location.dart';
import 'package:truckotruck/address_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

const String googleMapApiKey = "AIzaSyDW_-Ds0EqmP3GSwQ2IHtxvLJHYRMozVi8";

//=========================================

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Set<Polyline> _directionPolyline = {};

  List<LatLng> latLen = [
    LatLng(11.025307284410333, 77.01051900642669),
    LatLng(11.027875789527531, 77.0115207227632),
    LatLng(11.031650548380346, 77.02753406803816),
    LatLng(11.065924014997053, 77.0928344131661),
    LatLng(11.026418127485128, 77.12621194236172),
  ];
  Polyline polyLine = Polyline(
    polylineId: const PolylineId('direction'),
    color: Colors.blue,
    points: List.empty(growable: true),
    width: 5,
    startCap: Cap.roundCap,
    endCap: Cap.roundCap,
    jointType: JointType.round,
    geodesic: true,
  );

  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = googleMapApiKey;

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  LatLng startLocation = LatLng(11.025307284410333, 77.01051900642669);
  LatLng endLocation = LatLng(11.027875789527531, 77.0115207227632);
  void _marker() async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(15, 15),   ),
      "assets/t_load.png",
    );
    for (int i = 0; i < latLen.length; i++) {
      markers.add(Marker(
        //add start location marker
        markerId: MarkerId(i.toString()),
        position: latLen[i], //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Point ',
          snippet: 'Marker',
        ),
        icon: markerbitmap, //Icon for Marker
      ));
    }
  }

  @override
  void initState() {
    // _location.onLocationChanged.listen((locationData) {
    //   setState(() {
    //     _currentLocation =
    //         LatLng(locationData.latitude!, locationData.longitude!);
    //     _polylineCoordinates[0] = _currentLocation!;
    //     _polylines = Set.from([
    //       Polyline(
    //         polylineId: PolylineId('polyline'),
    //         color: Colors.blue,
    //         width: 5,
    //         points: _polylineCoordinates,
    //       ),
    //     ]);
    //   });
    // });

    //  polyLine.points.add(startLocation);
    // polyLine.points.add(endLocation);

    // markers.add(Marker( //add distination location marker
    //   markerId: MarkerId(endLocation.toString()),
    //   position: endLocation, //position of marker
    //   infoWindow: InfoWindow( //popup info
    //     title: 'Destination Point ',
    //     snippet: 'Destination Marker',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    // ));

    _directionPolyline.add(Polyline(
      polylineId: const PolylineId('direction'),
      color: Colors.blue,
      points: latLen,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
      geodesic: true,
    ));
    _marker();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          //Map widget from google_maps_flutter package
          myLocationEnabled: true,
          compassEnabled: true,
          zoomGesturesEnabled: true, //enable Zoom in, out on map
          initialCameraPosition: CameraPosition(
            //innital position in map
            target: startLocation, //initial position
            zoom: 10.0, //initial zoom level
          ),
          markers: markers, //markers to show on map
          polylines: _directionPolyline, //polylines
          mapType: MapType.normal, //map type
          onMapCreated: (controller) {
            //method called when map is created
            setState(() {
              mapController = controller;
            });
          },
        ),
      ),
    );
  }
}
