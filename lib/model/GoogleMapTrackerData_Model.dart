// To parse this JSON data, do
//
//     final googleMapVeicleTracking = googleMapVeicleTrackingFromJson(jsonString);

import 'dart:convert';

GoogleMapVeicleTrackingModel googleMapVeicleTrackingFromJson(String str) => GoogleMapVeicleTrackingModel.fromJson(json.decode(str));

String googleMapVeicleTrackingToJson(GoogleMapVeicleTrackingModel data) => json.encode(data.toJson());

class GoogleMapVeicleTrackingModel {
    GoogleMapVeicleTrackingModel({
        this.code,
        this.status,
        this.mapData,
    });

    int? code;
    bool? status;
    MapData? mapData;
    
    factory GoogleMapVeicleTrackingModel.fromJson(Map<String, dynamic> json) => GoogleMapVeicleTrackingModel(
        code: json["code"],
        status: json["status"],
        mapData: json["data"] == null ? null : MapData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": mapData?.toJson(),
    };
}

class MapData {
    MapData({
        this.tipperDetails,
        this.excavatorDetails,
    });

    List<TipperDetail>? tipperDetails;
    List<ExcavatorDetail>? excavatorDetails;

    factory MapData.fromJson(Map<String, dynamic> json) => MapData(
        tipperDetails: json["Tipper_details"] == null ? [] : List<TipperDetail>.from(json["Tipper_details"]!.map((x) => TipperDetail.fromJson(x))),
        excavatorDetails: json["Excavator_details"] == null ? [] : List<ExcavatorDetail>.from(json["Excavator_details"]!.map((x) => ExcavatorDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Tipper_details": tipperDetails == null ? [] : List<dynamic>.from(tipperDetails!.map((x) => x.toJson())),
        "Excavator_details": excavatorDetails == null ? [] : List<dynamic>.from(excavatorDetails!.map((x) => x.toJson())),
    };
}

class ExcavatorDetail {
    ExcavatorDetail({
        this.excavatorId,
        this.trackTime,
        this.latitude,
        this.longitude,
        this.latDirection,
        this.longDirection,
        this.locationId,
        this.direction,
        this.state,
        this.tipperState,
    });

    String? excavatorId;
    String? trackTime;
    String? latitude;
    String? longitude;
    String? latDirection;
    String? longDirection;
    String? locationId;
    String? direction;
    String? state;
    String? tipperState;

    factory ExcavatorDetail.fromJson(Map<String, dynamic> json) => ExcavatorDetail(
        excavatorId: json["excavator_id"],
        trackTime: json["trackTime"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        latDirection: json["lat_direction"],
        longDirection: json["long_direction"],
        locationId: json["location_id"],
        direction: json["direction"],
        state: json["state"],
        tipperState: json["tipperState"],
    );

    Map<String, dynamic> toJson() => {
        "excavator_id": excavatorId,
        "trackTime": trackTime,
        "latitude": latitude,
        "longitude": longitude,
        "lat_direction": latDirection,
        "long_direction": longDirection,
        "location_id": locationId,
        "direction": direction,
        "state": state,
        "tipperState": tipperState,
    };
}

class TipperDetail {
    TipperDetail({
        this.tipperId,
        this.trackTime,
        this.latitude,
        this.longitude,
        this.latDirection,
        this.longDirection,
        this.direction,
        this.state,
    });

    String? tipperId;
    String? trackTime;
    String? latitude;
    String? longitude;
    String? latDirection;
    String? longDirection;
    String? direction;
    String? state;

    factory TipperDetail.fromJson(Map<String, dynamic> json) => TipperDetail(
        tipperId: json["tipper_id"],
        trackTime: json["trackTime"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        latDirection: json["lat_direction"],
        longDirection: json["long_direction"],
        direction: json["direction"],
        state: json["state"],
    );

    Map<String, dynamic> toJson() => {
        "tipper_id": tipperId,
        "trackTime": trackTime,
        "latitude": latitude,
        "longitude": longitude,
        "lat_direction": latDirection,
        "long_direction": longDirection,
        "direction": direction,
        "state": state,
    };
}

