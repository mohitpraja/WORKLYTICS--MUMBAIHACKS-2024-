import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:worklytics/core/colors.dart';
import 'package:worklytics/feature/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Worklytics',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home:  LoginPage(),
      // home:  GeoFenceScreen(),
      //home: const SplashView(),
    );
  }
}

