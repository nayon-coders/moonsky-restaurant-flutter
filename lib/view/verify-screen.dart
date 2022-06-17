import 'package:flutter/material.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/view/home-screen/home-screen.dart';
import 'package:moonskynl_food_delivery/view/login-screen.dart';
import 'package:moonskynl_food_delivery/widget/big-text.dart';
import 'package:sizer/sizer.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {

  final _verifyCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigText(text: "Verify Account", size: 11.sp,),
            const SizedBox(height: 20,),

            TextField(
              controller: _verifyCode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Verify Code",
                labelText: "Verify Code ",
                border: new OutlineInputBorder(
                  borderSide: new BorderSide(width: 3, color: appColors.gray),
                ),
                prefixIcon: Icon(
                  Icons.supervisor_account,
                  color: appColors.gray,
                ),
              ),
            ),


            const SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  setState((){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                  });
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                    backgroundColor: MaterialStateProperty.all(appColors.mainColor)
                ),
                child:Text("Verified",
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
    );
  }
}
