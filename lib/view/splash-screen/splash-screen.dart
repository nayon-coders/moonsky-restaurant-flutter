import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:moonskynl_food_delivery/view/home-screen/home-screen.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/view/splash-screen/rout.dart';
import 'package:moonskynl_food_delivery/view/splash-screen/splash-itme.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  AnimatedSplashScreen(
        splash:  Image.asset("assets/images/logo.png",),
        duration: 2000,
        nextScreen: const RoutingPage(),
      ),
    );
  }
}
