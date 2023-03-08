import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyRegister extends StatefulWidget {
  const CompanyRegister({Key? key}) : super(key: key);

  @override
  State<CompanyRegister> createState() => _CompanyRegisterState();
}

class _CompanyRegisterState extends State<CompanyRegister> {
  final formKey=GlobalKey<FormState>();
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
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [

            ],
    ),),
      ),
    );
  }
}
