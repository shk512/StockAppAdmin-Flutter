import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:stock_admin/Model/company_model.dart';
import 'package:stock_admin/Model/geolocation_model.dart';
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
        CompanyModel.fromJson(val);
      });
    });
    print(GeoLocationModel.lat);
    print(GeoLocationModel.lng);
    if(GeoLocationModel.lat==0&&GeoLocationModel.lng==0 || GeoLocationModel.lat==null&&GeoLocationModel.lng==null){
      address="Not set";
    }else{
      List<Placemark> coordinates=await placemarkFromCoordinates(GeoLocationModel.lat, GeoLocationModel.lng);
      address="${coordinates.reversed.last.country}";
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
            child:CompanyModel.companyName!=""
                ?Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      displayFunction("Status", CompanyModel.isPackageActive?"Active":"InActive", Icon(CompanyModel.isPackageActive?Icons.check_circle:Icons.cancel,color: CompanyModel.isPackageActive?Colors.green:Colors.red,)),
                      const SizedBox(height: 5),
                      CompanyModel.packageType=="LifeTime".toUpperCase()||CompanyModel.packageEndsDate==""?Container():displayFunction("Package Ends Date",CompanyModel.packageEndsDate,const Icon(Icons.date_range)),
                      const SizedBox(height: 5),
                      displayFunction("ID", CompanyModel.companyId, const Icon(Icons.perm_identity)),
                      const SizedBox(height: 5),
                      displayFunction("Company Name",CompanyModel.companyName,const Icon(Icons.warehouse)),
                      const SizedBox(height: 5),
                      displayFunction("Address",address,const Icon(Icons.pin_drop)),
                      const SizedBox(height: 5),
                      displayFunction("City",CompanyModel.city,const Icon(Icons.location_city_outlined)),
                      const SizedBox(height: 5),
                      displayFunction("Contact", CompanyModel.contact, const Icon(Icons.phone)),
                      const SizedBox(height: 5),
                      displayFunction("WhatsApp", CompanyModel.whatsApp, const Icon(Icons.chat)),
                      const SizedBox(height: 5),
                      displayFunction("Package",CompanyModel.packageType,const Icon(Icons.timer)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: ()async{
                            if(!CompanyModel.isPackageActive&&CompanyModel.packageType=="LifeTime".toUpperCase()){
                              updatePackage(true, "");
                            } else if(!CompanyModel.isPackageActive) {
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
                        }, child: Text(CompanyModel.isPackageActive?"Turn Off Membership":"Turn On Membership")),
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
      CompanyModel.isPackageActive=value;
      CompanyModel.packageEndsDate=date;
    });
    showSnackbar(context, Colors.cyan,CompanyModel.isPackageActive?"Package has been active":"Package has been in-active");
  }
  shareId()async{
    await WhatsappShare.share(
        text: CompanyModel.companyId,
        phone: CompanyModel.whatsApp
    );
  }
}
