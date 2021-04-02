import 'dart:math';

distancePoints(lat1, lon1, lat2, lon2) async {
  var p = 0.017453292519943295; // Math.PI / 180
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

  return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
}
