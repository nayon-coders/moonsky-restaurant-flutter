import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moonskynl_food_delivery/service/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CallApi{


  postData(data, url)async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString("token");
    return await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
  }

  getData(url)async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString("token");
    return await http.get(
      Uri.parse(url),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
  }


}