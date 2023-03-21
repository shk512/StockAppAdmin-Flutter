import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_admin/Model/company.dart';
import 'package:stock_admin/services/db.dart';
import 'package:stock_admin/utils/snackbar.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class CompanyDetails extends StatefulWidget {
  final String companyId;
  const CompanyDetails({Key? key,required this.companyId}) : super(key: key);

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  var mapData;
  TextEditingController date=TextEditingController();
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
          child: Center(
            child:Company.companyId!=""
                ?Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
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
                      Company.packageType=="LifeTime"||Company.packageEndsDate==""?Container():displayFunction("Package Ends Date",Company.packageEndsDate,const Icon(Icons.date_range)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: ()async{
                            if(!Company.isPackageActive&&Company.packageType=="LifeTime"){
                              updatePackage(true, "");
                            } else if(!Company.isPackageActive) {
                              DateTime? datePicker = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100));
                                if (datePicker != null) {
                                  setState(() {
                                    date.text =
                                    DateFormat("dd-MM-yyyy").format(datePicker);
                                  });
                             updatePackage(true, date.text);
                          }
                        }else{
                          updatePackage(false, "");
                        }
                        }, child: Text(Company.isPackageActive?"Turn Off Membership":"Turn On Membership")),
                      const SizedBox(height: 20,),
                      ElevatedButton(onPressed: (){
                        shareId();
                      }, child: const Text("Share Id"))
            ],
          ),
                )
          :const CircularProgressIndicator()),
        ),
    );
  }
  Widget displayFunction(String title, String value, Icon icon){
    return Row(
      children: [
        Expanded(flex:1,child: icon),
        Expanded(flex:2,child: Text(title,style: const TextStyle(fontWeight: FontWeight.bold),)),
        Expanded(flex:2,child: Text(value)),
      ],
    );
  }
  updatePackage(bool value,String date)async{
    await DB(id: widget.companyId).updatePackageStatus(value,date);
    setState(() {
      Company.isPackageActive=value;
      Company.packageEndsDate=date;
    });
    showSnackbar(context, Colors.cyan,Company.isPackageActive?"Package has been active":"Package has been in-active");
  }
  shareId()async{
    await WhatsappShare.share(
        text: Company.companyId,
        phone: Company.whatsapp
    );
  }
}
