import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/Home.dart';
import 'package:project1/controller/RequestController.dart';
import 'package:project1/screens/ExamPage.dart';
import 'package:project1/screens/NewsPage.dart';
import 'package:project1/screens/RequestPage.dart';
import 'package:project1/screens/TimeRegisterPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      // home: NewsPage(),
      // home: ExamPage(),
      // home: TimeRegisterPage(),
      initialBinding: InitialBinding(),
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RequestTimeDateController());
  }
}
