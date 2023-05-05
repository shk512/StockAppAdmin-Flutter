import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_admin/Model/company_model.dart';
import 'package:stock_admin/services/db.dart';
import 'package:stock_admin/utils/enum.dart';
import 'package:stock_admin/utils/snackbar.dart';

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
          child: const Icon(CupertinoIcons.back,color: Colors.white,),
        ),
        title: const Text("Registeration",style: TextStyle(color: Colors.white),),
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
                textFields(
                    const Icon(Icons.warehouse), "Company Name", "e.g. Candy Land",
                    companyName),
                const SizedBox(height: 20),
                textFields(const Icon(Icons.location_city), "City", "City Name...", city),
                const SizedBox(height: 20),
                textFields(const Icon((Icons.phone)), "Contact","923001234567", phone),
                const SizedBox(height: 20),
                textFields(const Icon(Icons.message), "Whatsapp", "923001234567", whatsapp),
                const SizedBox(height: 20),
                const Text("Select Package",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,),
                radioButtons("Monthly", PackageType.Monthly),
                radioButtons("Yearly", PackageType.Yearly),
                radioButtons("Lifetime", PackageType.Lifetime),
                package == PackageType.Lifetime ? Container() : date(),
                const SizedBox(height: 40),
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

  Widget textFields(Icon icon, String labelName, String tipName,
      TextEditingController control) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextFormField(
            controller: control,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: labelName,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1,
              ),
              hintText: tipName,
            ),
            validator: (val) {
              return val!.isNotEmpty?null:"Invalid";
            }
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
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
            DateFormat("dd-MM-yyyy").format(pickedDate);
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
    if(formKey.currentState!.validate()){
      setState(() {
        isLoading=true;
      });
      String companyId=DateTime.now().microsecondsSinceEpoch.toString();
      await DB(id: companyId).saveCompany(
        CompanyModel.toJson(
            companyId: companyId,
            companyName: companyName.text,
            contact: phone.text,
            whatsApp: whatsapp.text,
            packageEndsDate: packageEndsDate.text,
            packageType: packageType.text,
            city: city.text,
            wallet: 0,
            area: [],
            isPackageActive: true,
            lat: null, lng: null
        )
      ).then((value)async{
        if(value){
          await DB(id: companyId).saveCompanyId().then((value){
            if(value){
              Navigator.pop(context);
              showSnackbar(context, Colors.cyan, "Registered Successfully!");
            }else{
              setState(() {
                isLoading=false;
              });
              showSnackbar(context, Colors.red, "Error. Please Try Again!");
            }
          }).onError((error, stackTrace){
            showSnackbar(context, Colors.red, error.toString());
          });

        }else{
          setState(() {
            isLoading=false;
          });
          showSnackbar(context, Colors.red, "Error. Please Try Again!");
        }
      });
    }
  }
}