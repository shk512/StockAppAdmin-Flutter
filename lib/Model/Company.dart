class Company{
  late final String companyName;
  late final String email;
  late final String packageType;
  late final String packageEndsDate;
  late final bool isPackageActive ;
  late final String companyId;
  late final List<String> employee;
  late final List<String> area;

  static late String _companyName;
  static late String _email;
  static late String _packageType;
  static late String _packageEndsDate;
  static late bool _isPackageActive;
  static late String _companyId;
  static late List<String> _employee;
  static late List<String> _area;
  Company({required this.area,required this.employee,required this.isPackageActive,required this.companyId,required this.packageEndsDate,required this.packageType,required this.email,required this.companyName});

  Map<String,dynamic> toJson(){
   return {
     "companyName":companyName,
     "companyId":companyId,
     "mail":email,
     "packageType":packageType,
     "packageEndsDate":packageEndsDate,
     "employeeUsername":employee,
     "area":area,
     "isPackageActive":isPackageActive
   };
  }

  Company.fromJson(Map<String,dynamic> mapData){
    isPackageActive=mapData['isPackageActive'];
    _companyId=mapData['companyId'];
    _email=mapData['mail'];
    _companyName=mapData['companyName'];
    _packageType=mapData['packageType'];
    _packageEndsDate=mapData['packageEndsDate'];
    _employee=mapData['employeeUsername'];
    _area=mapData['area'];
  }
}