import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:moonskynl_food_delivery/service/apis.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/view/home-screen/widget/food-list-by-category.dart';
import 'package:moonskynl_food_delivery/view/show-product/show-category-product.dart';
import 'package:moonskynl_food_delivery/widget/NoDataFound.dart';
import 'package:moonskynl_food_delivery/widget/big-text.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../service/call-api.dart';
import '../../show-toast.dart';
import '../single-food-details/single-food-details.dart';

class ShowCategory extends StatefulWidget {
  const ShowCategory({Key? key,}) : super(key: key);

  @override
  State<ShowCategory> createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {

  @override
  void initState() {
    super.initState();
    ///whatever you want to run on page build
    categoryList = _getCategory();
  }

  Future? categoryList;
  String? CatName;

  _getCategory() async{
    var response = await CallApi().getData(ApiService.categoryUrl);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        var catList = jsonDecode(response.body.toString())['data'];
        return catList;
      }else{
        var catList = jsonDecode(response.body.toString())['data'];
        return catList;
      }
    }else{
      ShowToast("Searver Error ${response.statusCode}");
    }

  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: appColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_rounded, color: appColors.mainColor,)),
        title: BigText(text: "category_list".tr, size: 11.sp,),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height/1.2,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: categoryList,
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
                      return StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) setState) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              return Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
                                child:  GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowCategoryFoods(catID: snapshot.data[index]['id'], catName: snapshot.data[index]['category_name'])));
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
                                    child: ListTile(
                                      leading: Image.network("https://moonskynl.com/public/images/category/${ snapshot.data[index]["image"]}", height: 50,width: 50, fit: BoxFit.cover,),
                                      title: Text("${snapshot.data[index]['category_name']}"),
                                    )
                                  ),

                                ),
                              );
                            },

                          );
                        },

                      );
                    }else{
                      return NotDataFound(text: "no_data_fount".tr);

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
  
}
