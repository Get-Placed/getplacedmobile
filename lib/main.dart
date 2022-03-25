import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'first/firsttab.dart';
import 'services/values.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: k_themeColor,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
    ));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GetPlaced',
      theme: ThemeData(
        primaryColor: k_btnColor,
      ),
      home: MainTab(),
    );
  }
}
