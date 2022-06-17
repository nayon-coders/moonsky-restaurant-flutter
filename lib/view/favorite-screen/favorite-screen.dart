import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:moonskynl_food_delivery/service/apis.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/widget/NoDataFound.dart';
import 'package:moonskynl_food_delivery/widget/big-text.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../service/call-api.dart';
import '../../show-toast.dart';
import '../single-food-details/single-food-details.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  @override
  void initState() {
    super.initState();
    ///whatever you want to run on page build
    favoriteFoodList = _getfavoriteFoodList();
  }

  Future? favoriteFoodList;

  Future _getfavoriteFoodList() async{
    var response = await CallApi().getData(ApiService.favoriteFood);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        var food =  data['data'];
        print(food);
        return food;
      }else{
        var food =  jsonDecode(response.body)['data'];
        print(food);
        return food;

      }
    }else{
      ShowToast("Server Error ${response.statusCode}");
    }

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
        title: BigText(text: "favorite_list".tr, size: 11.sp,),
        centerTitle: true,
      ),

      body: Column(
        children: [
           Container(
              height: MediaQuery.of(context).size.height/1.2,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: _getfavoriteFoodList(),
                builder: (context, AsyncSnapshot<dynamic> snapshot){

                    if(snapshot.connectionState == ConnectionState.waiting){
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index){
                          return Shimmer.fromColors(
                            baseColor: appColors.gray200,
                            highlightColor: appColors.white,
                            child: Container(
                              margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                              padding: EdgeInsets.all(10),
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
                              child:Container(height: 100,)
                            ),
                          );
                        },

                      );
                    }else if(snapshot.hasData){
                      if(snapshot.data.length != 0){
                        return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
                            child:  GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleFoodDetails(foodId: snapshot.data[index]["id"])));
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
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
                                child:Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(snapshot.data[index]["itemimage"]["image"],height: 100, width: 100, fit: BoxFit.cover,)
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 180,
                                              child: Text("${snapshot.data[index]["item_name"]}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: (){
                                                deleteFaverite(snapshot.data[index]["id"].toString());
                                              },
                                              icon: Icon(
                                                Icons.favorite,
                                                color: appColors.mainColor,

                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Container(
                                          width: width/1.9,
                                          child: Text("${snapshot.data[index]["category"]["category_name"]}",
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                color: appColors.gray,
                                                fontSize: 15
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            BigText(text: "\€${snapshot.data[index]["item_price"]}", size: 10.sp,),
                                            const SizedBox(width: 30,),
                                            Row(
                                              children: const [
                                                Icon(Icons.star_border, color: appColors.mainColor,),

                                                Text('4.6', style: TextStyle(fontSize: 18,color: appColors.mainColor),),
                                              ],
                                            )
                                          ],
                                        )

                                      ],
                                    )

                                  ],
                                ),
                              ),

                            ),
                          );
                        },

                      );
                      }else{
                        return   NotDataFound(text: "no_data_found".tr);

                      }
                    }else{
                      return Center(child: const Text("Something want warng with API / Server"));
                    }


                },
              )
            )
        ],
      ),
    );
  }
  deleteFaverite(id)async{

    EasyLoading.show();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString("token");
    var response = await http.post(Uri.parse("${ApiService.BaseUrl}/auth/add-to-fav/delete/${id.toString()}"),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );

    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        _getfavoriteFoodList();
        ShowToast("Remove from favorite list").successToast();
        EasyLoading.dismiss();
      }
    }
    EasyLoading.dismiss();
  }

}
