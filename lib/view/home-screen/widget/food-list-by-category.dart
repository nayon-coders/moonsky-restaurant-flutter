import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moonskynl_food_delivery/service/apis.dart';
import 'package:moonskynl_food_delivery/service/call-api.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/view/single-food-details/single-food-details.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:sizer/sizer.dart';

import '../../../widget/big-text.dart';

class FoodListByCategory extends StatefulWidget {
  final dynamic catId;
  FoodListByCategory(this.catId,);

  @override
  State<FoodListByCategory> createState() => _FoodListByCategoryState();
}

class _FoodListByCategoryState extends State<FoodListByCategory> {

  @override
  void initState() {
    super.initState();
    ///whatever you want to run on page build
    
  }
  
  Future _getCategory() async{
    var response = CallApi().getData(ApiService.categoryUrl);

  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleFoodDetails()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 280,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              width: 150,
              padding: EdgeInsets.only(bottom: 20),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: appColors.white,
                boxShadow: [
                  BoxShadow(
                    color: appColors.gray200,
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/food1.jpg", fit: BoxFit.cover, height: 140,),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BigText(text: "Razmah Masala(Vegan)", size: 7.sp,),
                        const SizedBox(height: 5,),
                        Text("TANDOORI ROTI",style: TextStyle(fontSize: 6.sp),)
                      ],
                    ),
                  ),

                  const SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MediunText(text: "\$20.25", size: 10.sp,),
                        Icon(
                          Icons.favorite_border,
                          color: appColors.mainColor,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(width: 5,);
          },
        ),
      ),
    );
  }
}


