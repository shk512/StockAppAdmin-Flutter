import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/company_db.dart';
import '../utils/enum.dart';
import '../utils/snackbar.dart';
import 'error.dart';

class EditCompany extends StatefulWidget {
  final companyId;
  const EditCompany({Key? key,required this.companyId}) : super(key: key);

  @override
  State<EditCompany> createState() => _EditCompanyState();
}

class _EditCompanyState extends State<EditCompany> {
  TextEditingController packageEndsDate=TextEditingController();
  PackageType packageType=PackageType.Monthly;
  String package="Monthly".toUpperCase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(CupertinoIcons.back)),
        title: Text("Package Update"),
        actions: [
          ElevatedButton(
              onPressed: (){
                updatePackageStatus(true,packageEndsDate.text,package);
              },
              child: Text("Save")),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            radioButtons("Monthly", PackageType.Monthly),
            radioButtons("Yearly", PackageType.Yearly),
            radioButtons("Lifetime", PackageType.Lifetime),
            const SizedBox(height: 10,),
            packageType!=PackageType.Lifetime?date():const SizedBox()
          ],
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
            groupValue: packageType,
            onChanged: (PackageType? value) {
              setState(() {
                packageType = value!;
                package=name.toUpperCase();
              });
            })
    );
  }
  updatePackageStatus(bool value, String date, String packageType)async{
    await CompanyDb(id: widget.companyId).updateCompany({
      "packageEndsDate": date,
      "isPackageActive": value,
      "packageType": packageType
    }).then((value){
      showSnackbar(context, Colors.green.shade300, "Updated");
      Navigator.pop(context);
    }).onError((error, stackTrace){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ErrorScreen(error: error.toString())));
    });
  }
}
