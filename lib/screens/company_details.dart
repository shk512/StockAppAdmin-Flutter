
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:stock_admin/Model/company_model.dart';
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
  CompanyModel? companyModel;
  TextEditingController date=TextEditingController();
  String address='';
  @override
  void initState() {
    super.initState();
    getCompanyDetails();
  }
  getCompanyDetails()async{
    await DB(id: widget.companyId).getCompanyDetails().then((val){
      setState(() {
        companyModel=CompanyModel.fromJson(val);
      });
    });
    if(companyModel!.geoLocationModel.lat==0&&companyModel!.geoLocationModel.lng==0 || companyModel!.geoLocationModel.lat==null&&companyModel!.geoLocationModel.lng==null){
      address="Not set";
    }else{
      List<Placemark> coordinates=await placemarkFromCoordinates(companyModel!.geoLocationModel.lat, companyModel!.geoLocationModel.lng);
      address="${coordinates.reversed.last.street} ${coordinates.reversed.last.administrativeArea} ${coordinates.reversed.last.locality} ${coordinates.reversed.last.subLocality}";
    }
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
            child:companyModel!.companyName!=""
                ?Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      displayFunction("ID", companyModel!.companyId, const Icon(Icons.perm_identity)),
                      displayFunction("Company Name",companyModel!.companyName,const Icon(Icons.warehouse)),
                      displayFunction("City",companyModel!.city,const Icon(Icons.location_city_outlined)),
                      displayFunction("Status", companyModel!.isPackageActive?"Active":"InActive", Icon(companyModel!.isPackageActive?Icons.check_circle:Icons.cancel,color: companyModel!.isPackageActive?Colors.green:Colors.red,)),
                      displayFunction("Contact", companyModel!.contact, const Icon(Icons.phone)),
                      displayFunction("WhatsApp", companyModel!.whatsApp, const Icon(Icons.chat)),
                      displayFunction("Package",companyModel!.packageType,const Icon(Icons.timer)),
                      companyModel!.packageType=="LifeTime"||companyModel!.packageEndsDate==""?Container():displayFunction("Package Ends Date",companyModel!.packageEndsDate,const Icon(Icons.date_range)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: ()async{
                            if(!companyModel!.isPackageActive&&companyModel!.packageType=="LifeTime"){
                              updatePackage(true, "");
                            } else if(!companyModel!.isPackageActive) {
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
                        }, child: Text(companyModel!.isPackageActive?"Turn Off Membership":"Turn On Membership")),
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
      companyModel!.isPackageActive=value;
      companyModel!.packageEndsDate=date;
    });
    showSnackbar(context, Colors.cyan,companyModel!.isPackageActive?"Package has been active":"Package has been in-active");
  }
  shareId()async{
    await WhatsappShare.share(
        text: companyModel!.companyId,
        phone: companyModel!.whatsApp
    );
  }
}
