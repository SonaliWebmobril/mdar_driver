import 'NetworkUtils.dart';
import 'PointLatLng.dart';
import 'PolylineResult.dart';
import 'PolylineWayPoint.dart';


enum TravelMode { driving, bicycling, transit, walking }

class PolylinePoints {
  NetworkUtil util = NetworkUtil();

  /// Get the list of coordinates between two geographical positions
  /// which can be used to draw polyline between this two positions
  ///

  ///
  Future<PolylineResult> getRouteBetweenCoordinates(
      String googleApiKey, PointLatLng origin,
      PointLatLng destination,
      PointLatLng wayLocation,
      {TravelMode travelMode = TravelMode.driving,
        List<PolylineWayPoint> wayPoints = const [],
        bool avoidHighways = false,
        bool avoidTolls = false,
        bool avoidFerries = true,
        bool optimizeWaypoints = false}) async {
    return await util.getRouteBetweenCoordinates(
        googleApiKey,
        origin,
        destination,
        wayLocation,
        travelMode,
        wayPoints,
        avoidHighways,
        avoidTolls,
        avoidFerries,
        optimizeWaypoints);
  }

  /// Decode and encoded google polyline
  /// e.g "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
  ///
  List<PointLatLng> decodePolyline(String encodedString) {
    return util.decodePoly(encodedString);
  }
}
