class Company{
  late String companyName;
  late String email;
  late String packageType;
  late String packageEndsDate;
  late bool isPackageActive ;
  late String companyId;
  Company({required this.isPackageActive,required this.companyId,required this.packageEndsDate,required this.packageType,required this.email,required this.companyName});

  Map<String,dynamic> toJson(){
   return {
     "companyName":companyName,
     "companyId":companyId,
     "mail":email,
     "packageType":packageType,
     "packageEndsDate":packageEndsDate,
     "isPackageActive":isPackageActive,
     "employeeUsername":[],
     "area":[]
   };
  }

  factory Company.fromJson(Map<String,dynamic> mapData){
   return Company(
       isPackageActive: mapData['isPackageActive'],
       companyId: mapData['companyId'].toString(),
       packageEndsDate: mapData['packageEndsDate'].toString(),
       packageType: mapData['packageType'].toString(),
       email: mapData['mail'].toString(),
       companyName: mapData['companyName'].toString()
   );
  }
}