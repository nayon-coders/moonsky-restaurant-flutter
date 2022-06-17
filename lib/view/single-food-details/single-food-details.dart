import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/view/cartr-screen/card-screen.dart';
import 'package:moonskynl_food_delivery/widget/big-text.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../service/apis.dart';
import '../../service/call-api.dart';
import '../../show-toast.dart';

class SingleFoodDetails extends StatefulWidget {
  final dynamic foodId;
  const SingleFoodDetails({Key? key, required this.foodId}) : super(key: key);

  @override
  State<SingleFoodDetails> createState() => _SingleFoodDetailsState();
}

class _SingleFoodDetailsState extends State<SingleFoodDetails> {
  int qty = 1;
  var foodName;
  var foodDes;

  final _notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    ///whatever you want to run on page build
    SingleFoodDetails = _getfavoriteFoodList();
  }

  Future? SingleFoodDetails;

  Future _getfavoriteFoodList() async{
    var response = await CallApi().getData("${ApiService.BaseUrl}/auth/product/single-product/${widget.foodId.toString()}");
    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        var food =  jsonDecode(response.body)['data'];
        print(food);
        return food;
      }else{
        var foodDetailsItems =  jsonDecode(response.body)['data']["getitem"];
        print(foodDetailsItems);
        return foodDetailsItems;

      }
    }else{
      ShowToast("Server Error ${response.statusCode}");
    }

  }




  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SingleFoodDetails,
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        }else if(snapshot.hasData){
          var foodPrice = double.parse(snapshot.data["getitem"][0]["item_price"]);
          var totalPrice = qty * foodPrice;
          return Scaffold(
            backgroundColor: appColors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height/2,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data['getitem'][0]['itemimage']['image'],),
                              fit: BoxFit.cover,
                            )
                        ),
                        child:  Padding(
                          padding:  EdgeInsets.only(left: 20, right: 20, top: 5.h),
                          child:
                          Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: appColors.mainColor
                                  ),
                                  child: IconButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: appColors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: appColors.mainColor
                                  ),
                                  child: snapshot.data['getitem'][0]["is_favorite"] == "1" ? IconButton(
                                      onPressed: (){
                                        deleteFaverite(snapshot.data['getitem'][0]["id"]);
                                      },
                                      icon: Icon(
                                        Icons.favorite,
                                        color: appColors.white,
                                        size: 20,
                                      )
                                  ): IconButton(
                                      onPressed: (){
                                        addFaverite(snapshot.data['getitem'][0]["id"]);
                                      },
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: appColors.white,
                                        size: 20,
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: appColors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(100),
                                topLeft: Radius.circular(100),
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: (){
                                  setState((){
                                    if(qty > 1 ){
                                      qty--;
                                    }else{
                                      qty = 1;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: appColors.mainColor,
                                ),
                              ),
                              BigText(text: "$qty",size: 15.sp,),
                              IconButton(
                                onPressed: (){
                                  setState((){
                                    if(qty != 0 ){
                                      qty++;
                                    }else{
                                      qty = 1;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: appColors.mainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(text: "${snapshot.data['getitem'][0]['item_name']}", size: 11.sp,),
                          const SizedBox(height: 5,),
                          MediunText(text: "${snapshot.data['getitem'][0]['category']["category_name"]}", color: appColors.gray, size: 9.sp,),
                          const SizedBox(height: 5,),
                          MediunText(text: "${snapshot.data['getitem'][0]["delivery_time"]}", color: appColors.black, size: 9.sp,),
                          const SizedBox(height: 15,),
                          BigText(text: "Details", size: 10.sp,),
                          const SizedBox(height: 5,),
                          MediunText(text: "${snapshot.data['getitem'][0]["item_description"]}", color: appColors.gray, size: 9.sp,),


                          const SizedBox(height: 15,),
                          TextField(
                            controller: _notes,
                            maxLines: 3,
                            decoration: InputDecoration(
                                hintText: "Write Notes...",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2, color: appColors.gray)
                                )
                            ),
                          ),
                          const SizedBox(height: 30,),
                        ],
                      )),
                ],
              ),
            ),
            bottomNavigationBar: GestureDetector(
                onTap: (){
                  _addtocart(
                    widget.foodId.toString(),
                    "",
                    qty.toString(),
                    _notes.text,
                    totalPrice.toString(),
                  );
                },
                child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: appColors.mainColor,
                ),
                margin: EdgeInsets.only(left: 80, right: 80, bottom: 30,),
                padding: EdgeInsets.all(10),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: (){

                          },
                          icon: Icon(
                            Icons.add_shopping_cart_outlined,
                            color: appColors.white,
                            size: 25.sp,
                          )
                      ),
                      BigText(text: "\$${totalPrice}", size: 13.sp, color: appColors.white,),
                    ],
                  ),
                )
            ),
          );
        }else{
          return Center();
        }
      },
    );
  }

  void _addtocart(String foodID, String addons_id, String qty, String item_notes, String price, ) async{

    EasyLoading.show();
    var data= {
      "item_id" : foodID,
      "addons_id" : addons_id,
      "qty" : qty,
      "item_notes" : item_notes,
      "price" : price,
    };
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString("token");
    var response = await http.post(Uri.parse(ApiService.addCart),
      body: data,
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        print(data["status_code"]);
         ShowToast("Food Add To Cart")..successToast();
         Navigator.push(context, MaterialPageRoute(builder: (context)=>Cart()));
      }else{
        print(data["status_code"]);
        ShowToast(data["massage"])..successToast();
      }
    }
    EasyLoading.dismiss() ;

  }

  addFaverite(id) async{
    EasyLoading.show();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString("token");
    var response = await http.post(Uri.parse(ApiService.addFaveriot),
        body: {
          "item_id" : id.toString(),
        },
        headers: {
          "Authorization" : "Bearer $token"
        }
    );

    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        ShowToast("Add to favorite list").successToast();
        EasyLoading.dismiss();
      }
    }
    EasyLoading.dismiss();
  }

  deleteFaverite(id)async{
    EasyLoading.show();
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString("token");
    var response = await http.post(Uri.parse("${ApiService.BaseUrl}/auth/add-to-fav/delete/$id"),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );

    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        ShowToast("Remove from favorite list").errorToast();
        EasyLoading.dismiss();
      }
    }
    EasyLoading.dismiss();
  }


}
