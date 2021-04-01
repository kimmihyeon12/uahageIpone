import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocationProvider extends ChangeNotifier{
  String _latitude ;
  String _longitude ;
  String get getlatitude => _latitude;
  String get getlongitude => _longitude;


  Future setCurrentLocation() async {
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



    LocationPermission  permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();


      if (permission == LocationPermission.denied) {
        _latitude ='35.146076';
        _longitude = '126.9231225';
        return print(
            'Location permissions are denied');
      }
    }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final coordinates = new Coordinates(position.latitude, position.longitude);
      var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      var Area = adminArea[first.adminArea] ?? "";
      var latitude = position.latitude.toString();
      var longitude = position.longitude.toString();
      var Locality =
          (subLocality[first.subLocality] ?? subLocality[first.locality]) ?? "";

      _latitude = latitude;
      _longitude = longitude;






  }
}