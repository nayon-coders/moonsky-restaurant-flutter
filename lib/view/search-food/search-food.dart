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

class SearchFood extends StatefulWidget {
  const SearchFood({Key? key}) : super(key: key);

  @override
  State<SearchFood> createState() => _SearchFoodState();
}

class _SearchFoodState extends State<SearchFood> {

  final _serch = TextEditingController();

  @override
  void initState() {
    super.initState();
    ///whatever you want to run on page build
    _getSearchFood();
  }
  Future _getSearchFood() async{
    var response = await CallApi().getData(ApiService.BaseUrl + "/auth/product/single-product-search/${_serch.text.toString()}");
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
        title: BigText(text: "search".tr, size: 11.sp,),
        centerTitle: true,
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
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
                  Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _serch,
                        onChanged: (value){
                          setState((){});
                        },
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding:
                            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "search".tr),
                      )
                  ),
                  const SizedBox(width: 10,),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: appColors.mainColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.data_object_sharp,
                      color: appColors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
              height: MediaQuery.of(context).size.height/1.2,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: _getSearchFood(),
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
                      if(_serch.text.isNotEmpty){
                        if(snapshot.data["getitem"].length > 0){
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              return Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
                                child:  GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleFoodDetails(foodId: snapshot.data["getitem"][index]["id"])));
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
                                            child: Image.network(snapshot.data["getitem"][index]["itemimage"]["image"],height: 100, width: 100, fit: BoxFit.cover,)
                                        ),
                                        SizedBox(width: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 180,
                                              child: Text("${snapshot.data["getitem"][index]["item_name"]}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/1.9,
                                              child: Text("${snapshot.data["getitem"][index]["category"]["category_name"]}",
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                  color: appColors.gray,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                BigText(text: "\$${snapshot.data["getitem"][index]["item_price"]}", size: 10.sp,),
                                                const SizedBox(width: 20,),
                                                Row(
                                                  children: const [
                                                    Icon(Icons.star_border, color: appColors.mainColor,),

                                                    Text('4.6', style: TextStyle(fontSize: 18,color: appColors.mainColor),),

                                                  ],
                                                ),
                                                const SizedBox(width: 30,),
                                                Container(
                                                  padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                                                  decoration: BoxDecoration(
                                                    color: appColors.mainColor,
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Text("${snapshot.data["getitem"][index]["delivery_time"]}",
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                      color: appColors.white,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w600,

                                                    ),
                                                  ),
                                                ),
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
                          return  NotDataFound(text: "no_data_found".tr);
                        }
                      }else{
                        return  NotDataFound(text: "no_data_found".tr);
                      }

                  }else{
                    return NotDataFound(text: "no_data_found".tr);
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
        _getSearchFood();
        ShowToast("Remove from favorite list").successToast();
        EasyLoading.dismiss();
      }
    }
    EasyLoading.dismiss();
  }

}
