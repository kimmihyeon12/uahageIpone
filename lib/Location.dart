import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Location {
  Map<String, String> getlocator;

  Future getCurrentLocation() async {
    //<Map<String, String>>
    Map<String, String> adminArea = {"Gwangju": "광주", "Jeollanam-do": "전남"};
    Map<String, String> subLocality = {
      "Dong-gu": '동구',
      'Gwangsan-gu': '광산구',
      "Buk-gu": "북구",
      'Nam-gu': "남구",
      "Seo-gu": "서구",
      "Naju": "나주"
    };
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    var Area = adminArea[first.adminArea] ?? "";
    var latitude = position.latitude.toString();
    var longitude = position.longitude.toString();
    var Locality =
        (subLocality[first.subLocality] ?? subLocality[first.locality]) ?? "";
    setLatLong(Area, latitude, longitude, Locality);

    // return location;
  }

  setLatLong(Area, latitude, longitude, Locality) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("uahageLat", latitude);
    sharedPreferences.setString("uahageLong", longitude);
    sharedPreferences.setString("uahageArea", Area);
    sharedPreferences.setString("uahageLocality", Locality);
  }

  getLatLong() async {}
}
