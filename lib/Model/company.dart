class Company{
  static String companyId="";
  static String companyName="";
  static String city="";
  static String packageType="";
  static String packageEndsDate="";
  static bool isPackageActive=true;
  static List employee=[];
  static List area=[];

  Company(String packageEndsDate1,String packageType1,String city1,String companyName1){
    packageEndsDate=packageEndsDate1;
    packageType1=packageType;
    city=city1;
    companyName=companyName1;
  }

  Map<String,dynamic> toJson(){
   return {
     "companyId":companyId,
     "companyName":companyName,
     "city":city,
     "packageType":packageType,
     "packageEndsDate":packageEndsDate,
     "isPackageActive":isPackageActive,
     "employeeUsername":employee,
     "area":area
   };
  }

  static fromJson(Map<String,dynamic> mapData){
    companyId=mapData['companyId'];
    isPackageActive= mapData['isPackageActive'];
    packageEndsDate= mapData['packageEndsDate'];
    packageType= mapData['packageType'];
    city= mapData['city'];
    companyName= mapData['companyName'];
  }
}