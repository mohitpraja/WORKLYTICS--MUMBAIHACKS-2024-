import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worklytics/core/colors.dart';
import 'package:worklytics/core/fonts.dart';
import 'package:worklytics/core/regula.dart';
import 'package:worklytics/feature/login.dart';
import 'package:worklytics/feature/user_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    RegulaFaceRecognition.initialize();
    Future.delayed(
        const Duration(seconds: 2), () => Get.offAll(() =>  LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: primaryColor,
        child: Center(
          child: Text(
            'Worklytics',
            style: TextStyle(
                fontSize: 30,
                letterSpacing: 1.5,
                color: white,
                fontFamily: FF.alata),
          ),
        ),
      ),
    );
  }
}
