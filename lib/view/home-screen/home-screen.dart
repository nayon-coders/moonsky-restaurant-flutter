import 'dart:convert';
import 'dart:ffi';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:moonskynl_food_delivery/view/cartr-screen/card-screen.dart';
import 'package:moonskynl_food_delivery/view/category_list/category_list.dart';
import 'package:moonskynl_food_delivery/view/contact-screen/contact-screen.dart';
import 'package:moonskynl_food_delivery/view/favorite-screen/favorite-screen.dart';
import 'package:moonskynl_food_delivery/view/my%20order%20list/my-order-list.dart';
import 'package:moonskynl_food_delivery/view/my-account/accout.dart';
import 'package:moonskynl_food_delivery/view/search-food/search-food.dart';
import 'package:moonskynl_food_delivery/widget/NoDataFound.dart';
import 'package:moonskynl_food_delivery/widget/big-text.dart';
import 'package:moonskynl_food_delivery/widget/medium-text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../../service/apis.dart';
import '../../service/call-api.dart';
import '../../show-toast.dart';
import '../show-product/show-category-product.dart';
import '../single-food-details/single-food-details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var catId;
  bool isFav = false;
  late bool _passwordVisible = false;



  @override
  void initState() {
    super.initState();
    ///whatever you want to run on page build
    categoryList = _getCategory();
    favoriteFoodList = _getfavoriteFoodList();
    showReview = _showReview();
    FoodByCategroyList = _getFoodByCategory();
  }


  Future? FoodByCategroyList;
  Future _getFoodByCategory() async{
    var response = await CallApi().getData("${ApiService.BaseUrl}/auth/product/show/${catId}");
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      if(data["status_code"] == 200){
        var foods =  jsonDecode(response.body)['data']['getitem'];
        return foods;
      }else{
        var foods =  jsonDecode(response.body)['data']['getitem'];
        return foods;

      }
    }else{
      ShowToast("Server Error ${response.statusCode}");
    }

  }

  Future? favoriteFoodList;
  Future _getfavoriteFoodList() async{
    var response = await CallApi().getData(ApiService.favoriteFood);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
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

  /// TODO: Show favorite
  Future? showReview;
  _showReview() async{
    var response = await CallApi().getData(ApiService.showReview);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        var showReviewData = jsonDecode(response.body.toString())['data'];
        return showReviewData;
      }else{
        var showReviewData = jsonDecode(response.body.toString())['data'];
        return showReviewData;
      }
    }else{
      ShowToast("Searver Error ${response.statusCode}");
    }

  }

  bool? _isFav;
  bool? _isNotFav;


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf1f1f1),
        body:  Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //top section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/logo.png", height: 30, width: 30,),
                        const SizedBox(width: 10,),
                        BigText(text: "MoonSky", size: 12.sp, )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => MyOrdersList()));
                            },
                            icon: Icon(
                              Icons.list_alt,
                              color: appColors.mainColor,
                              size: 35,
                            )
                        ),
                        MediunText(text: "order_list".tr),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                //seach section
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchFood()));
                  },
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
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                              ),
                              SizedBox(width: 10,),
                              MediunText(text: "search".tr, color: appColors.gray,),
                            ],
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
                const SizedBox(height: 20,),




                Expanded(
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MediunText(text: "Category List", size: 10.sp,),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowCategory()));
                                },
                                child: Text("SEE ALL")
                            ),
                          ],
                        ),
                        //category list
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          margin: EdgeInsets.only(bottom: 20),
                          child: FutureBuilder(
                            future: categoryList,
                            builder: (context, AsyncSnapshot snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Shimmer.fromColors(
                                      baseColor: appColors.gray200,
                                      highlightColor: appColors.white,
                                      child:Container(
                                        width: 100,
                                        margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: appColors.white,
                                          boxShadow:  [
                                            BoxShadow(
                                              color: appColors.gray200,
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(width: 5,);
                                  },
                                );
                              }else if(snapshot.hasData){

                                return ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: (){
                                        setState((){
                                          FoodByCategroyList = _getFoodByCategory();
                                          catId = snapshot.data[index]['id'].toString();
                                          CatName = snapshot.data[index]['category_name'];
                                        });
                                      },
                                      child: Container(
                                        height: 100,
                                          padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2 ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: appColors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: appColors.gray200,
                                                blurRadius: 5,
                                                spreadRadius: 1,
                                              )
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              ClipOval(
                                                child: Image.network("https://moonskynl.com/public/images/category/${ snapshot.data[index]["image"]}", height: 50,width: 50, fit: BoxFit.cover,),
                                              ),
                                              const SizedBox(width: 5,),
                                              MediunText(text: "${ snapshot.data[index]["category_name"]}", size: 10.sp, )
                                            ],
                                          )
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(width: 10,);
                                  },
                                );


                              }else{
                                return Center();
                              }
                            },
                          ),
                        ),
                        //category list
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: width/1.4,
                                child: MediunText(text: "${CatName != null ? CatName : "recent_food".tr}", size: 10.sp,)),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowCategoryFoods(catName: CatName.toString(), catID: catId.toString(),)));
                                },
                                child: Text(CatName == null ? "" : "SEE ALL")
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: StatefulBuilder(
                              builder: (context, setState) {
                                return FutureBuilder(
                                    future: FoodByCategroyList,
                                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return ListView.separated(

                                          scrollDirection: Axis.horizontal,
                                          itemCount: 5,
                                          itemBuilder: (context, index) {
                                            return Shimmer.fromColors(
                                              baseColor: appColors.gray200,
                                              highlightColor: appColors.white,
                                              child: Container(
                                                width: 150,
                                                padding: EdgeInsets.only(
                                                    bottom: 20),
                                                margin: EdgeInsets.only(
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(10),
                                                  color: appColors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: appColors.gray200,
                                                      blurRadius: 5,
                                                      spreadRadius: 1,
                                                    )
                                                  ],
                                                ),
                                                child: Container(
                                                  width: 120, height: 150,),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return SizedBox(width: 5,);
                                          },
                                        );
                                      } else if (snapshot.hasData) {
                                        if (snapshot.data.length != 0) {
                                          return Container(
                                            height: 300,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 5),
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {

                                                if(snapshot.data[index]["is_favorite"] == "1"){
                                                  _isFav = true;
                                                }else{
                                                  _isFav = false;
                                                }

                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                SingleFoodDetails(
                                                                    foodId: snapshot
                                                                        .data[index]["id"]
                                                                        .toString()))
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 170,
                                                    padding: EdgeInsets.only(
                                                        bottom: 20),
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                      color: appColors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: appColors
                                                              .gray200,
                                                          blurRadius: 5,
                                                          spreadRadius: 1,
                                                        )
                                                      ],
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [

                                                        Image.network(
                                                          "${snapshot.data[index]["itemimage"]["image"]}",
                                                          loadingBuilder: (
                                                              BuildContext context,
                                                              Widget child,
                                                              ImageChunkEvent? loadingProgress) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Container(
                                                              margin: EdgeInsets
                                                                  .only(top: 30,
                                                                  bottom: 30,
                                                                  left: 20,
                                                                  right: 20),
                                                              child: Center(
                                                                child: CircularProgressIndicator(
                                                                  strokeWidth: 1,
                                                                  value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                      null
                                                                      ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                      loadingProgress
                                                                          .expectedTotalBytes!
                                                                      : null,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          fit: BoxFit.cover,
                                                          height: 140,
                                                          width: 170,),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(left: 10,
                                                              right: 10,
                                                              top: 10),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              BigText(
                                                                text: snapshot
                                                                    .data[index]["item_name"],
                                                                size: 7.sp,),
                                                              const SizedBox(
                                                                height: 5,),
                                                              Text(snapshot
                                                                  .data[index]["category"]["category_name"],
                                                                style: TextStyle(
                                                                    fontSize: 6
                                                                        .sp),),
                                                              const SizedBox(
                                                                height: 5,),
                                                              snapshot.data[index]["delivery_time"] !="null"? Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 3,
                                                                    bottom: 3),
                                                                decoration: BoxDecoration(
                                                                  color: appColors
                                                                      .mainColor,
                                                                  borderRadius: BorderRadius
                                                                      .circular(
                                                                      5),
                                                                ),
                                                                child: Text(
                                                                  "${snapshot
                                                                      .data[index]["delivery_time"]}",
                                                                  overflow: TextOverflow
                                                                      .clip,
                                                                  style: TextStyle(
                                                                    color: appColors
                                                                        .white,
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight
                                                                        .w600,

                                                                  ),
                                                                ),
                                                              )
                                                                  : Center(),
                                                            ],
                                                          ),
                                                        ),

                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(left: 10,
                                                            right: 10,),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              BigText(
                                                                text: "\$${snapshot
                                                                    .data[index]["item_price"]}",
                                                                size: 9.sp,),

                                                             _isFav == true ? IconButton(
                                                                  onPressed: () {
                                                                    deleteFaverite(snapshot.data[index]["id"].toString());
                                                                  },
                                                                  icon: _isFav == true ? Icon(
                                                                    Icons.favorite,
                                                                    color: appColors.mainColor,
                                                                    size: 20,
                                                                  ): Icon(
                                                                    Icons
                                                                        .favorite_border,
                                                                    color: appColors.mainColor,size: 20,
                                                                  )
                                                              ):  IconButton(
                                                                  onPressed: () {
                                                                    addFaverite( snapshot.data[index]["id"]);
                                                                  },
                                                                  icon: _isFav == true ? Icon(
                                                                    Icons.favorite,
                                                                    color: appColors.mainColor,
                                                                    size: 20,
                                                                  ): Icon(
                                                                    Icons
                                                                        .favorite_border,
                                                                    color: appColors.mainColor,size: 20,
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              separatorBuilder: (context,
                                                  index) {
                                                return SizedBox(width: 5,);
                                              },
                                            ),
                                          );
                                        } else {
                                          return NotDataFound(
                                              text: "no_data_found".tr);
                                        }
                                      } else {
                                        return Center();
                                      }
                                    }
                                );
                              }
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BigText(text: "customer_review".tr, size: 12.sp,),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/5,
                          child: FutureBuilder(
                            future: showReview,
                            builder: (context, AsyncSnapshot<dynamic> snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return ListView.builder(
                                    itemCount: 5,
                                    itemBuilder: (context, index){
                                      return Row(
                                        children: [
                                          Shimmer.fromColors(
                                              baseColor: appColors.gray200,
                                              highlightColor: appColors.white,
                                              child: Container(width: 200, height: 100,)),
                                        ],
                                      );
                                    }
                                );
                              }else if(snapshot.hasData){
                                if(snapshot.data.length !=0){
                                  return Container(

                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index){
                                          return  Row(
                                            children: [
                                              reviewCoustomer( "${snapshot.data[index]["ratting"]}", "${snapshot.data[index]["comment"]}"),
                                            ],
                                          );
                                        }
                                    ),
                                  );

                                }else{
                                  return NotDataFound(text: "No review yet.");
                                }
                              }else{
                                return MediunText(text: "Something went waering to the server");
                              }
                            },
                          ),
                        )
                      ],
                    )
                ),


              ],
            ),
          ),

        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),

          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: appColors.mainColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 30,
                      onPressed: () {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.dashboard,
                            color: appColors.white,
                            size: 18.sp,
                          ),
                          Text(
                            'menu_home'.tr,
                            style: TextStyle(
                              color: appColors.white,
                              fontSize: 9.sp
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 30,
                      onPressed: () {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const FavoriteScreen()));
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  <Widget>[
                          Icon(
                            Icons.favorite_border,
                            color: appColors.white,
                            size: 18.sp,
                          ),
                          Text(
                            'menu_favorite'.tr,
                            style: TextStyle(
                              color: appColors.white,
                              fontSize: 9.sp
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Cart()));
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset: Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(100),

                        ),
                        child: const Icon(Icons.add_shopping_cart_outlined, color: appColors.mainColor,),
                      ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 30,
                      onPressed: () {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const ContactScreen()));
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  <Widget>[
                          Icon(
                            Icons.insert_comment_outlined,
                            color: appColors.white,
                            size: 18.sp,
                          ),
                          Text(
                            'menu_catering'.tr,
                            style: TextStyle(
                              color: appColors.white,
                              fontSize: 9.sp
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 30,
                      onPressed: () {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const MyAccount()));
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  <Widget>[
                          Icon(
                            Icons.account_circle_rounded,
                            color: appColors.white,
                            size: 18.sp,
                          ),
                          Text(
                            'menu_profile'.tr,
                            style: TextStyle(
                              color: appColors.white,
                                fontSize: 9.sp
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),

      ),
    );
  }


  Widget reviewCoustomer(String? star, String? note,  ){
    return Container(
      margin: EdgeInsets.only(right: 10, bottom: 30),
      padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
      width: MediaQuery.of(context).size.width,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     // ClipOval(
              //     //   child: Image.asset("assets/images/user.png", height: 30, width: 30,),
              //     // ),
              //     MediunText(text: "$name", size: 10.sp,),
              //   ],
              // ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: appColors.mainColor,
                  ),
                  MediunText(text: "$star", size: 10.sp,),


                ],
              ),
              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,

                child: Text("$note", overflow: TextOverflow.clip, style: TextStyle(fontSize: 9.sp),)),
              SizedBox(height: 7,),

            ],
          )
        ],
      ),
    );
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
        setState(() {
          _isFav = true;
          print(_isFav);
        });

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
    var response = await http.post(Uri.parse("${ApiService.BaseUrl}/auth/add-to-fav/delete/${id.toString()}"),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );

    if(response.statusCode == 200){
      var data = jsonDecode(response.body.toString());
      if(data["status_code"] == 200){
        setState(() {
          _isFav = false;
          print(_isFav);
        });
        ShowToast("Remove from favorite list").successToast();
        EasyLoading.dismiss();
      }
    }
    EasyLoading.dismiss();
  }

}

