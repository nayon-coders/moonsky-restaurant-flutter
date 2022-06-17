import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/widget/NoDataFound.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../service/apis.dart';
import '../../service/call-api.dart';
import '../../show-toast.dart';
import '../../widget/big-text.dart';

class MyOrdersList extends StatefulWidget {
  const MyOrdersList({Key? key}) : super(key: key);

  @override
  State<MyOrdersList> createState() => _MyOrdersListState();
}

class _MyOrdersListState extends State<MyOrdersList> {

  @override
  void initState() {
    super.initState();
    ///whatever you want to run on page build
    orderListData = _getOrderListData();
  }

  Future? orderListData;

  Future _getOrderListData() async{
    var response = await CallApi().getData(ApiService.orderList);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        var order =  data['data'];
        return order;
      }else{
        var order =  jsonDecode(response.body)['data'];
        print(order);
        return order;

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
        title: BigText(text: "my_order".tr, size: 11.sp,),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Container(
            width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                future: orderListData,
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: appColors.gray200,
                          highlightColor: appColors.white,
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 100,
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: appColors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: appColors.gray200,
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50, color: appColors.gray,),
                                    const SizedBox(height: 5,),
                                    Container(
                                      width: 100, color: appColors.gray,),
                                    const SizedBox(height: 5,),
                                    Container(
                                      width: 100, color: appColors.gray,),
                                    const SizedBox(height: 5,),
                                    Container(
                                      width: 100, color: appColors.gray,),

                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 30, color: appColors.gray,),
                                    const SizedBox(height: 5,),
                                    Container(
                                      width: 50, color: appColors.gray,),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data.length != 0) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            var paymentType;
                            var OrderStatus;
                            var orderType;
                            bool isCanRate = false;
                            bool isRattingComplete = false;

                            /// TODO: Order Payment method
                            if (snapshot.data[index]["order_number"] == "1") {
                              paymentType = "Razorpay Payment";
                            } else if (snapshot.data[index]["order_number"] == "2") {
                              paymentType = "Stripe Payment";
                            } else if (snapshot.data[index]["order_number"] == " 3")
                              paymentType = "Wallet Payment";
                            else {
                              paymentType = "cash_pay".tr;
                            }

                            /// TODO: Order status
                            if (snapshot.data[index]["status"] == "1") {
                              OrderStatus = "Order placed ";
                            } else if (snapshot.data[index]["status"] == "2") {
                              OrderStatus = "Ready for order ";
                            } else if (snapshot.data[index]["status"] == "3") {
                              OrderStatus = "Order on the Go";
                            }else if(snapshot.data[index]["status"] == "4"){
                              OrderStatus = "Order delivered";
                            }else {
                              return Center();
                            }

                            /// TODO: Order type
                            if (snapshot.data[index]["order_type "] == "1") {
                              orderType = "pickup".tr;
                            } else {
                              orderType = "delivery".tr;
                              isCanRate = true;
                            }



                            return Container(
                              margin: EdgeInsets.only(bottom: 20,),
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: appColors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: appColors.gray200,
                                    blurRadius: 20,
                                    spreadRadius: 1,
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      MediunText(text: "${snapshot
                                          .data[index]["date"]}"),
                                      const SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          MediunText(text: "order_id".tr),
                                          BigText(text: " ${snapshot
                                              .data[index]["order_number"]}",
                                            size: 9.sp,)
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      MediunText(text: "$paymentType",
                                        color: appColors.mainColor,),
                                      const SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          MediunText(text: "order_status".tr,),
                                          MediunText(text: "$OrderStatus",
                                            color: appColors.mainColor,),
                                        ],
                                      ),

                                    ],
                                  ),
                                  Column(
                                    children: [
                                      BigText(text: "\$${snapshot
                                          .data[index]["total_price"]}",
                                        size: 10.sp,
                                        color: appColors.mainColor,),
                                      const SizedBox(height: 5,),
                                      MediunText(text: "$orderType"),
                                      isCanRate == true ? isRattingComplete == false ? GestureDetector(
                                        onTap: (){
                                         setState((){
                                           isRattingComplete = true;
                                           print("is complete");
                                         });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 3, top: 3),
                                          decoration: BoxDecoration(
                                            color: appColors.mainColor,
                                            borderRadius: BorderRadius.circular(3)
                                          ),
                                          child: MediunText(text: "Ratting ⭐", color: appColors.white,),
                                        ),
                                      ): GestureDetector(
                                        onTap: (){
                                          setState((){
                                            print("is complete");
                                            isRattingComplete = false;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 3, top: 3),
                                          decoration: BoxDecoration(
                                              color: appColors.gray,
                                              borderRadius: BorderRadius.circular(3)
                                          ),
                                          child: MediunText(text: "Ratting ⭐", color: appColors.white,),
                                        ),
                                      ) :Center(),

                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                      );
                    } else {
                      return NotDataFound(text: "no_data_found".tr);
                    }
                  } else {
                    return Center();
                  }
                }
            ),
        ),
      ),
    );
  }
}
