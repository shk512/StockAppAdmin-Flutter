import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stock_admin/screens/company_details.dart';
import 'package:stock_admin/utils/routes.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Stream<QuerySnapshot>? company;
  bool isPackageActive=false;

  @override
  void initState() {
    super.initState();
    getCompany();
  }
  getCompany(){
    setState(() {
      company=FirebaseFirestore.instance.collection("company").snapshots();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("ADMIN",style:  TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 2),),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Company"),
        onPressed: (){
          Navigator.pushNamed(context, Routes.companyRegister);
        },
      ),
      body: StreamBuilder(
        stream: company,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasError){
            return const Center(
              child: Text("Error"),
            );
          }
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(!snapshot.hasData){
            return const Center(child: Text("No Data Found"),);
          }
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context,index){
                  return ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CompanyDetails(companyId: snapshot.data.docs[index]['companyId'])));
                    },
                    title: Text("${snapshot.data.docs[index]['companyName']} - ${snapshot.data.docs[index]['city']}"),
                    subtitle: Text("${snapshot.data.docs[index]['companyId']}"),
                    trailing: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: snapshot.data.docs[index]['isPackageActive']?Colors.green:Colors.red,
                      ),
                    ),
                  );
                });
          }else{
            return const Center(
              child: Text("No Data Found"),
            );
          }
        }
      ),
    );
  }
}
