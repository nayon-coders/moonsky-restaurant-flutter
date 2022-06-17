import 'package:flutter/material.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:sizer/sizer.dart';

import '../widget/big-text.dart';
import '../widget/medium-text.dart';
import 'my-account/accout.dart';

class SuccessOrder extends StatefulWidget {
  const SuccessOrder({Key? key}) : super(key: key);

  @override
  State<SuccessOrder> createState() => _SuccessOrderState();
}

class _SuccessOrderState extends State<SuccessOrder> {

  void _showSuccess(){
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
