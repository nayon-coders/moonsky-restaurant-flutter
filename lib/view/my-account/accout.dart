import 'dart:convert';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:moonskynl_food_delivery/service/apis.dart';
import 'package:moonskynl_food_delivery/service/call-api.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/view/contact-screen/catering-list.dart';
import 'package:moonskynl_food_delivery/view/favorite-screen/favorite-screen.dart';
import 'package:moonskynl_food_delivery/view/login-screen.dart';
import 'package:moonskynl_food_delivery/view/my%20order%20list/my-order-list.dart';
import 'package:moonskynl_food_delivery/widget/big-text.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../../show-toast.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  void initState(){
    super.initState();
    _getUserData();
  }
  bool isLogout = false;
  bool isPasswordChange = false;

  final _keyPassChange = GlobalKey<FormState>();
  final _oldPass = TextEditingController();
  final _Newpass = TextEditingController();
var userData;
  _getUserData()async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var userJson = localStorage.getString('user');
    var user = jsonDecode(userJson!);
    setState(() {
      userData =user;
    });
  }
String? selectedLeaveTypeValue;
  final List<String> items = [
    'Netherlands 🇳🇱',
    'English 🇺🇲',
  ];
  setLanguage(value)async{
    selectedLeaveTypeValue = value;
    if(selectedLeaveTypeValue == 'English 🇺🇲'){
      Get.updateLocale(Locale("en", "US"));
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString("lan", "en");
    }
    if(selectedLeaveTypeValue == 'Netherlands 🇳🇱'){
      Get.updateLocale(Locale("nl", "BQ"));
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: appColors.bg,
      body: isLogout ? Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 4, color: appColors.mainColor,),
            SizedBox(height: 10,),
            MediunText(text: "Logout..."),
          ],
        ),
      ):Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
              width: width,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/profilebg.png",),
                  fit: BoxFit.fill,

                )
              ),
            ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: appColors.white,
                      size: 30,
                    )
                ),),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                    onPressed: (){
                      _logout();
                    },
                    icon: Icon(
                      Icons.logout,
                      color: appColors.white,
                      size: 30,
                    )
                ),),
              Positioned(
                top: height/6,
                  left: width/2.8,
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: appColors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: appColors.gray200,
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(0,3)
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.account_circle_rounded,
                      color: appColors.mainColor,
                      size: 50,
                    ),
                  )
              ),

    ],
          ),

          const SizedBox(height: 80,),
          BigText(text: "${userData["name"]}", size: 10.sp,),
          const SizedBox(height: 5),
          MediunText(text: "${userData["email"]}", size: 10.sp,),
          const SizedBox(height: 5,),
          MediunText(text: "${userData["mobile"]}", size: 10.sp,),


          const SizedBox(height: 10,),

          Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20,),
                child: ListView(
                  children: [
                    SizedBox(height: 10,),
                    ShowAccountItem(
                        onClick: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOrdersList()));
                        },
                        text: "my_order".tr,
                    ),
                    ShowAccountItem(
                      onClick: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=> FavoriteScreen()));
                      },
                      text: "favorite_list".tr,
                    ),
                    ShowAccountItem(
                      onClick: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=> CateringList()));
                      },
                      text: "catering_list".tr,
                    ),
                    ShowAccountItem(
                      onClick: (){
                        setState((){
                          _changePassPopUp();
                        });
                      },
                      text: "change_password".tr,
                    ),
                    ShowAccountItem(
                      onClick: (){
                        showDialog(
                            context: context,
                            barrierDismissible: true, // set to false if you want to force a rating
                            builder: (context){
                              return RatingDialog(
                                starColor: appColors.mainColor,
                                initialRating: 1.0,
                                // your app's name?
                                title: Text(
                                  'rating_title'.tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // encourage your user to leave a high rating?
                                message: Text(
                                  'rating_des'.tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                // your app's logo?
                                submitButtonText: 'Submit',
                                commentHint: 'rating_hint'.tr,
                                onCancelled: () => print('cancelled'),
                                onSubmitted: (response) {
                                  print('rating: ${response.rating}, comment: ${response.comment}');
                                  var rating = response.rating;
                                  var comment = response.comment;
                                  // TODO: add your own logic
                                  rateAndReviewApp(context, rating, comment);
                                },
                              );
                            },
                        );
                      },
                      text: "add_review".tr,
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: appColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: appColors.gray200,
                            blurRadius: 20,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: CustomDropdownButton2(
                        hint: "change_lan".tr,
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
                    SizedBox(height: 30,),


                  ],
                ),

              )
          )

        ],
      ),

    );
  }
  Future<void> _changePassPopUp() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('change_password'.tr),
          content: Container(
            height: 220,
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _oldPass,
                    decoration: InputDecoration(
                      hintText: "old_password".tr,
                    ),
                    validator: (value){
                      if(value == null){
                        return "Old Password is empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: _Newpass,
                    decoration: InputDecoration(
                      hintText: "new_pass".tr,
                    ),
                    validator: (value){
                      if(value == null){
                        return "New Password is empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30,),

                  Container(
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 40, right: 40, bottom: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        setState((){
                          _changePass();
                        });
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                          backgroundColor: MaterialStateProperty.all(appColors.mainColor)
                      ),
                      child:Text("Change Password",
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
          ),
        );
      },
    );
  }


  void _logout()async{
    setState((){
      isLogout = true;
    });

      var response = await CallApi().getData(ApiService.logout);
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        if(data["status_code"] == 200){
          print("log out");
          SharedPreferences localStorage = await SharedPreferences.getInstance();
          localStorage.remove("token");
          Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
        }else{
          print("Something want wearing with ${response.statusCode}");
          print(response.statusCode);
        }

      }else{
        print("Something want wearing with ${response.statusCode}");
        print(response.statusCode);
      }
    setState((){
      isLogout = false;
    });

  }

  void _changePass()async{
     EasyLoading.show(status: "Changing Password");
      var body = {
        "password" : _oldPass.text,
        "new_password" : _Newpass.text,
      };
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var token = localStorage.getString("token");
      var response = await http.post(Uri.parse(ApiService.changePass),
          body: body,
          headers: {
            "Authorization" : "Bearer $token"
          }
      );
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        if(data["status_code"] == 200){

          EasyLoading.dismiss();
          localStorage.remove("token");
          ShowToast("pass_change".tr).successToast();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

        }else{
          EasyLoading.dismiss();
          var data = jsonDecode(response.body);
          print(data["message"] );
          ShowToast("old_pass_not_match".tr).errorToast();

        }
      }else{
        ShowToast("Server Error ${response.statusCode}");
      }
     EasyLoading.dismiss();
  }

