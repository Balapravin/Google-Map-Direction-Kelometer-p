// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  PinInformation? sourcePinInfo;
  PinInformation? destinationPinInfo;
  double CAMERA_ZOOM = 13;
  double CAMERA_TILT = 0;
  double CAMERA_BEARING = 30;
  LatLng SOURCE_LOCATION = LatLng(11.03881588126287, 77.01362222601809);
  LatLng DEST_LOCATION = LatLng(11.067874684255145, 77.0411905117804);

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/t_unload.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/t_rest.png');
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setMapPins();
  }

  void setMapPins() {
    // add the source marker to the list of markers
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: SOURCE_LOCATION,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo!;
            pinPillPosition = 0;
          });
        },
        icon: sourceIcon!));
    // populate the sourcePinInfo object
    sourcePinInfo = PinInformation(
        locationName: 'Start Location',
        location: SOURCE_LOCATION,
        pinPath: 'assets/e_unload.png',
        avatarPath: 'assets/t_unload.png',
        labelColor: Colors.blueAccent);
    // add the destination marker to the list of markers
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: DEST_LOCATION,
        onTap: () {
          setState(() {
            currentlySelectedPin = destinationPinInfo!;
            pinPillPosition = 0;
          });
        },
        icon: destinationIcon!));
    destinationPinInfo = PinInformation(
        locationName: 'End Location',
        location: DEST_LOCATION,
        pinPath: 'assets/t_unload.png',
        avatarPath: 'assets/e_unload.png',
        labelColor: Colors.purple);
  }

  @override
  Widget build(context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        markers: _markers,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: SOURCE_LOCATION,
          zoom: 16.0,
        ),
        onMapCreated: onMapCreated,
        onTap: (LatLng location) {
          setState(() {
            pinPillPosition = -100;
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
                    width: 50,
                    height: 50,
                    child: ClipOval(
                        child: Image.asset(currentlySelectedPin.avatarPath!,
                            fit: BoxFit.cover))), // first widget
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(currentlySelectedPin.locationName!,
                            style: TextStyle(
                                color: currentlySelectedPin.labelColor)),
                        Text(
                            'Latitude: ${currentlySelectedPin.location!.latitude.toString()}',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(
                            'Longitude: ${currentlySelectedPin.location!.longitude.toString()}',
                            style: TextStyle(fontSize: 12, color: Colors.grey))
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Image.asset(currentlySelectedPin.pinPath!,
                        width: 50, height: 50))
              ],
            ),
          ),
        ),
      )
    ]));
  }
}

class PinInformation {
  String? pinPath;
  String? avatarPath;
  LatLng? location;
  String? locationName;
  Color? labelColor;
  PinInformation(
      {this.pinPath,
      this.avatarPath,
      this.location,
      this.locationName,
      this.labelColor});
}
