import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stock_admin/screens/company_register.dart';
import 'package:stock_admin/screens/dashboard.dart';
import 'package:stock_admin/utils/routes.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'App Admin',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: Dashboard(),
      routes: {
        Routes.companyRegister:(context)=>CompanyRegister(),
      },
    );
  }
}
