import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage_scanner/core/scale.dart';
import 'package:storage_scanner/view/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Scale.init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Storage Scanner',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: HomePage(),
    );
  }
}
