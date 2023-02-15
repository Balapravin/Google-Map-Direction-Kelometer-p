import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:location/location.dart';
import '../config.dart';

class MainModule extends StatefulWidget {
  // const MainModule({super.key});

  @override
  State<MainModule> createState() => _MainModuleState();
}

class _MainModuleState extends State<MainModule> {
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
      getpolypoints();
      // setState(() {});
      
    });
  }

// ================= Polyline =================

  List<LatLng> polylineCoordinates = [];
  void getpolypoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapApiKey,
        PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        PointLatLng(toLatLng.latitude, toLatLng.longitude),travelMode: TravelMode.driving );
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
    getpolypoints();
    super.initState();
  }

  bool pageload = true;

  @override
  Widget build(BuildContext context) {
   pageload == false ?null: Future.delayed(Duration(seconds: 2), () {
      pageload = false;
      setState(() { });
    });
    return Scaffold(
      body: Column(
        children: [
        pageload==true
              ? Center(
                  child: Text('L O A D I N G . . . . '),
                )
              : Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                      zoom: CAMERA_ZOOM,
                      tilt: CAMERA_TILT,
                      bearing: CAMERA_BEARING,
                    ),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    // zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    // scrollGesturesEnabled: true,
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
