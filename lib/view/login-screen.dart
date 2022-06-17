import 'dart:convert';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moonskynl_food_delivery/service/apis.dart';
import 'package:moonskynl_food_delivery/show-toast.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/view/home-screen/home-screen.dart';
import 'package:moonskynl_food_delivery/view/signup-screen.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  String? selectedLeaveTypeValue;

  bool _isLogin = false;
  late bool _passwordVisible;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
  }
  final List<String> items = [
    'Netherlands',
    'English',
  ];

  setLanguage(value)async{
    selectedLeaveTypeValue = value;
    if(selectedLeaveTypeValue == "English"){
      Get.updateLocale(Locale("en", "US"));
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString("lan", "en");
    }
    if(selectedLeaveTypeValue == "Netherlands"){
      Get.updateLocale(Locale("nl", "BQ"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.only(right: 20, left: 20, top: 7.h),
              child: Align(
                alignment : Alignment.topRight,
                child: Container(
                  width: 150,
                  child:  CustomDropdownButton2(
                    hint: 'Select Language',
                    buttonHeight: 50,
                    buttonWidth: 200,
                    buttonPadding: EdgeInsets.all(10),
                    dropdownWidth: 130,
                    buttonDecoration: BoxDecoration(
                      border: Border.all(width: 0, color: appColors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    dropdownItems: items,
                    value: selectedLeaveTypeValue,
                    onChanged: (value) {
                      setState(() {
                        setLanguage(value);
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.h, left: 20, right: 20),
              child: Column(

                children: [

                  Center(
                    child: Image.asset("assets/images/logo.png"),
                  ),
                  const SizedBox(height: 5,),
                  MediunText(text: "MoonSky", color: appColors.mainColor, size: 12.sp,),

                  SizedBox(height: 50,),
                 Form(
                   key: loginFormKey,
                     child: Column(
                       children: [
                         TextFormField(
                           controller: _email,
                           decoration: InputDecoration(
                             hintText: "email".tr,
                             labelText: "email".tr,
                             border: new OutlineInputBorder(
                               borderSide: new BorderSide(width: 3, color: appColors.gray),
                             ),
                             prefixIcon: Icon(
                               Icons.supervisor_account,
                               color: appColors.gray,
                             ),
                           ),
                           validator: (value){
                             if(value == null){
                               return "Field must not be empty";
                             }
                             return null;
                           },
                         ),
                         SizedBox(height: 15,),
                         const SizedBox(height: 10,),
                         TextFormField(
                           controller: _pass,
                           obscureText: !_passwordVisible,
                           decoration: InputDecoration(
                             hintText: "password".tr,
                             labelText: "password".tr,
                             border: new OutlineInputBorder(
                               borderSide: new BorderSide(width: 3, color: appColors.gray),
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
                             prefixIcon: Icon(
                               Icons.key,
                               color: appColors.gray,
                             ),
                           ),
                         ),
                       ],
                     )
                 ),

                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("forget_password".tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: appColors.mainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 9.sp
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        setState((){
                          _loginMethod();
                        });
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                          backgroundColor: MaterialStateProperty.all(appColors.mainColor)
                      ),
                      child:Text("Login",
                        style: TextStyle(
                          color: appColors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                    ),
                  ),

                  Text(
                    "OR",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            setState((){
                                _loginWithGoogle();
                            });
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                              backgroundColor: MaterialStateProperty.all(appColors.bg)
                          ),
                          child:Row(
                            children: [
                              Image.asset("assets/images/google.png", width: 30, height: 30,),
                              MediunText(text: "Login Google", size: 7.sp,)
                            ],
                          ),

                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            setState((){

                            });
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                              backgroundColor: MaterialStateProperty.all(appColors.bg)
                          ),
                          child:Row(
                            children: [
                              Image.asset("assets/images/facebook.png", width: 30, height: 30,),
                              MediunText(text: "Login Facebook", size: 7.sp,)
                            ],
                          ),

                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MediunText(text: "i_dont_have_an_account".tr),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                        },
                        child: MediunText(text: "Sign In", color: appColors.mainColor, size: 10,),

                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  _loginMethod() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );

    if(loginFormKey.currentState!.validate()){
      var body = {
        "email" : _email.text,
        "password" : _pass.text,
      };
      var response = await http.post(Uri.parse(ApiService.loginUrl),
        body: body,
      );
      if(response.statusCode == 200){

        var data = jsonDecode(response.body.toString());

        if(data["status_code"] == 200){
          EasyLoading.dismiss();
          SharedPreferences localStorage = await SharedPreferences.getInstance();
          localStorage.setString('user', jsonEncode(data['data']));
          localStorage.setString("token", data["token"]["plainTextToken"].toString());
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
        }else{
          ShowToast(data["message"]).errorToast();
          print(response.body.toString());
          EasyLoading.dismiss();
        }

      }else{
        EasyLoading.dismiss();
        print(response.statusCode);
      }
    }




  }


  Future _loginWithGoogle()async{
    try {
     var result = await _googleSignIn.signIn();

     print(result);
    } catch (error) {
      print(error);
    }
  }

}
