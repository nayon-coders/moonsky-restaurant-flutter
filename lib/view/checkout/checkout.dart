import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:moonskynl_food_delivery/service/apis.dart';
import 'package:moonskynl_food_delivery/show-toast.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/view/home-screen/home-screen.dart';
import 'package:moonskynl_food_delivery/widget/big-text.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../my-account/accout.dart';
class Checkout extends StatefulWidget {
  final String totalOrders;
  final String discoundPrice;
  final String promoCode;
  final String tax;
  final String taxAmount;
  final String daliveryCharge;
  final String orderType;

   Checkout({
    required this.totalOrders,
    required this.discoundPrice,
    required this.promoCode,
    required this.tax,
    required this.taxAmount,
    required this.daliveryCharge,
    required this.orderType,
  });

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final _daliveryKey = GlobalKey<FormState>();

  final _deliveryAddress = TextEditingController();
  final _pin = TextEditingController();
  final _floatNo = TextEditingController();
  final _landMark = TextEditingController();
  final _note = TextEditingController();
  @override
  void initState(){
    super.initState();
    _getUserData();
  }

  var userData;
  var Name;
  var Email;
  _getUserData()async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var userJson = localStorage.getString('user');
    var user = jsonDecode(userJson!);
    setState(() {
      userData =user;
      Name = userData["name"];
      Email = userData["email"];
    });
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: appColors.bg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_rounded, color: appColors.mainColor,)),
          title: BigText(text: "Checkout", size: 11.sp,),
          centerTitle: true,
        ),
        body: Padding(
          padding:  EdgeInsets.only(left: 20, right: 20, top: 10 ),
          child:  Container(
               padding: EdgeInsets.all(20),
               margin: EdgeInsets.only(bottom: 50),
               width: width,
               height: MediaQuery.of(context).size.height,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 color: appColors.white,
                 boxShadow: [
                   BoxShadow(
                     color: appColors.gray200,
                     blurRadius: 20,
                     spreadRadius: 5,
                   )
                 ],
               ),
               child: Container(
                     width: width,
                     height: MediaQuery.of(context).size.height,
                     child: Form(
                         key: _daliveryKey,
                         child: ListView(
                           children: [
                             SizedBox(height: 20,),
                             TextFormField(
                               controller: _deliveryAddress,
                               decoration:  InputDecoration(
                                   hintText: "Delivery Address",
                                   contentPadding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                                   border: OutlineInputBorder(
                                     borderSide: BorderSide(width: 2, color: appColors.gray200),
                                   )
                               ),
                               validator: (value){
                                 if(value!.isEmpty){
                                   return "Field must not be empty";
                                 }
                                 return null;
                               },
                             ),
                             const SizedBox(height: 10,),
                             TextFormField(
                               controller: _pin,
                               keyboardType: TextInputType.number,
                               decoration:  InputDecoration(
                                   hintText: "Pin",
                                   contentPadding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                                   border: OutlineInputBorder(
                                     borderSide: BorderSide(width: 2, color: appColors.gray200),
                                   )
                               ),
                               validator: (value){
                                 if(value!.isEmpty){
                                   return "Field must not be empty";
                                 }
                                 return null;
                               },
                             ),
                             const SizedBox(height: 10,),
                             TextFormField(
                               controller: _floatNo,
                               keyboardType: TextInputType.number,
                               decoration:  InputDecoration(
                                   hintText: "Deur/Flat No",
                                   contentPadding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                                   border: OutlineInputBorder(
                                     borderSide: BorderSide(width: 2, color: appColors.gray200),
                                   )
                               ),
                               validator: (value){
                                 if(value!.isEmpty){
                                   return "Field must not be empty";
                                 }
                                 return null;
                               },
                             ),
                             const SizedBox(height: 10,),
                             TextFormField(
                               controller: _landMark,
                               decoration:  InputDecoration(
                                   hintText: "Land Mark",
                                   contentPadding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                                   border: OutlineInputBorder(
                                     borderSide: BorderSide(width: 2, color: appColors.gray200),
                                   )
                               ),
                               validator: (value){
                                 if(value!.isEmpty){
                                   return "Field must not be empty";
                                 }
                                 return null;
                               },
                             ),
                             const SizedBox(height: 10,),
                             TextFormField(
                               maxLines: 3,
                               controller: _note,
                               decoration:  InputDecoration(
                                   hintText: "Write Note",
                                   contentPadding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                                   border: OutlineInputBorder(
                                     borderSide: BorderSide(width: 2, color: appColors.gray200),
                                   )
                               ),
                               validator: (value){
                                 if(value!.isEmpty){
                                   return "Field must not be empty";
                                 }
                                 return null;
                               },
                             ),
                             SizedBox(height: 40,),
                             Container(
                               width: width,
                               padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
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
                               child: Row(
                                 children: [
                                   Container(
                                     width: 10,
                                     height: 10,
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(100),
                                       color: appColors.mainColor
                                     ),
                                   ),
                                   SizedBox(width: 5,),
                                   MediunText(text: "Cash On Delivery"),
                                 ],
                               ),
                             ),
                             Container(
                               width: width,
                               child: ElevatedButton(
                                 onPressed: () {
                                   _checkOut();
                                 },
                                 style: ButtonStyle(
                                     padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                                     backgroundColor: MaterialStateProperty.all(appColors.mainColor)
                                 ),
                                 child:Text("Place Order",
                                   style: TextStyle(
                                     color: appColors.white,
                                     fontSize: 11.sp,
                                     fontWeight: FontWeight.w600,
                                   ),
                                 ),

                               ),
                             ),
                           ],
                         )
                     ),
                   ),
             ),

        ),

    );
  }




/// TODO: Checkout
  void _checkOut()async{
    if(_daliveryKey.currentState!.validate()){
      EasyLoading.show(status: "Order Processing...");
      var data = {
        "order_total" : widget.totalOrders,
        "address" : _deliveryAddress.text,
        "promocode" : widget.promoCode,
        "discount_pr" : widget.discoundPrice,
        "tax" : widget.tax,
        "tax_amount" : widget.taxAmount,
        "delivery_charge" : widget.daliveryCharge,
        "order_type" : widget.orderType,
        "postal_code" : _pin.text,
        "notes" : _note.text,
        "building" : _floatNo.text,
        "landmark" : _landMark.text,
        "email" : Email,
        "name" : Name,
      };

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var token = localStorage.getString("token");
      var response = await http.post(Uri.parse(ApiService.orderCreate),
          body: data,
          headers: {
            "Authorization" : "Bearer $token"
          }
      );
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        if(data["status_code"]==200){
          EasyLoading.dismiss();
          showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
                content: Container(
                  height: 240,
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset("assets/images/success.png", height: 80, width: 80, fit: BoxFit.cover,),
                      ),
                      SizedBox(height: 20,),
                      BigText(text: "Success", size: 10.sp,),
                      SizedBox(height: 5,),
                      MediunText(text: "order_msg".tr, size: 10.sp,),
                      SizedBox(height: 15,),
                      Divider(height: 1, color: appColors.gray,),
                      SizedBox(height: 15,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.green,
                          ),
                          child: MediunText(text: "Go to Main Page", color: appColors.white,),
                        ),
                      )
                    ],

                  ),
                )
            ),);

        }else{
          EasyLoading.dismiss();
          ShowToast("Something went wearing").errorToast();
        }
      }else{
        print("something is wearing");
        EasyLoading.dismiss();
      }
    }



  }


}
