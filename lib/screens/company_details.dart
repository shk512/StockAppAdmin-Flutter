import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_admin/Model/company_model.dart';
import 'package:stock_admin/screens/error.dart';
import 'package:stock_admin/services/company_db.dart';
import 'package:stock_admin/utils/snackbar.dart';

import '../Widget/row_info_display.dart';

class CompanyDetails extends StatefulWidget {
  final String companyId;
  const CompanyDetails({Key? key,required this.companyId}) : super(key: key);

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  TextEditingController packageEndsDate=TextEditingController();
  CompanyModel _companyModel=CompanyModel();
  String address='';

  @override
  void initState() {
    super.initState();
    getCompanyDetails();
  }

  getCompanyDetails()async{
    await CompanyDb(id: widget.companyId).getCompanyData().then((snapshot){
      setState(() {
        _companyModel.imageUrl=snapshot["imageUrl"];
        _companyModel.companyId=snapshot['companyId'];
        _companyModel.contact=snapshot['contact'];
        _companyModel.isPackageActive= snapshot['isPackageActive'];
        _companyModel.packageEndsDate= snapshot['packageEndsDate'];
        _companyModel.companyName= snapshot['companyName'];
        _companyModel.packageType=snapshot["packageType"];
        _companyModel.whatsApp=snapshot["whatsApp"];
        _companyModel.city=snapshot["city"];
      });
    }).onError((error, stackTrace) => Navigator.push(context, MaterialPageRoute(builder: (context)=>ErrorScreen(error: error.toString()))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back,color: Colors.white,),
        ),
        title:  Text(_companyModel.companyName,style: const TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _companyModel.imageUrl.isNotEmpty
                  ?CircleAvatar(
                    backgroundImage: NetworkImage(_companyModel.imageUrl),
                    radius: 100,
              )
                    :Icon(Icons.image,size: 70,),
              const SizedBox(height: 10,),
              RowInfoDisplay(value: _companyModel.companyId, label: "ID"),
              RowInfoDisplay(label: "Name", value: _companyModel.companyName),
              RowInfoDisplay(label: "Status", value:_companyModel.isPackageActive?"Active":"InActive"),
              RowInfoDisplay(label: "Package", value: _companyModel.packageType),
              _companyModel.packageEndsDate.isNotEmpty
                  ?RowInfoDisplay(label: "Package Ends Date", value:_companyModel.packageEndsDate)
                  :const SizedBox(),
              RowInfoDisplay(label: "City", value: _companyModel.city),
              RowInfoDisplay(label: "Contact", value: _companyModel.contact),
              const SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: (){
                    if(_companyModel.isPackageActive){
                      showWarningDialogue();
                    }else{
                      date();
                    }
                  },
                  child: Text(_companyModel.isPackageActive?"Inactive":"Active")),

            ],
          ),
        ),
      ),
    );
  }
  showWarningDialogue(){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Warning"),
            content: Text("Are you sure to inactive ${_companyModel.companyName}"),
            actions: [
              IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.cancel,color: Colors.red,)),
              IconButton(
                  onPressed: (){
                    updatePackageStatus(false, "");
                  }, icon: Icon(Icons.check_circle_rounded,color: Colors.green,)),
            ],
          );
        });
  }
  updatePackageStatus(bool value, String date)async{
    await CompanyDb(id: _companyModel.companyId).updateCompany({
      "packageEndsDate": date,
      "isPackageActive": value
    }).then((value){
      showSnackbar(context, Colors.green.shade300, "Updated");
    }).onError((error, stackTrace){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ErrorScreen(error: error.toString())));
    });
  }
  shareId()async{

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
          if (pickedDate != null && pickedDate.isAfter(DateTime.now())) {
            String formattedDate =
            DateFormat("dd-MM-yyyy").format(pickedDate);
            setState(() {
              packageEndsDate.text = formattedDate;
            });
            updatePackageStatus(true, packageEndsDate.text);
          }else{
            showSnackbar(context, Colors.red, "Invalid Date");
          }
        });
  }
}
