
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import 'main.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {

  PickResult? fromAddress;
  PickResult? toAddress;

  TextEditingController sourceAddress = TextEditingController();
  TextEditingController destinationAddress = TextEditingController();





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12,right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
      
                    Row(
              children: [
                Expanded(
                    child: TextFormField(
                      maxLines: 4,
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
                                // controller.getVisibleRegion();
                              },
                              onPlacePicked: (PickResult result) {
                                log('lat: ${result.geometry!.location.lat.toString()},  lang: ${result.geometry!.location.lng.toString()}');
                                log("Place picked: ${result.formattedAddress}");
                                setState(() {
                                  fromAddress = result;
                                  sourceAddress.text =
                                      result.formattedAddress!;
                                  Navigator.of(context).pop();
                                });
                              },
                              onMapTypeChanged: (MapType mapType) {
                                log(
                                    "Map type changed to ${mapType.toString()}");
                              },
                            );
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.location_searching,color: Colors.redAccent,))
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                         maxLines: 4,
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
                                  Navigator.of(context).pop();
      
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
                    icon: Icon(Icons.location_searching,color: Colors.redAccent,))
              ],
            ),
          ],
        ),
      ),
      // ),
    );
  }
}