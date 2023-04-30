import 'package:cloud_firestore/cloud_firestore.dart';

class GeoLocationModel{
  static var lat;
  static var lng;

  static Map<String,dynamic> toJson(){
    return {
      "lat":lat,
      "lng":lng
    };
   }
   static fromJson(DocumentSnapshot snapshot){
    lat=snapshot["lat"];
    lng=snapshot["lng"];
   }
}