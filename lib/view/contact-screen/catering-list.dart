import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moonskynl_food_delivery/service/apis.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/widget/NoDataFound.dart';
import 'package:moonskynl_food_delivery/widget/big-text.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../service/call-api.dart';
import '../../show-toast.dart';
import '../single-food-details/single-food-details.dart';

class CateringList extends StatefulWidget {
  const CateringList({Key? key}) : super(key: key);

  @override
  State<CateringList> createState() => _CateringListState();
}

class _CateringListState extends State<CateringList> {

  @override
  void initState() {
    super.initState();
    ///whatever you want to run on page build
    CateringUserList = _getCateringList();
  }

  Future? CateringUserList;

  Future _getCateringList() async{
    var response = await CallApi().getData(ApiService.CateringList);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        var catering =  data['data'];
        print(catering);
        return catering;
      }else{
        var catering =  jsonDecode(response.body)['data'];
        print(catering);
        return catering;

      }
    }else{
      ShowToast("Server Error ${response.statusCode}");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_rounded, color: appColors.mainColor,)),
        title: BigText(text: "catering_list".tr, size: 11.sp,),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height/1.2,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: CateringUserList,
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
                            child:Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset("assets/images/food1.jpg",height: 100, width: 100, fit: BoxFit.cover,)
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 200,
                                      child: Text("CHANA MASALA (VEGAN) sdfasd fasdfs dasdfsd fasd",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text("Category",
                                      style: TextStyle(
                                          color: appColors.gray,
                                          fontSize: 15
                                      ),
                                    ),
                                    const SizedBox(height: 15,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        BigText(text: "\$30.56", size: 10.sp,),
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
                            padding:  EdgeInsets.symmetric(horizontal: 2.h, vertical: 10),
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
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        MediunText(text: snapshot.data[index]["date"].toString()),
                                        MediunText(text: "Quantity: ${snapshot.data[index]["amount"].toString()} "),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                   Row(
                                     children: [
                                       BigText(text: "Details: ",size: 9.sp,),
                                       const SizedBox(height: 5,),
                                       MediunText(text: snapshot.data[index]["description"].toString()),

                                     ],
                                   )

                                  ],
                                ),
                              ),
                          );
                        },

                      );
                    }else{
                      return NotDataFound(text: "no_data_found".tr);

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
