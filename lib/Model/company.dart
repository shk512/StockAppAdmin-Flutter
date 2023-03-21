

import 'package:cloud_firestore/cloud_firestore.dart';

class Company{
  static String companyId="";
  static String companyName="";
  static String contact="";
  static String whatsapp="";
  static String city="";
  static String packageType="";
  static String packageEndsDate="";
  static bool isPackageActive=true;
  static List employee=[];
  static List area=[];

  Company(String contact1, String whatsapp1,String companyId1,String packageEndsDate1,String packageType1,String city1,String companyName1){
    contact=contact1;
    whatsapp=whatsapp1;
    companyId=companyId1;
    packageEndsDate=packageEndsDate1;
    packageType=packageType1;
    city=city1;
    companyName=companyName1;
  }

  Map<String,dynamic> toJson(){
   return {
     "companyId":companyId,
     "contact":contact,
     "whatsApp":whatsapp,
     "companyName":companyName,
     "city":city,
     "packageType":packageType,
     "packageEndsDate":packageEndsDate,
     "isPackageActive":isPackageActive,
     "employeeUsername":employee,
     "area":area
   };
  }

  static fromJson(DocumentSnapshot mapData){
    companyId=mapData['companyId'];
    contact=mapData['contact'];
    whatsapp=mapData['whatsApp'];
    isPackageActive= mapData['isPackageActive'];
    packageEndsDate= mapData['packageEndsDate'];
    packageType= mapData['packageType'];
    city= mapData['city'];
    companyName= mapData['companyName'];
  }
}