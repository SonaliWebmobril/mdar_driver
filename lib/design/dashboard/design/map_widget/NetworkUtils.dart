import 'dart:convert';
import 'dart:collection';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:madr_driver/design/dashboard/controller/accept_ride_controller.dart';

import 'PointLatLng.dart';
import 'PolylinePoints.dart';
import 'PolylineResult.dart';
import 'PolylineWayPoint.dart';

RxString driverDuration = ''.obs;
RxString driverDistance = "".obs;
RxString driverDurationInMinute = "".obs;

class NetworkUtil {
  static const String STATUS_OK = "ok";

  ///Get the encoded string from google directions api
  ///
  Future<PolylineResult> getRouteBetweenCoordinates(
      String googleApiKey,
      PointLatLng origin,
      PointLatLng destination,
      PointLatLng wayLocation,
      TravelMode travelMode,
      List<PolylineWayPoint> wayPoints,
      bool avoidHighways,
      bool avoidTolls,
      bool avoidFerries,
      bool optimizeWaypoints) async {
    String mode = travelMode.toString().replaceAll('TravelMode.', '');

    var params = {
      "origin": "${origin.latitude},${origin.longitude}",
      "destination": "${destination.latitude},${destination.longitude}",
      "waypoints": "${wayLocation.latitude},${wayLocation.longitude}",
      "mode": mode,
      "avoidHighways": "$avoidHighways",
      "avoidFerries": "$avoidFerries",
      "avoidTolls": "$avoidTolls",
      // "alternatives": false,
      "key": googleApiKey
    };
    // if (wayPoints.isNotEmpty) {
    //   List wayPointsArray = [];
    //   wayPoints.forEach((point) => wayPointsArray.add(point.location));
    //   String wayPointsString = wayPointsArray.join('|');
    //   if (optimizeWaypoints) {
    //     wayPointsString = 'optimize:true|$wayPointsString';
    //   }
    //   params.addAll({"waypoints": wayPointsString});
    // }

    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/directions/json", params);

    String url = uri.toString();
    print('GOOGLE MAPS URL: ' + url);
    var response = await http.get(uri);
    PolylineResult result = PolylineResult();
    if (response.statusCode == 200) {
      multipleWayLocation.clear();
      var parsedJson = json.decode(response.body);
      print("parsed json..  " + parsedJson.toString());
      result.status = parsedJson["status"];
      print("parsed json.. result  " + result.status.toString());
      print("parsed json.. result  " + parsedJson["status"]?.toLowerCase());
      print("parsed json.. result  " + parsedJson["routes"].toString());
      if (parsedJson["status"]?.toLowerCase() == STATUS_OK &&
          parsedJson["routes"] != null &&
          parsedJson["routes"].isNotEmpty) {
        print("parsed json.. result  " + parsedJson["routes"].toString());
        List routes = parsedJson["routes"];

        /** Traversing all routes */
        for (int i = 0; i < routes.length; i++) {
          List jLegs = routes[i]["legs"];
          List path = [];
          List<PointLatLng> pointLatLng = [];
          /** Traversing all legs */
          multipleWayLocation.clear();
          for (int j = 0; j < jLegs.length; j++) {
            // result.points.clear();
            driverDuration.value = jLegs[j]["duration"]["text"];
            driverDurationInMinute.value =
                (double.parse(jLegs[j]["duration"]['value'].toString()) / 60)
                    .toStringAsFixed(2);
            driverDistance.value = jLegs[j]["distance"]["text"];
            print("duration...   ${driverDuration.value}");
            List jSteps = jLegs[j]["steps"];
            print("step.. ${jLegs.length}");
            print("step.. ${jLegs.length}");
            /** Traversing all steps */

            for (int k = 0; k < jSteps.length; k++) {
              print("step.. ${jSteps.length}");
              String polyline = "";
              double endPointsLat = 0.0, endPointsLng = 0.0;
              polyline = jSteps[k]["polyline"]["points"];
              endPointsLat = double.parse(
                  (jSteps[k]["end_location"]["lat"]).toStringAsFixed(3));
              endPointsLng = double.parse(
                  (jSteps[k]["end_location"]["lng"]).toStringAsFixed(3));

              multipleWayLocation.add(LatLng((endPointsLat), (endPointsLng)));

              print("multipleWa . network..  $multipleWayLocation");

              List list = decodePoly(polyline);

              /** Traversing all points */
              for (int l = 0; l < list.length; l++) {
                String listData = list[l].toString();
                List listLatLng = listData.split("/");

                String latData = listLatLng[0];
                print("list .. latData  " + latData.toString());
                List latString = latData.split(":");
                String lat = latString[1];
                String lngData = listLatLng[1];
                List lngString = lngData.split(":");
                String lng = lngString[1];

                HashMap<String, double> hm = HashMap();
                hm.putIfAbsent("lat", () => double.parse(lat));
                hm.putIfAbsent("lng", () => double.parse(lng));
                path.add(hm);
                pointLatLng
                    .add(PointLatLng(double.parse(lat), double.parse(lng)));
              }
            }
            result.points = (pointLatLng);
          }
        }

        // result.points = decodeEncodedPolyline(
        //     parsedJson["routes"][0]["legs"][0]["steps"][0]['polyline']['points']);
      } else {
        result.errorMessage = parsedJson["error_message"];
      }
    }
    return result;
  }

  ///decode the google encoded string using Encoded Polyline Algorithm Format
  /// for more info about the algorithm check https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  ///
  ///return [List]
  /* List<PointLatLng> decodeEncodedPolyline(String encoded) {
    List<PointLatLng> poly = [];
    int index = 0,
        len = encoded.length;
    int lat = 0,
        lng = 0;

    while (index < len) {
      int b,
          shift = 0,
          result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      PointLatLng p =
      new PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }*/

  List<PointLatLng> decodePoly(String encoded) {
    List<PointLatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      PointLatLng position =
          new PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(position);
    }
    return poly;
  }
}
