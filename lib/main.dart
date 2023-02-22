// ignore_for_file: non_constant_identifier_names, unnecessary_statements, prefer_const_constructors, prefer_collection_literals, prefer_final_fields, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables

import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_widget/google_maps_widget.dart';

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
  List<LatLng> latLen = [
    LatLng(11.03881588126287, 77.01362222601809),
    LatLng(11.039767608001304, 77.02673828145427),
    LatLng(11.04372475461159, 77.04133435834277),
    LatLng(11.067874684255145, 77.0411905117804),
  ];
  List<LatLng> latLen2 = [
    LatLng(11.10234739871648, 77.1291879729305),
    LatLng(11.116073704143734, 77.11168288714075),
    LatLng(11.131302881976933, 77.13771928039014),
    LatLng(11.13274684255445, 77.15109051178414),
  ];

  List<LatLng> latLen3 = [
    LatLng(11.20234739871648, 77.2291879729305),
    LatLng(11.216073704143734, 77.21168288714075),
    LatLng(11.231302881976933, 77.23771928039014),
    LatLng(11.243274684255445, 77.25109051178414),
  ];
  List<LatLng> latLen4 = [
    LatLng(11.30234739871648, 77.3291879729305),
    LatLng(11.316073704143734, 77.31168288714075),
    LatLng(11.331302881976933, 77.33771928039014),
    LatLng(11.343274684255445, 77.35109051178414),
  ]; 
  
  List markermerge= [];
  //================ Image encode=============
  // declared method to get Images
  Future<Uint8List> getImages(String path) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: 200,
      targetWidth: 200,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Uint8List? marketimages;
  List<String> assetimages = [
    'assets/e_load.png',
    'assets/e_unload.png',
    'assets/e_rest.png',
    'assets/e_load.png',
  ];
  List<String> assetimages1 = [
    'assets/t_load.png',
    'assets/t_unload.png',
    'assets/t_rest.png',
    'assets/t_load.png',
  ];

//======================
  Set<Polyline> _directionPolyline = {};

  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = googleMapApiKey;

  Set<Marker> markers = Set(); //markers for google map`
  Map<PolylineId, Polyline> polylines = {}; 
  
  void _marker() async {
markermerge=[...latLen,...latLen2,...latLen3,...latLen4];

    final Uint8List Icon1 = await getImages('assets/e_load.png');
    final Uint8List Icon2 = await getImages('assets/t_unload.png');
    final Uint8List Icon3 = await getImages('assets/t_rest.png');

    for (int i = 0; i < markermerge.length; i++) {
      markers.add(Marker(
        anchor: Offset(0.5, 0.5),
        markerId: MarkerId(i.toString()),
        position: markermerge[i],
        icon: i.isOdd? BitmapDescriptor.fromBytes(Icon1):BitmapDescriptor.fromBytes(Icon2),
        infoWindow: InfoWindow(
          title: 'Point No : ' + i.toString(),
          snippet: 'Marker ID : ' + i.toString(),
        ),
      ));
    }
  }

  @override
  void initState() {
    _directionPolyline.add(Polyline(
      polylineId: const PolylineId('direction'),
      color: Colors.blue,
      points: latLen,
      width: 5,
    ));
    _directionPolyline.add(Polyline(
      polylineId: const PolylineId('direction2'),
      color: Colors.black,
      points: latLen2,
      width: 5,
    ));
    _directionPolyline.add(Polyline(
      polylineId: const PolylineId('direction3'),
      color: Colors.deepOrange,
      points: latLen3,
      width: 5,
    ));
    _directionPolyline.add(Polyline(
      polylineId: const PolylineId('direction4'),
      color: Colors.indigoAccent,
      points: latLen4,
      width: 5,
    ));
    _marker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          myLocationEnabled: true,
          circles: Set.identity(),
          mapToolbarEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
          initialCameraPosition: CameraPosition(
            target: markermerge[0],
            zoom: 15.0,
          ),
          markers: markers,
          polylines: _directionPolyline,
          mapType: MapType.normal,
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
        ),
      ),
    );
  }
}