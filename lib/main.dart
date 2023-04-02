import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:water_report/view/home.view.dart';
import 'package:water_report/view/login.view.dart';
import 'package:water_report/view/splash.view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aqua Express',
      home: SplashView(),
      // This trailing comma makes auto-formatting nicer for build methods.
      routes: {
        '/login': (context) => LoginView(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
