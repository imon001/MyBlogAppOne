// ignore_for_file: prefer_const_constructors

import 'package:blog/app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

import 'app/constants/app_string.dart';
import 'app/views/splash/splash_screen.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, _) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: APP_NAME,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: kBaseColor),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      );
    });
  }
}
