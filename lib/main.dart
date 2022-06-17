import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:moonskynl_food_delivery/languages.dart';
import 'package:moonskynl_food_delivery/view/splash-screen/splash-screen.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            translations: Languages(),
            locale: const Locale("nl", "BQ"),
            //fallbackLocale: Locale("en", "US"),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
            builder: EasyLoading.init(),
          );
        }
    );

  }
}


// var catId = 10;
//
// @override
// void initState() {
//   super.initState();
//   ///whatever you want to run on page build
//   _getFoodByCategory();
//   _getCategory();
// }
// var FoodByCategory;
// Future _getFoodByCategory() async{
//   var response = await CallApi().getData("${ApiService.BaseUrl}/auth/product/show/${catId}");
//   if(response.statusCode == 200){
//     var data = jsonDecode(response.body.toString());
//     if(data["status_code"] == 200){
//
//       FoodByCategory =  data['data']['getitem'];
//       print(FoodByCategory.length);
//       return FoodByCategory;
//     }else{
//       print(FoodByCategory);
//       return FoodByCategory;
//
//     }
//   }else{
//     ShowToast("Server Error ${response.statusCode}");
//   }
//
// }
// var categoryList;
// Future<void> _getCategory() async{
//   var response = await CallApi().getData(ApiService.categoryUrl);
//   if(response.statusCode == 200){
//     var data = jsonDecode(response.body.toString());
//     if(data["status_code"] == 200){
//       categoryList = jsonDecode(response.body)['data'];
//       return categoryList;
//     }else{
//       return categoryList;
//     }
//   }else{
//     ShowToast("Searver Error ${response.statusCode}");
//   }
//
// }
