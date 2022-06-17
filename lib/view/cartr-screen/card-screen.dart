import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/view/checkout/checkout.dart';
import 'package:moonskynl_food_delivery/view/my-account/accout.dart';
import 'package:moonskynl_food_delivery/widget/NoDataFound.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../../service/apis.dart';
import '../../service/call-api.dart';
import '../../show-toast.dart';
import '../../widget/big-text.dart';
import 'package:http/http.dart' as http;
class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    super.initState();
    ///whatever you want to run on page build
    cartFoodList = _getCartFoodListFoodList();
  }

  Future? cartFoodList;

  bool _getData = false;
  dynamic qty = 10;
  dynamic item_price = 0;
  dynamic subTotal = 0;
  dynamic total = 0;
  dynamic withTex = 0;

  bool isCardIsEmpty = false;
  
  String? tax;
  String? delivery_charge;
  String? currency;
  String? map;

  Future _getCartFoodListFoodList() async{
    var response = await CallApi().getData(ApiService.cartList);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        setState((){
          _getData = true;
         tax = data["taxval"]["tax"];
          delivery_charge = data["taxval"]["delivery_charge"];
          currency = data["taxval"]["currency"];
          map = data["taxval"]["map"];

        });
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
    var height = MediaQuery.of(context).size.height;
    return Scaffold(

      backgroundColor: appColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_rounded, color: appColors.mainColor,)),
        title: BigText(text: "cart".tr, size: 11.sp,),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
            child: Column(
              children: [
                Container(
                  width: width,
                  child: FutureBuilder(
                    future: cartFoodList,
                      builder: (context,AsyncSnapshot<dynamic> snapshot){

                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                color: appColors.mainColor,
                              ),
                            );
                          }else if(snapshot.hasData){
                            if(snapshot.data.length > 0) {

                              return  ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          qty = snapshot.data[index]["qty"];
                                           dynamic subTotalAmount = 0;
                                           print(item_price);

                                          for(var i = 0; i < snapshot.data.length; i ++) {
                                            item_price = double.parse(snapshot.data[i]["price"]);
                                            subTotalAmount  = subTotalAmount + item_price;
                                            subTotal = subTotalAmount;
                                          }
                                          withTex = (double.parse("5")/100*subTotal);
                                          total = (double.parse(delivery_charge!) + subTotal + withTex);

                                          return Container(
                                            width: width,
                                            height: height,
                                            child: Column(
                                              children: [
                                              Container(
                                                width: width,
                                                height: height/2.5,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: snapshot.data.length,
                                                  itemBuilder: (context, index) {
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 15),
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                        color: appColors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: appColors
                                                                .gray200,
                                                            blurRadius: 20,
                                                            spreadRadius: 1,
                                                          )
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius: BorderRadius
                                                                  .circular(10),
                                                              child: Image.network(
                                                                "${snapshot
                                                                    .data[index]["itemimage"]["image"]}",
                                                                height: 80,
                                                                width: 80,
                                                                fit: BoxFit.cover,)
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      snapshot.data[index]["item_name"],
                                                                      style: TextStyle(
                                                                        fontSize: 10 .sp,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox( height: 5,),
                                                                  snapshot.data[index]["item_notes"] != null
                                                                      ? SizedBox(
                                                                    width: 200,
                                                                    child: MediunText(text: "${snapshot.data[index]["item_notes"]}"),
                                                                  ): MediunText(text: "No Note Attach"),
                                                                  const SizedBox( height: 10,),
                                                                  BigText(
                                                                    text: "\$${snapshot.data[index]["price"]}",
                                                                    size: 10.sp,),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                width: 10,),
                                                              Container(
                                                                height: 30,
                                                                width: 30,
                                                                decoration: BoxDecoration(
                                                                    color: appColors
                                                                        .mainColor,
                                                                    borderRadius: BorderRadius
                                                                        .circular(100)
                                                                ),
                                                                child: IconButton(
                                                                  onPressed: () {
                                                                    _deleteCartItem(snapshot.data[index]["id"].toString());
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.delete,
                                                                    color: appColors
                                                                        .white,
                                                                    size: 11.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )

                                                        ],
                                                      ),

                                                    );
                                                  }
                                                ),
                                              ),

                                                const SizedBox(height: 30,),
                                                // Container(
                                                //   margin: EdgeInsets.only(bottom: 15),
                                                //   padding: EdgeInsets.only(top: 10, bottom: 10),
                                                //   decoration: BoxDecoration(
                                                //     borderRadius: BorderRadius.circular(10),
                                                //     color: appColors.white,
                                                //     boxShadow: [
                                                //       BoxShadow(
                                                //         color: appColors.gray200,
                                                //         blurRadius: 20,
                                                //         spreadRadius: 1,
                                                //       )
                                                //     ],
                                                //   ),
                                                //   child: Row(
                                                //     children: [
                                                //       SizedBox(
                                                //         width: MediaQuery.of(context).size.width/1.6,
                                                //         child: TextField(
                                                //           decoration: InputDecoration(
                                                //               hintText: "Promo Code",
                                                //               border: InputBorder.none,
                                                //               focusedBorder: InputBorder.none,
                                                //               enabledBorder: InputBorder.none,
                                                //               errorBorder: InputBorder.none,
                                                //               disabledBorder: InputBorder.none,
                                                //               contentPadding: EdgeInsets.only(left: 20, right: 20)
                                                //           ),
                                                //         ),
                                                //       ),
                                                //       Container(
                                                //         padding: EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                                                //         decoration: BoxDecoration(
                                                //           borderRadius: BorderRadius.circular(50),
                                                //           color: appColors.mainColor,
                                                //           boxShadow: [
                                                //             BoxShadow(
                                                //               color: appColors.gray200,
                                                //               blurRadius: 20,
                                                //               spreadRadius: 1,
                                                //             )
                                                //           ],
                                                //         ),
                                                //         child: MediunText(text: "Apply", color: appColors.white,),
                                                //       )
                                                //     ],
                                                //   ),
                                                // ),

                                                Container(
                                                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                                  decoration: BoxDecoration(
                                                    color: appColors.white,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          MediunText(text: "sub_total".tr, size: 10.sp,),
                                                          BigText(text: "\$$subTotal", size: 10.sp,)
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5,),
                                                      Divider(height: 2, color: appColors.gray,),
                                                      const SizedBox(height: 15,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          MediunText(text: "Tax(5%): ", size: 10.sp,),
                                                          BigText(text: "\$${withTex}", size: 10.sp,)
                                                        ],
                                                      ),
                                                      // const SizedBox(height: 15,),
                                                      // Row(
                                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //   children: [
                                                      //     MediunText(text: "Discount(5%): ", size: 10.sp,),
                                                      //     BigText(text: "\$15.54", size: 10.sp,)
                                                      //   ],
                                                      // ),
                                                      const SizedBox(height: 5,),
                                                      Divider(height: 2, color: appColors.gray,),


                                                      const SizedBox(height: 15,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          MediunText(text: "delivery".tr, size: 10.sp,),
                                                          BigText(text: "\$${delivery_charge.toString()}", size: 10.sp,)
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5,),
                                                      Divider(height: 2, color: appColors.gray,),


                                                      const SizedBox(height: 15,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          BigText(text: "total".tr, size: 10.sp,),
                                                          BigText(text: "\$${total}", size: 11.sp,)
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5,),
                                                      Divider(height: 2, color: appColors.gray,),




                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                    );

                            }else{
                                isCardIsEmpty = true;
                              return NotDataFound(text: "no_data_found".tr);
                              }
                          }else{
                            return NotDataFound(text: "no_data_found".tr);
                          }

                      }
                  ),
                ),
              ],
            ),
          ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: (){
          //_checkOut();
          //_showSuccess();
          isCardIsEmpty ? null :
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
             Checkout(
                 totalOrders: total.toString(),
                 discoundPrice: "null",
                 promoCode: "null",
                 tax: tax!.toString(),
                 taxAmount: withTex.toString(),
                 daliveryCharge: delivery_charge!.toString(),
                 orderType: "2",
             )
          ));
        },
        child: Container(
          padding: EdgeInsets.only(left: 60, right: 60, bottom: 20, top: 20),
          margin: EdgeInsets.only(left: 80, right: 50, bottom: 30, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: appColors.mainColor,
            boxShadow: [
              BoxShadow(
                color: appColors.gray200,
                blurRadius: 20,
                spreadRadius: 1,
              )
            ],
          ),
          child: BigText(text: "checkout".tr, color: appColors.white, size: 13.sp,),
        ),
      )
    );
  }


  void _checkOut(){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return Container(
                  height: MediaQuery.of(context).size.height/4,
                  child:Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: appColors.mainColor),
                          ),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Image.asset("assets/images/levering.png", height: 30, width: 30, fit: BoxFit.cover,),
                              const SizedBox(height: 10,),
                              MediunText(text: "Levering"),
                            ],
                          ),
                        )
                      ],
                    )
                  )
                );
              });
        });
  }

  void _deleteCartItem(id)async{
    EasyLoading.show(status: "Deleting...", maskType: EasyLoadingMaskType.black);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString("token");

    var response = await http.post(Uri.parse("${ApiService.BaseUrl}/auth/add-to-cart/delete/$id"),
      headers: {
      "Authorization" : "Bearer $token"
      }
    );
    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        cartFoodList = _getCartFoodListFoodList();
        ShowToast("Food removed from cart list").successToast();
        EasyLoading.dismiss();
      }
    }
    print(response.statusCode);
    EasyLoading.dismiss();
  }


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
              MediunText(text: "You order is created", size: 10.sp,),
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




}
