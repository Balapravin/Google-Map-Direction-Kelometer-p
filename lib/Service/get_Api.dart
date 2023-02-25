// ignore_for_file: prefer_interpolation_to_compose_strings, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:truckotruck/model/GoogleMapTrackerData_Model.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";

class CommonGetApiService {
  Future<GoogleMapVeicleTrackingModel?> gettrucklocation() async {
    final response = await http.post(
        Uri.parse('https://truckotruckuat.meark.org/api/leave/getData'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "from_date_time": "2023-01-09",
          "to_date_time": "2023-01-10",
          "tipper_id": 0,
          "start": 0,
          "end": 100
        }));

    try {
      if (response.statusCode == 200) {
        // log('message ---> ${response.body}');
        return googleMapVeicleTrackingFromJson(response.body);
      } else {
        return googleMapVeicleTrackingFromJson(response.body);
      }
    } catch (e) {
      log('catch : $e');
      return null;
    }
  }

  List<GoogleMapViewData>? tipperDetails = [];
  List<GoogleMapViewData>? excavatorDetails = [];

  List<LatLng> latLen = [];

  void getmapDetails() {
    gettrucklocation().then(
      (value) {
// if(value!.mapData!.tipperDetails!.isEmpty && value.mapData!.excavatorDetails!.isEmpty ){
//   tipperDetails = [];
//  excavatorDetails = [];
// }else{
//   tipperDetails = [];
//  excavatorDetails = [];
//  tipperDetails = [...value.mapData!.tipperDetails!];
//  excavatorDetails = [...value.mapData!.excavatorDetails!];

// }

// final latdata=[];
// final langdata=[];
//           for (var tipper in value!.mapData!.tipperDetails!) {
//             final splitdatalat=tipper.latitude!.split(',');
//             final splitdatalang=tipper.longitude!.split(',');
//           latdata.add(splitdatalat);
//           langdata.add(splitdatalang);
//           }
//           final data=[];

// for (var i = 0; i < latdata.length; i++) {
//   for (var j = 0; j < latdata[i].length; j++) {
//     // log(latdata[i][j]);
//     var doubledata = LatLng(double.parse(latdata[i][j]), double.parse(langdata[i][j]));
//     data.add(doubledata);
//   }
// }
// log(data.toString());

//===================================

        final tipperDetails = value!.mapData!.tipperDetails!;
        final excavatorDetails = value.mapData!.excavatorDetails!;
  // var groupingData = localData.groupListsBy((element) => element.itemid);
     var group = groupBy(tipperDetails , ( e) => e.tipperId);

        List<GoogleMapViewData> googleMapViewData = [];
LatLng? latLng;
String? mapdate;
 String ?maptime;
String? mapstatus;
 String?mapdirection;
 log(group.toString());
     group.forEach((key, value) { 
           List<String> latitudes = value[0].latitude!.split(', ');
          List<String> longitudes =
              value[0].longitude!.split(', ');
          List<String> date = value[0].trackTime!.split(', ');
          List<String> status = value[0].state!.split(', ');
          List<String> direction =
              value[0].direction!.split(', ');
              List<LatLng> latlong =[];
              for(int i = 0;i<latitudes.length;i++){
            double lat =
                double.parse((latitudes[i]).replaceAll(RegExp(r'[^0-9.]'), ''));
            double lng = double.parse(
                (longitudes[i]).replaceAll(RegExp(r'[^0-9.]'), ''));
             latLng = LatLng(lat, lng);
             latlong.add(latLng!);
             googleMapViewData.add(GoogleMapViewData(polyline: latlong));
              }
            //  mapdate = DateFormat("dd-MMM-yyyy").format(DateTime.parse(date[i]));
            //  maptime = DateFormat("hh:mm a").format(DateTime.parse(date[i]));
            //  mapstatus = status[i];
            //  mapdirection = status[i];
print(googleMapViewData);

      // final data= GoogleMapViewData(
      //   date: date, 
      //   time: time, 
      //   status: status, 
      //   direction: direction, 
      //   marker: marker, 
      //   polyline: polyline);
      //   googleMapViewData.add(data);

        //=================
          //       for (int i = 0; i < value.length ; i++) {
          //             List<String> latitudes = value[i].latitude!.split(', ');
          // List<String> longitudes =
          //     value[i].longitude!.split(', ');
          // List<String> date = value[i].trackTime!.split(', ');
          // List<String> status = value[i].state!.split(', ');
          // List<String> direction =
          //     value[i].direction!.split(', ');
          //   double lat =
          //       double.parse((latitudes[i]).replaceAll(RegExp(r'[^0-9.]'), ''));
          //   double lng = double.parse(
          //       (longitudes[i]).replaceAll(RegExp(r'[^0-9.]'), ''));
          //    latLng = LatLng(lat, lng);
          //    mapdate = DateFormat("dd-MMM-yyyy").format(DateTime.parse(date[i]));
          //    maptime = DateFormat("hh:mm a").format(DateTime.parse(date[i]));
          //    mapstatus = status[i];
          //    mapdirection = status[i];
          //    log(latLng.toString());
          //   googleMapViewData.add(GoogleMapViewData(
          //       date: 'mapdate',
          //       time: 'maptime',
          //       status: mapstatus!,
          //       direction: mapdirection!,
          //       marker: latLng!,
          //       polyline: LatLng(1, 1)));

          // }
        });

     });
//         for (var details = 0; details < tipperDetails.length; details++) {
//           List<String> latitudes = tipperDetails[details].latitude!.split(', ');
//           List<String> longitudes =
//               tipperDetails[details].longitude!.split(', ');
//           List<String> date = tipperDetails[details].trackTime!.split(', ');
//           List<String> status = tipperDetails[details].state!.split(', ');
//           List<String> direction =
//               tipperDetails[details].direction!.split(', ');

//               //==================

               

//               //=================

        //   for (int i = 0; i < latitudes.length - 1; i++) {
            // double lat =
            //     double.parse((latitudes[i]).replaceAll(RegExp(r'[^0-9.]'), ''));
            // double lng = double.parse(
            //     (longitudes[i]).replaceAll(RegExp(r'[^0-9.]'), ''));
            //  latLng = LatLng(lat, lng);
        //     //  mapdate = DateFormat("dd-MMM-yyyy").format(DateTime.parse(date[i]));
        //     //  maptime = DateFormat("hh:mm a").format(DateTime.parse(date[i]));
        //      mapstatus = status[i];
        //      mapdirection = status[i];
             
        //     googleMapViewData.add(GoogleMapViewData(
        //         date: 'mapdate',
        //         time: 'maptime',
        //         status: mapstatus,
        //         direction: mapdirection,
        //         marker: latLng,
        //         polyline: LatLng(1, 1)));

        //   }
        // }
        // log(group.toString());
      // },
    // );
  }
}

class GoogleMapViewData {
  String? date;
  String? time;
  String? status;
  String? direction;
 List<LatLng> ?marker;
  List<LatLng> ?polyline;

  GoogleMapViewData(
      { this.date,
       this.time,
       this.status,
       this.direction,
       this.marker,
       this.polyline});
}