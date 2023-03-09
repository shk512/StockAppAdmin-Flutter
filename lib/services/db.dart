import 'package:cloud_firestore/cloud_firestore.dart';

class DB{
  String id;
  DB({required this.id});

  //REFERENCE
  final companyCollection=FirebaseFirestore.instance.collection("company");
  //save Company
  Future saveCompany(String companyName,String email, String packageType, String packageEndsDate)async{
    await companyCollection.doc(id).set({
      "companyName":companyName,
      "companyId":id,
      "userRole":"admin",
      "mail":email,
      "packageType":packageType,
      "packageEndsDate":packageEndsDate,
      "employee":[],
      "area":[]
    });
    return true;
  }
}