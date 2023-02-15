import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:location/location.dart';

class DefaultApp extends StatefulWidget {
  @override
  _DefaultAppState createState() => _DefaultAppState();
}

class _DefaultAppState extends State<DefaultApp> {
  Completer<GoogleMapController>? _controller = Completer();
  Location _location = Location();
  LatLng? _currentLocation;
  List<LatLng> _polylineCoordinates = [
    LatLng(11.025307284410333, 77.01051900642669),
  ];
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((locationData) {
      setState(() {
        _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
        _polylineCoordinates[0] = _currentLocation!;
        _polylines = Set.from([
          Polyline(
            polylineId: PolylineId('polyline'),
            color: Colors.blue,
            width: 5,
            points: _polylineCoordinates,
          ),
        ]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        compassEnabled: true,
        initialCameraPosition: CameraPosition(
          target: _currentLocation ?? LatLng(11.025307284410333, 77.01051900642669),
          zoom: 15,
        ),
         mapType: MapType.normal,
         myLocationEnabled: true,
         // zoomGesturesEnabled: true,
         zoomControlsEnabled: true,
         // scrollGesturesEnabled: true,
        polylines: _polylines,
        markers: {
          Marker(
            markerId: MarkerId('Source Location'),
            position: _currentLocation ?? LatLng(11.025307284410333, 77.01051900642669),
            infoWindow: InfoWindow(
              title: 'Start Location',
              snippet: 'Driver here',
            ),
          ),
          Marker(
            markerId: MarkerId('Destination Location'),
            position:LatLng(11.025307284410333, 77.01051900642669),
            infoWindow: InfoWindow(
              title: 'Destination Location',
            ),
          ),

        },
        onMapCreated: (GoogleMapController controller) {
          _controller!.complete(controller);
        },
      ),
    );
  }
}