//// TODO: Add reviews
  rateAndReviewApp(BuildContext context, rating, comment) async{
    EasyLoading.show(status: "Review...");
    var body = {
      "ratting" : rating.toString(),
      "comment" : comment,
    };
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString("token");
    var response = await http.post(Uri.parse(ApiService.reviewCreate),
        body: body,
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      if(data["status_code"] == 200){
        EasyLoading.dismiss();
        Navigator.pop(context);
        localStorage.remove("token");
        showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
                content: Container(
                  height: 210,
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset("assets/images/success.png", height: 80, width: 80, fit: BoxFit.cover,),
                      ),
                      SizedBox(height: 20,),
                      BigText(text: "Success", size: 10.sp,),
                      SizedBox(height: 5,),
                      MediunText(text: "Thank You For You Reviews. Stay with us.", size: 10.sp,),
                      SizedBox(height: 15,),
                      Divider(height: 1, color: appColors.gray,),
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MyAccount()));
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.green,
                          ),
                          child: MediunText(text: "Go to Order Page", color: appColors.white,),
                        ),
                      )
                    ],

                  ),
                )
            ),
        );

      }else{
        EasyLoading.dismiss();
        var data = jsonDecode(response.body);
        ShowToast(data["message"]).errorToast();
      }
    }else{
      ShowToast("Server Error ${response.statusCode}");
    }
    EasyLoading.dismiss();
  }


}


class ShowAccountItem extends StatelessWidget {
  final VoidCallback onClick;
  final String text;
  const ShowAccountItem({Key? key, required this.onClick, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onClick,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appColors.white,
          boxShadow: [
            BoxShadow(
              color: appColors.gray200,
              blurRadius: 20,
              spreadRadius: 1,
            )
          ],
        ),
        child: ListTile(
          title: BigText(text: text, size: 9.sp,),
          trailing: Wrap(
            spacing: 12, // space between two icons
            children: <Widget>[
              Icon(Icons.arrow_forward_ios),
            ],
          ),
          selectedColor: appColors.black,
        ),
      ),
    );
  }


}

