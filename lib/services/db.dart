import 'package:cloud_firestore/cloud_firestore.dart';

class DB{
  String id;
  DB({required this.id});

  //REFERENCE
  final companyCollection=FirebaseFirestore.instance.collection("company");
  //save Company
  Future saveCompany(Map<String,dynamic> mapData)async{
    await companyCollection.doc(id).set(mapData);
    return true;
  }

  //Update Package Status
 updatePackageStatus(bool value)async{
    await companyCollection.doc(id).update({
      "isPackageActive":value,
    });
  }

  //Get Company Details
  getCompanyDetails(){
    return companyCollection.doc(id).get();
  }
}