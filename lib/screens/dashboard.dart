import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_admin/utils/routes.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Stream<QuerySnapshot>? company;
  late bool isPackageActive;

  @override
  void initState() {
    super.initState();
    getCompany();
  }
  getCompany(){
    setState(() {
      company=FirebaseFirestore.instance.collection("user").snapshots();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADMIN"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Company"),
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
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: const Text("Company Name"),
                    subtitle: const Text("Owner Name"),
                    trailing: CustomSwitch(
                      value: isPackageActive,
                      activeColor: Colors.cyan,
                      onChanged: (val){
                        isPackageActive=val;
                      },
                    )
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
