// ignore_for_file: non_constant_identifier_names, unnecessary_statements, prefer_const_constructors, prefer_collection_literals, prefer_final_fields, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:truckotruck/Service/get_Api.dart';

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
  List rotater=[70.0,80.0,120.0,190.0,220.0,22.0,150.0,160.0,300.0,310.0,100.0,40.0];
  
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
  
  double pinPillPosition = -100;
  
  void _marker() async {
markermerge=[...latLen,...latLen2,...latLen3];

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
BottomPinInformation? PinInfo;

  moveMarker()async{
    
    final Uint8List Icon2 = await getImages('assets/t_unload.png');
    final Uint8List Icon3 = await getImages('assets/t_rest.png');
    markers={};      
       markers.add(Marker(
        anchor: Offset(0.5, 0.5),
        markerId: MarkerId(markerIndex.toString()),
        position: markermerge[markerIndex],
        // icon: markerIndex.isOdd?BitmapDescriptor.fromBytes(Icon2):BitmapDescriptor.fromBytes(Icon3),
        infoWindow: InfoWindow(
          title: 'Point No : ' + markerIndex.toString(),
          snippet: 'Marker ID : ' + markerIndex.toString(),
        ),
      ));

      // mapController!.animateCamera(CameraUpdate.newLatLng(markermerge[markerIndex]));
       
     PinInfo = BottomPinInformation(
        date: '2023-01-'+markerIndex.toString(),
        time: '02:30 PM'+markerIndex.toString(),
        avatarPath: markerIndex.isOdd?'assets/t_unload.png':'assets/e_unload.png',
        status: 'Loading' + markerIndex.toString());
        
      if(markerIndex!=markermerge.length){
          markerIndex++;
          Future.delayed(Duration(milliseconds: 2000), (){
         markermerge.length ==markerIndex?'' :    moveMarker();
          });
      }      
      
      setState(() {  });//refresh UI  
  }

  @override
  void initState() {
    CommonGetApiService().getmapDetails();
     PinInfo = BottomPinInformation(
        date: '',
        time: '',
        avatarPath: 'assets/t_unload.png',
        status: '');

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
    _marker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  return  Scaffold(
     floatingActionButton: FloatingActionButton(
      
             child: Text("Replay"),
             onPressed: (){
              setState(() {
                // pinPillPosition=0;
              });
              markerIndex=0;
                 moveMarker();
             },
          ),
        body: Stack(children: <Widget>[
    GoogleMap(
  onTap: (LatLng location) {
          setState(() {
            pinPillPosition = -100;
          });
        },
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
              pinPillPosition=-100;
              mapController = controller;
            });
          },
        ),
      AnimatedPositioned(
        bottom: pinPillPosition,
        right: 0,
        left: 0,
        duration: Duration(milliseconds: 200),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(20),
            height: 70,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 60,
                    height: 60,
                    child: ClipOval(
                        child: Image.asset(PinInfo!.avatarPath!,
                            fit: BoxFit.cover)
                            )), // first widget
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[                      
                        Text(
                            'Date : ${PinInfo!.date!.toString()}',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text(
                            'Time : ${PinInfo!.time!.toString()}',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text(
                            'Status : '+PinInfo!.status!,
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]));
  }
}

class BottomPinInformation {
  String? avatarPath;
  String? date;  
  String? time;
   String? status;
  BottomPinInformation(
      {this.avatarPath,
      this.date,
      this.time,
      this.status,});
}