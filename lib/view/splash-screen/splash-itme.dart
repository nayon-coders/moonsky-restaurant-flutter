import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:moonskynl_food_delivery/view/home-screen/home-screen.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/view/login-screen.dart';
import 'package:moonskynl_food_delivery/widget/big-text.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SplashItem extends StatefulWidget {
  const SplashItem({Key? key}) : super(key: key);

  @override
  State<SplashItem> createState() => _SplashItemState();
}

class _SplashItemState extends State<SplashItem> {
int index = 0;
bool _isSpalshComplete = false;
 List SelectedItem = [
   firstItem(),
   SecoundItem(),
   TheredScreen(),
 ];


getData()async{
  if(index == 1) {
    _isSpalshComplete = true;
    SharedPreferences locaStorage = await SharedPreferences.getInstance();
    locaStorage.setBool("isFirstTime", true);
  }
  if(index < 2){
    index++;
  }else{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
  }
  print(index);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20, top: 20),
            child: TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
              child: Text(
                "SKIP",
                style: TextStyle(
                  color: appColors.gray,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SelectedItem[index],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 40, right: 40, bottom: 30),
        child: ElevatedButton(
          onPressed: () async{
            setState((){

              getData();

            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(appColors.mainColor)
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row( 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isSpalshComplete ? Text("Get Started",
                  style: TextStyle(
                    color: appColors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),

                ):Text("Next",
                  style: TextStyle(
                    color: appColors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),

                ),
                SizedBox(width: 10,),
                Icon(
                  Icons.arrow_right_alt,
                  color: appColors.white,
                  size: 25.sp,
                )
              ],
            ),
          ),

        ),
      ),
    );
  }

}

class firstItem extends StatelessWidget {
  const firstItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Image.asset("assets/images/selectfood.png",
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 1.5,
            fit: BoxFit.contain,
          ),
        ),
        BigText(text: "Select You Food", size: 19.sp,),
        SizedBox(height: 20,),
        Center(
            child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: appColors.gray,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp
              ),
            ))

      ],
    );
  }
}


class SecoundItem extends StatelessWidget {
  const SecoundItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Center(
          child: Image.asset("assets/images/adress.png",
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 1.5,
            fit: BoxFit.contain,
          ),
        ),
        BigText(text: "Enter Your Address", size: 19.sp,),
        SizedBox(height: 20,),
        Center(
            child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: appColors.gray,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp
              ),
            ))

      ],
    );
  }
}

class TheredScreen extends StatelessWidget {
  const TheredScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Center(
          child: Image.asset("assets/images/fastesdelivery.png",
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 1.5,
            fit: BoxFit.contain,
          ),
        ),
        Center(child: BigText(text: "Get Your Fastest Delivery", size: 19.sp,)),
        SizedBox(height: 20,),
        Center(
            child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: appColors.gray,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp
              ),
            ))

      ],
    );
  }
}


