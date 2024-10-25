import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worklytics/core/colors.dart';
import 'package:worklytics/feature/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Worklytics',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}

