// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:truckotruck/model/GoogleMapTrackerData_Model.dart';

class CommonGetApiService {
  Future<GoogleMapVeicleTrackingModel?> gettrucklocation() async {
    final response = await http.post(
        Uri.parse('https://truckotruckuat.meark.org/api/leave/getData'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "from_date_time": "2022-09-01",
          "to_date_time": "2023-02-01",
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

  List<TipperDetail>? tipperDetails = [];
  List<ExcavatorDetail>? excavatorDetails = [];

  List<LatLng> latLen=[];

  void getmapDetails() {
    gettrucklocation().then(
      (value) {
       
          // log("excavatorDetails : ${value!.mapData!.tipperDetails![0].latDirection!}");

final latdata=[];
final langdata=[];
          for (var tipper in value!.mapData!.tipperDetails!) {
            final splitdatalat=tipper.latitude!.split(',');            
            final splitdatalang=tipper.longitude!.split(',');
          latdata.add(splitdatalat);
          langdata.add(splitdatalang);            
          }

          // for (var splitlatdata in latdata) {
            log(langdata.length.toString());
          //  }

              // print(latLen);

      },
    );
  }
}






//  PaymentData? paymentDataFinal;

//   void paymentDataConcadinating(
//     List<AddFeeItems> localDetails,
//   ) {
//     print(localDetails);
//     List<FeeDatum> feeFinalData = [];
//     paymentDataFinal = null;
//     feeFinalData = [];
//     List<FeeItem> alldataShow = [];
//     alldataShow = [];
//     //-----------------------
//     for (int i = 0; i < localDetails.length; i++) {
//       final data = localDetails[i].type == "Admission"
//           ? FeeItem(
//               itemid: localDetails[i].itemId,
//               type: localDetails[i].itemType,
//               id: localDetails[i].id.toString(),
//               amount: localDetails[i].amount,
//               name: localDetails[i].name,
//               markaspaid: "false",
//               exempt: '',
//               onetime: "true")
//           : FeeItem(
//               itemid: localDetails[i].itemId,
//               type: localDetails[i].itemType,
//               id: localDetails[i].id.toString(),
//               amount: localDetails[i].amount,
//               name: localDetails[i].name,
//               markaspaid: "false",
//               exempt: "false",
//               onetime: '');
//       alldataShow.add(data);
//     }
//     //==========================
//     var localData = alldataShow;

//     var groupingData = localData.groupListsBy((element) => element.itemid);

//     //------------ Fee Data Concatenate -----------
//     groupingData.forEach((key, value) {
//       final data = FeeDatum(
//           id: value[0].type == 'Admission'
//               ? 'pta${key.toString()}'
//               : 'pt${key.toString()}',
//           type: value[0].type + '-' + key.toString(),
//           typename: value[0].type,
//           items: [...value]);
//       feeFinalData.add(data);
//     });

//     //----- PaymentData concadinate -------

//     var data = PaymentData(
//         description: '',
//         payingAmt: widget.total,
//         paymentMode: "Online",
//         number: transactionID!,
//         paymentDate: DateTime.now().day.toString() +
//             '-' +
//             DateTime.now().month.toString() +
//             '-' +
//             DateTime.now().year.toString(),
//         feeData: [...feeFinalData]);
//     paymentDataFinal = data;
//   }
// }