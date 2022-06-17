import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moonskynl_food_delivery/view/home-screen/home-screen.dart';
import 'package:moonskynl_food_delivery/view/login-screen.dart';
import 'package:moonskynl_food_delivery/view/splash-screen/splash-itme.dart';
import 'package:moonskynl_food_delivery/view/splash-screen/splash-screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({Key? key}) : super(key: key);

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  @override
  void initState(){
    super.initState();
    _UserInfo();
  }

  void _UserInfo() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString("token");
    var isFirstTime = localStorage.getBool("isFirstTime");

    setState(() {
      print(token);
      if(token == null){
        if(isFirstTime == true){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context)=> SplashItem()));
        }
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      }


    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
