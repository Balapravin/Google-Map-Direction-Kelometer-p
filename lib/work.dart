// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ffi';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:truckotruck/main.dart';

class MarkerMover extends StatefulWidget {
  @override
  _MarkerMoverState createState() => _MarkerMoverState();
}

class _MarkerMoverState extends State<MarkerMover> {

  List<LatLng> latLen = [
    
    LatLng(11.03881588126287, 77.01362222601809),
    LatLng(11.039767608001304, 77.02673828145427),
    LatLng(11.04372475461159, 77.04133435834277),
    LatLng(11.067874684255145, 77.0411905117804),
    LatLng(11.10234739871648, 77.1291879729305),
    LatLng(11.116073704143734, 77.11168288714075),
    LatLng(11.131302881976933, 77.13771928039014),
    LatLng(11.13274684255445, 77.15109051178414),    
    LatLng(11.141302881976933, 77.16771928039014),
    LatLng(11.14979684255445, 77.17109051178414),
  ];

  List rotater=[70.0,80.0,120.0,190.0,220.0,22.0,150.0,160.0,300.0,310.0];
  
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

//======================
  Set<Polyline> _directionPolyline = {};

  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = googleMapApiKey;

  Set<Marker> markers = Set(); //markers for google map`
  Map<PolylineId, Polyline> polylines = {}; 
  
  void _marker() async {
markermerge=[...latLen];

    final Uint8List Icon1 = await getImages('assets/e_load.png');
    final Uint8List Icon2 = await getImages('assets/t_unload.png');
    final Uint8List Icon3 = await getImages('assets/t_rest.png');

    for (int i = 0; i < markermerge.length; i++) {
      markers.add(Marker(
        anchor: Offset(0.5, 0.5),
        // rotation: rotater[i],
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


int markerIndex=0;
void showInfoWindow(String markerId) async {
  final GoogleMapController controller = await mapController!;
  controller.showMarkerInfoWindow(MarkerId(markerId));
}
void hideInfoWindow(String markerId) async {
   GoogleMapController controller = await mapController!;
  controller.hideMarkerInfoWindow(MarkerId(markerId));
}
  moveMarker()async{
    
    final Uint8List Icon2 = await getImages('assets/t_unload.png');
    markers={};      
       markers.add(Marker(
        rotation: rotater[markerIndex],
        anchor: Offset(0.5, 0.5),
        markerId: MarkerId(markerIndex.toString()),
        position: markermerge[markerIndex],
        icon: BitmapDescriptor.fromBytes(Icon2),
        infoWindow: InfoWindow(
          title: 'Point No : ' + markerIndex.toString(),
          snippet: 'Marker ID : ' + markerIndex.toString(),
        ),
      ));
showInfoWindow(markerIndex.toString());
      if(markerIndex!=markermerge.length){
          markerIndex++;
          Future.delayed(Duration(milliseconds: 1500), (){
         markermerge.length ==markerIndex?'' :    moveMarker();
          });
      }      
      setState(() {  });//refresh UI  
  }

  @override
  void initState() {
    _directionPolyline.add(Polyline(
      polylineId: const PolylineId('direction'),
      color: Colors.blue,
      points: latLen,
      width: 5,
    ));
    _marker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          floatingActionButton: FloatingActionButton(
             child: Text("Replay"),
             onPressed: (){
              markerIndex=0;
                 moveMarker();
             },
          ),
      body: SafeArea(
        child: GoogleMap(

          myLocationEnabled: true,
          // circles: Set.identity(),
          mapToolbarEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
          initialCameraPosition: CameraPosition(
            target: markermerge[markermerge.length ==markerIndex?markermerge.length-1: markerIndex],
            zoom: 16.0,
          ),
          
          markers: markers,
          polylines: _directionPolyline,
          mapType: MapType.normal,
          onMapCreated: (controller) {
            setState(() {
              
showInfoWindow(markerIndex.toString());
              mapController = controller;
            });
          },
        ),
      ),
    );
  }
}