import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import 'package:stock_admin/Model/company.dart';
import 'package:stock_admin/services/db.dart';
import 'package:stock_admin/utils/enum.dart';
import 'package:stock_admin/utils/snackbar.dart';

import '../services/auth.dart';

class CompanyRegister extends StatefulWidget {
  const CompanyRegister({Key? key}) : super(key: key);

  @override
  State<CompanyRegister> createState() => _CompanyRegisterState();
}

class _CompanyRegisterState extends State<CompanyRegister> {
  bool isLoading = false;
  TextEditingController email= TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController companyName= TextEditingController();
  TextEditingController packageType= TextEditingController();
  TextEditingController packageEndsDate = TextEditingController();
  Package package = Package.Monthly;
  Auth auth = Auth();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registeration"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back), onPressed: () {
          Navigator.pop(context);
        },
        ),
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
                textFields(const Icon(Icons.mail), "Email", "john@gmail.com", email),
                const SizedBox(height: 20),
                textFields(
                    const Icon(Icons.lock), "Password", "Minimum six characters",
                    password),
                const SizedBox(height: 20),
                textFields(
                    const Icon(Icons.warehouse), "Company Name", "e.g. Candy Land",
                    companyName),
                const SizedBox(height: 20),
                const Text("Select Package",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,),
                radioButtons("Monthly", Package.Monthly),
                radioButtons("Yearly", Package.Yearly),
                radioButtons("Lifetime", Package.Lifetime),
                package == Package.Lifetime ? Container() : date(),
                const SizedBox(height: 40),
                OutlinedButton(
                    onPressed: () {
                      if(package==Package.Yearly){
                        setState(() {
                          packageType.text="Yearly";
                        });
                      }else if(package==Package.Monthly){
                        setState(() {
                          packageType.text="Monthly";
                        });
                      }else if(package==Package.Lifetime){
                        setState(() {
                          packageType.text="LifeTime";
                          packageEndsDate.text="";
                        });
                      }
                      signup();
                    }, child: const Text("Register"))
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
              if (control == password) {
                if (val!.length < 6) {
                  return "Invalid";
                } else {
                  return null;
                }
              }
              if (control == companyName) {
                if (val!.isNotEmpty) {
                  return null;
                } else {
                  return "Invalid";
                }
              }
              if (control == email) {
                if (EmailValidator.validate(val!)) {
                  return null;
                } else {
                  return "Invalid";
                }
              }
              else {
                return null;
              }
            },
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
          if (pickedDate != null) {
            String formattedDate =
            DateFormat("dd-MM-yyyy").format(pickedDate);
            setState(() {
              packageEndsDate.text = formattedDate;
            });
          }
        });
  }
  Widget radioButtons(String name, Package type,) {
    return ListTile(
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Radio(
            value: type,
            groupValue: package,
            onChanged: (Package? value) {
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
      await auth.registerCompany(email.text, password.text).then((value)async{
        if(value!=null){
          await DB(id: value.toString()).saveCompany(Company(isPackageActive: true, companyId: value.toString(), packageEndsDate: packageEndsDate.text, packageType: packageType.text, email: email.text, companyName: companyName.text).toJson());
          Navigator.pop(context);
          showSnackbar(context, Colors.cyan, "Registered Successfully!");
        }else{
          setState(() {
            isLoading=false;
          });
          showSnackbar(context, Colors.red, value.toString());
        }
      });
    }
  }
}