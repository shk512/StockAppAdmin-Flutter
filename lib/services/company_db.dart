import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyDb{
  String id;
  CompanyDb({required this.id});

  //Reference Collection
  final companyCollection=FirebaseFirestore.instance.collection("company");

  //save Company
  Future saveCompany(Map<String,dynamic> mapData)async{
    await companyCollection.doc(id).set(mapData);
    await FirebaseFirestore.instance.collection("companyArray").doc("adminArray").update({
      "companyId":FieldValue.arrayUnion([id])
    });
    return true;
  }

  //Get Company Data
  Future getCompanyData()async{
    return await companyCollection.doc(id).get();
  }

  //Update the Company Data
  Future updateCompany (Map<String,dynamic> mapData)async{
    await companyCollection.doc(id).update(mapData);
  }

  //get the company
  Future getCompany()async{
    return await companyCollection.snapshots();
  }
}