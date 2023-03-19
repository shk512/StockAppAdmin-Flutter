import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_admin/Model/Company.dart';
import 'package:stock_admin/services/db.dart';

class CompanyDetails extends StatefulWidget {
  final String companyId;
  const CompanyDetails({Key? key,required this.companyId}) : super(key: key);

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {

  @override
  void initState() {
    super.initState();
    getCompanyDetails();
  }
  getCompanyDetails()async{
    await DB(id: widget.companyId).getCompanyDetails().then((val){
      setState(() {
      Company.fromJson(val);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(CupertinoIcons.back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:10,vertical: 5),
          child: Column(
            children: [
              displayFunction("Company Name",Company._companyName,Icon(Icons.warehouse)),
              displayFunction("Email",company.mail,Icon(Icons.email)),
              displayFunction("Package",company.packageType,Icon(Icons.timer)),
              company.packageType=="LifeTime"?Container():displayFunction("Package Ends Date",company.packageEndsDate,Icon(Icons.date_range)),
              SizedBox(height: 20),
              ElevatedButton(onPressed: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Text("Message"),
                    content: Text(company.isPackageActive?"Are you sure to cancel the membership":"Are you sure to enable the membership"),
                    actions: [
                      ElevatedButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text("Cancel")),
                      ElevatedButton(onPressed: (){
                        updatePackage(company.isPackageActive?false:true);
                        Navigator.pop(context);
                      }, child: Text("OK")),
                    ],
                  );
                });
              }, child: Text(company.isPackageActive?"Turn Off Membership":"Turn On Membership"))
            ],
          ),
        ),
      ),
    );
  }
  Widget displayFunction(String title, String value, Icon icon){
    return Row(
      children: [
        Expanded(child: icon),
        SizedBox(width: 10),
        Expanded(child: Text(title,style: TextStyle(fontWeight: FontWeight.bold),)),
        SizedBox(width: 10),
        Expanded(child: Text(value)),

      ],
    );
  }
  updatePackage(bool value)async{
    await DB(id: widget.companyId).updatePackageStatus(value);
    setState(() {

    });
  }
}
