import 'dart:js_util';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'geolocation_model.dart';

class CompanyModel{
  String _companyId='';
  String _companyName='';
  String _contact='';
  String _packageEndsDate='';
  String _packageType='';
  String _whatsApp='';
  String _city='';
  num _wallet=0;
  bool _isPackageActive=false;
  List _area=[];
  GeoLocationModel _geoLocationModel=newObject();

  GeoLocationModel get geoLocationModel => _geoLocationModel;

  set geoLocationModel(GeoLocationModel value) {
    _geoLocationModel = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get packageType => _packageType;

  set packageType(String value) {
    _packageType = value;
  }

  num get wallet => _wallet;

  set wallet(num value) {
    _wallet = value;
  }

  String get companyId => _companyId;

  set companyId(String value) {
    _companyId = value;
  }

  String get companyName => _companyName;

  set companyName(String value) {
    _companyName = value;
  }

  String get contact => _contact;

  set contact(String value) {
    _contact = value;
  }

  String get packageEndsDate => _packageEndsDate;

  set packageEndsDate(String value) {
    _packageEndsDate = value;
  }

  bool get isPackageActive => _isPackageActive;

  set isPackageActive(bool value) {
    _isPackageActive = value;
  }

  List get area => _area;

  set area(List value) {
    _area = value;
  }

  String get whatsApp => _whatsApp;

  set whatsApp(String value) {
    _whatsApp = value;
  }

  Map<String,dynamic> toJson({
    required String companyId,
    required String companyName,
    required String contact,
    required String whatsApp,
    required String packageEndsDate,
    required String packageType,
    required String city,
    required num wallet,
    required List area,
    required bool isPackageActive
    })
  {
    return<String,dynamic>{
      "companyId": companyId,
      "companyName":companyName,
      "isPackageActive":isPackageActive,
      "contact":contact,
      "packageEndsDate":packageEndsDate,
      "area":area,
      "wallet":wallet,
      "whatsApp":whatsApp,
      "packageType":packageType,
      "city":city,
      "geoLocation":{
        "lat":geoLocationModel.lat,
        "lng":geoLocationModel.lng
      }
    };
  }

  CompanyModel.fromJson(DocumentSnapshot? snapshot){
    companyId=snapshot!['companyId'];
    contact=snapshot['contact'];
    isPackageActive= snapshot['isPackageActive'];
    packageEndsDate= snapshot['packageEndsDate'];
    companyName= snapshot['companyName'];
    area=snapshot['area'];
    wallet=snapshot['wallet'];
    packageType=snapshot["packageType"];
    whatsApp=snapshot["whatsApp"];
    city=snapshot["city"];
    geoLocationModel.lat=snapshot["geolocation"]["lat"];
    geoLocationModel.lng=snapshot["geolocation"]["lng"];
  }

}