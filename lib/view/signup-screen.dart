import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/view/home-screen/home-screen.dart';
import 'package:moonskynl_food_delivery/view/login-screen.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../service/apis.dart';
import '../show-toast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  late bool _passwordVisible;

  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
  }

  final _signupKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _password = TextEditingController();
  final _confirmPass = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, left: 20, right: 20, bottom: 30),
          child: Column(

            children: [
              Center(
                child: Image.asset("assets/images/logo.png"),
              ),
              const SizedBox(height: 5,),
              MediunText(text: "MoonSky", color: appColors.mainColor, size: 12.sp,),

              SizedBox(height: 50,),

             Form(
               key: _signupKey,
               child: Column(
                 children: [
                   TextFormField(
                     controller: _name,
                     decoration: InputDecoration(
                       hintText: "name".tr,
                       labelText: "name".tr,
                       border: new OutlineInputBorder(
                         borderSide: new BorderSide(width: 3, color: appColors.gray),
                       ),
                       prefixIcon: Icon(
                         Icons.supervisor_account,
                         color: appColors.gray,
                       ),
                     ),
                     validator: (value){
                       if(value!.isEmpty){
                         return "input_error".tr;
                       }
                       return null;
                     },
                   ),
                   const SizedBox(height: 10,),
                   TextFormField(
                     controller: _mobile,
                     decoration: InputDecoration(
                       hintText: "number".tr,
                       labelText:  "number".tr,
                       border: new OutlineInputBorder(
                         borderSide: new BorderSide(width: 3, color: appColors.gray),
                       ),
                       prefixIcon: Icon(
                         Icons.call,
                         color: appColors.gray,
                       ),
                     ),
                     validator: (value){
                       if(value!.isEmpty){
                         return "input_error".tr;
                       }
                       return null;
                     },
                   ),

                   const SizedBox(height: 10,),
                   TextFormField(
                     controller: _email,
                     decoration: InputDecoration(
                       hintText: "email".tr,
                       labelText: "email".tr,
                       border: new OutlineInputBorder(
                         borderSide: new BorderSide(width: 3, color: appColors.gray),
                       ),
                       prefixIcon: Icon(
                         Icons.email,
                         color: appColors.gray,
                       ),
                     ),
                     validator: (value){
                       if(value!.isEmpty){
                         return "input_error".tr;
                       }
                       return null;
                     },
                   ),
                   const SizedBox(height: 10,),
                   TextFormField(
                     controller: _password,
                     obscureText: !_passwordVisible,
                     decoration: InputDecoration(
                       hintText: "password".tr,
                       labelText: "password".tr,
                       border: new OutlineInputBorder(
                         borderSide: new BorderSide(width: 3, color: appColors.gray),
                       ),
                       prefixIcon: Icon(
                         Icons.key,
                         color: appColors.gray,
                       ),
                       suffixIcon: IconButton(
                         icon: Icon(
                           _passwordVisible ?  Icons.visibility : Icons.visibility_off,
                           color: appColors.mainColor,
                         ), onPressed: () {
                         setState(() {
                           _passwordVisible = !_passwordVisible;
                         });
                       },
                       ),
                     ),
                     validator: (value){
                       if(value!.isEmpty){
                         return "input_error".tr;
                       }
                       return null;
                     },
                   ),


                   const SizedBox(height: 10,),
                   TextFormField(
                     obscureText: !_passwordVisible,
                     controller: _confirmPass,
                     decoration: InputDecoration(
                       hintText: "retype_password".tr,
                       labelText: "retype_password".tr,
                       border: new OutlineInputBorder(
                         borderSide: new BorderSide(width: 3, color: appColors.gray),
                       ),
                       prefixIcon: Icon(
                         Icons.key,
                         color: appColors.gray,
                       ),
                       suffixIcon: IconButton(
                         icon: Icon(
                           _passwordVisible ?  Icons.visibility : Icons.visibility_off,
                           color: appColors.mainColor,
                         ), onPressed: () {
                         setState(() {
                           _passwordVisible = !_passwordVisible;
                         });
                       },
                       ),
                     ),
                     validator: (value){
                       if(value!.isEmpty){
                         return "input_error".tr;
                       }
                       return null;
                     },
                   ),

                   const SizedBox(height: 10,),

                   const SizedBox(height: 10,),
                   Container(
                     padding: EdgeInsets.all(10),
                     width: MediaQuery.of(context).size.width,
                     margin: EdgeInsets.only(left: 40, right: 40, bottom: 10),
                     child: ElevatedButton(
                       onPressed: () {
                         setState((){
                           if(_password.text == _confirmPass.text){
                             _Signup();
                           }else{
                              ShowToast("password_not_match".tr).errorToast();
                           }

                         });
                       },
                       style: ButtonStyle(
                           padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                           backgroundColor: MaterialStateProperty.all(appColors.mainColor)
                       ),
                       child:Text("Sign In",
                         style: TextStyle(
                           color: appColors.white,
                           fontSize: 11.sp,
                           fontWeight: FontWeight.w600,
                         ),
                       ),

                     ),
                   ),
                 ],
               ),
             ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MediunText(text: "i_have_an_account".tr),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                    },
                    child: MediunText(text: "Login In", color: appColors.mainColor, size: 10,),

                  )

                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  /// TODO: SignUp
 void _Signup()async{
    if(_signupKey.currentState!.validate()){
      EasyLoading.show(status: "Sign up...");
      var data = {
        "email" : _email.text,
        "name" : _name.text,
        "mobile" : _mobile.text,
        "password" : _password.text,
      };
      var response = await http.post(Uri.parse(ApiService.register),
          body: data,
      );
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        if(data["status_code"]==200){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
          ShowToast("Successfully signup. Login Now.").successToast();
          EasyLoading.dismiss();
        }else{
          EasyLoading.dismiss();
          ShowToast("The email has already been taken.").errorToast();
          print(response.body);
        }
      }else{
        print("something is wearing");
        EasyLoading.dismiss();
      }
      EasyLoading.dismiss();
    }
 }

}

