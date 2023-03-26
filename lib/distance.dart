import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class DistanceService {
   static double findDistance(LatLng from, LatLng to) {
    var lat1 = toRadian(from.latitude);
    var lng1 = toRadian(from.longitude);
    var lat2 = toRadian(to.latitude);
    var lng2 = toRadian(to.longitude);

    // Haversine Formula
    var dlong = lng2 - lng1;
    var dlat = lat2 - lat1;

    var res = pow(sin((dlat / 2)), 2) +
        cos(lat1) * cos(lat2) * pow(sin(dlong / 2), 2);
    res = 2 * asin(sqrt(res));
    double R = 6371;
    res = res * R;
    return res;
  }

  static double toRadian(double val) {
    double one_deg = (pi) / 180;
    return (one_deg * val);
  }
}
