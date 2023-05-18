import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geopoint/geopoint.dart';
import 'package:intl/intl.dart';
import 'package:stock_admin/Model/company_model.dart';
import 'package:stock_admin/Widget/text_field.dart';
import 'package:stock_admin/services/company_db.dart';
import 'package:stock_admin/utils/enum.dart';
import 'package:stock_admin/utils/snackbar.dart';

import '../Widget/num_field.dart';

class CompanyRegister extends StatefulWidget {
  const CompanyRegister({Key? key}) : super(key: key);

  @override
  State<CompanyRegister> createState() => _CompanyRegisterState();
}

class _CompanyRegisterState extends State<CompanyRegister> {
  TextEditingController companyName=TextEditingController();
  TextEditingController city=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController whatsapp=TextEditingController();
  TextEditingController packageType=TextEditingController();
  TextEditingController packageEndsDate=TextEditingController();
  bool isLoading = false;
  PackageType package = PackageType.Monthly;
  CompanyModel? companyModel;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(CupertinoIcons.back),
        ),
        title: const Text("Registration"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TxtField(labelTxt: "Company Name", hintTxt: "Candy Land", ctrl: companyName, icon: Icon(Icons.warehouse_outlined)),
                TxtField(labelTxt: "City", hintTxt: "City Name", ctrl: city, icon: Icon(Icons.location_city_outlined)),
                NumField(labelTxt: "Contact", hintTxt: "03001234567", ctrl: phone, icon: Icon(Icons.phone)),
                NumField(icon: Icon(Icons.message), ctrl: whatsapp, hintTxt: "03001234567", labelTxt: "Whatsapp"),
                const Text("Select Package",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,),
                radioButtons("Monthly", PackageType.Monthly),
                radioButtons("Yearly", PackageType.Yearly),
                radioButtons("Lifetime", PackageType.Lifetime),
                package == PackageType.Lifetime ? const SizedBox() : date(),
                const SizedBox(height: 20),
                OutlinedButton(
                    onPressed: () {
                      if(package==PackageType.Yearly){
                        packageType.text="Yearly".toUpperCase();
                      }else if(package==PackageType.Monthly){
                        packageType.text="Monthly".toUpperCase();
                      }else if(package==PackageType.Lifetime){
                        packageType.text="LifeTime".toUpperCase();
                      }
                      signup();
                    },
                    child: const Text("Register"))
              ],
            ),),
        ),
      ),
    );
  }
  Widget date() {
    return TextField(
        decoration: const InputDecoration(
          icon: Icon(Icons.calendar_month),
          labelText: "Package Ends Date",
        ),
        readOnly: true,
        controller: packageEndsDate,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100));
          if (pickedDate != null&&pickedDate.isAfter(DateTime.now())) {
            String formattedDate =
            DateFormat("yyyy-MM-dd").format(pickedDate);
            setState(() {
              packageEndsDate.text = formattedDate;
            });
          }else{
            showSnackbar(context, Colors.red, "Invalid Date");
          }
        });
  }
  Widget radioButtons(String name, PackageType type,) {
    return ListTile(
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Radio(
            value: type,
            groupValue: package,
            onChanged: (PackageType? value) {
              setState(() {
                package = value!;
              });
            })
    );
  }
  signup() async{
    CompanyModel companyModel=CompanyModel();
    if(formKey.currentState!.validate()){
      setState(() {
        isLoading=true;
      });
      String companyId=DateTime.now().microsecondsSinceEpoch.toString();
      companyModel.companyId=companyId;
      companyModel.companyName=companyName.text;
      companyModel.city=city.text;
      companyModel.packageEndsDate=packageEndsDate.text;
      companyModel.isPackageActive=true;
      companyModel.packageType=packageType.text;
      companyModel.contact=phone.text;
      companyModel.whatsApp=whatsapp.text;

      await CompanyDb(id: companyId).saveCompany(companyModel.toJson()).then((value)async{
        if(value==true){
          Navigator.pop(context);
          showSnackbar(context, Colors.green.shade300, "Registered Successfully!");
        }else{
          setState(() {
            isLoading=false;
          });
          showSnackbar(context, Colors.red.shade400, "Error. Please Try Again!");
        }
      });
    }
  }
}