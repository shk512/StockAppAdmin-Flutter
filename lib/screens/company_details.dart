import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_admin/Model/company.dart';
import 'package:stock_admin/services/db.dart';
import 'package:stock_admin/utils/snackbar.dart';

class CompanyDetails extends StatefulWidget {
  final String companyId;
  const CompanyDetails({Key? key,required this.companyId}) : super(key: key);

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  var mapData;
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
        title: const Text("Details",style:  TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 2),),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(CupertinoIcons.back,color: Colors.white,)),
      ),
      body: SingleChildScrollView(
          child: Company.companyId!=""
              ?Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              displayFunction("ID", Company.companyId, const Icon(Icons.perm_identity)),
              displayFunction("Company Name",Company.companyName,const Icon(Icons.warehouse)),
              displayFunction("City",Company.city,const Icon(Icons.location_city_outlined)),
              displayFunction("Status", Company.isPackageActive?"Active":"InActive", const Icon(Icons.notifications_active)),
              displayFunction("Contact", Company.contact, const Icon(Icons.phone)),
              displayFunction("WhatsApp", Company.whatsapp, const Icon(Icons.chat)),
              displayFunction("Package",Company.packageType,const Icon(Icons.timer)),
              Company.packageType=="LifeTime"?Container():displayFunction("Package Ends Date",Company.packageEndsDate,const Icon(Icons.date_range)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: const Text("Message"),
                    content: Text(Company.isPackageActive?"Are you sure to cancel the membership":"Are you sure to enable the membership"),
                    actions: [
                      ElevatedButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: const Text("Cancel")),
                      ElevatedButton(onPressed: (){
                        updatePackage(Company.isPackageActive?false:true);
                        Navigator.pop(context);
                      }, child: const Text("OK")),
                    ],
                  );
                });
              }, child: Text(Company.isPackageActive?"Turn Off Membership":"Turn On Membership"))
            ],
          )
          :Center(child: const CircularProgressIndicator()),
        ),
    );
  }
  Widget displayFunction(String title, String value, Icon icon){
    return Row(
      children: [
        Expanded(child: icon),
        const SizedBox(width: 4),
        Expanded(child: Text(title,style: const TextStyle(fontWeight: FontWeight.bold),)),
        const SizedBox(width: 10),
        Expanded(child: Text(value)),

      ],
    );
  }
  updatePackage(bool value)async{
    await DB(id: widget.companyId).updatePackageStatus(value);
    setState(() {
      Company.isPackageActive=value;
    });
    showSnackbar(context, Colors.cyan,Company.isPackageActive?"Package has been active":"Package has been in-active");
  }
}
