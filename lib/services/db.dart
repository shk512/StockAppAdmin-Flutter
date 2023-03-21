import 'package:cloud_firestore/cloud_firestore.dart';

class DB{
  String id;
  DB({required this.id});

  //REFERENCE
  final companyCollection=FirebaseFirestore.instance.collection("company");
  final companyArrayCollection=FirebaseFirestore.instance.collection("companyArray");

  //save Company
  Future saveCompany(Map<String,dynamic> mapData)async{
    await companyCollection.doc(id).set(mapData);
    return true;
  }

  //Save Company ID in List
  Future saveCompanyId()async{
    await companyArrayCollection.doc("adminArray").update({
      "companyId":FieldValue.arrayUnion([id]),
    });
    return true;
  }

  //Update Package Status
 updatePackageStatus(bool value,String date)async{
    await companyCollection.doc(id).update({
      "isPackageActive":value,
      "packageEndsDate":date
    });
  }

  //Get Company Details
  getCompanyDetails(){
    return companyCollection.doc(id).get();
  }
}