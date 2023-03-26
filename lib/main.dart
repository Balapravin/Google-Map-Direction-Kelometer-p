import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:location/location.dart';
import 'package:location_example/distance.dart';

void main() {
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GoogleMapLocationTracker(),
    );
  }
}


class GoogleMapLocationTracker extends StatefulWidget {
  @override
  _GoogleMapLocationTrackerState createState() => _GoogleMapLocationTrackerState();
}

class _GoogleMapLocationTrackerState extends State<GoogleMapLocationTracker> {
  num km = 0;
  LatLng? destination = LatLng(11.024696677712232, 77.01053054792187);
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "googleAPiKey";
  StreamSubscription<LocationData>? locationSubscription;

  final Location location = Location();
  LocationData? locationData;

  late Timer timer;

  Future updateLocation(LatLng latLng) async {
    if (mounted) {
      Future.delayed(const Duration(seconds: 1), () async {
        print("check");
        await controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 15)));
      });

      updateDistance(
        latLng,
      );
    }
  }

  updateDistance(
    latLng,
  ) {
    km = DistanceService.findDistance(latLng, destination!);
  }

  Future<void> listenLocation() async {
    locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {}
      locationSubscription?.cancel();

      locationSubscription = null;
    }).listen((LocationData currentLocation) {
     Future.delayed(Duration(seconds: 1),(){
       getPolyline(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
     });
    });
  }

  getPolyline(LatLng current) async {
    PolylineResult result = await polylinePoints
        .getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(current.latitude, current.longitude),
      PointLatLng(destination!.latitude, destination!.longitude),
      travelMode: TravelMode.driving,
    )
        .whenComplete(() async {
      await updateLocation(LatLng(current.latitude, current.longitude));
    });
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    addPolyLine();
  }

  Future<void> stopListen() async {
    locationSubscription?.cancel();
  }

  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        width: 5,
        polylineId: id,
        color:Colors.blueAccent,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  @override
  void dispose() {
    controller.dispose();
    stopListen();
    super.dispose();
  }

  @override
  void initState() {
    addMarker(destination!, "destination", BitmapDescriptor.defaultMarkerWithHue(90));
    super.initState();
  }

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController controller;

  void _onMapCreated(GoogleMapController _cntlr) {
    controller = _cntlr;
   listenLocation();
  }
bool refresh = true;
  @override
  Widget build(BuildContext context) {
    refresh == true?Future.delayed(const Duration(seconds: 2),(){setState(() {refresh=false;});}):null; 
    return Scaffold(
      bottomNavigationBar:refresh == true?null: Container(
        height: 40,
        color: Colors.blueAccent,
        child: Center(
            child: Text(
          km.toStringAsFixed(2) + " KM",
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        )),
      ),
      body:refresh == true? Center(child: CircularProgressIndicator(),): SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialcameraposition),
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
