import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:moonskynl_food_delivery/service/apis.dart';
import 'package:moonskynl_food_delivery/service/call-api.dart';
import 'package:moonskynl_food_delivery/show-toast.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../widget/big-text.dart';
import 'package:http/http.dart' as http;

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _number = TextEditingController();
  final _numberOfOrder = TextEditingController();
  final _des = TextEditingController();
  final _dateController = TextEditingController();
  String? _date;
  TextEditingController dateinput = TextEditingController();
  //text editing controller for text field

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
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
            icon: const Icon(Icons.arrow_back_ios_rounded, color: appColors.mainColor,)),
        title: BigText(text: "Catering", size: 11.sp,),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Container(
          decoration: BoxDecoration(
            color: appColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView(
            children: [
              Form(
              key: _formKey,
              child: Column(
                children: [
                  //name field
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      hintText: "name".tr,
                      labelText: "name".tr,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: appColors.gray),
                      ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "input_error".tr;
                      }else{
                        return null;
                      }

                    },
                  ),
                  const SizedBox(height: 15,),

                  //name field
                  TextFormField(
                    controller: _number,
                    decoration: InputDecoration(
                      hintText: "number".tr,
                      labelText: "number".tr,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: appColors.gray),
                      ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "input_error".tr;
                      }else{
                        return null;
                      }

                    },
                  ),
                  const SizedBox(height: 15,),

                  //name field
                  TextFormField(
                    controller: _numberOfOrder,
                    decoration: InputDecoration(
                      hintText: "number_of_order".tr,
                      labelText: "number_of_order".tr,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: appColors.gray),
                      ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "input_error".tr;
                      }else{
                        return null;
                      }

                    },
                  ),
                  const SizedBox(height: 15,),

                  //date field
                  TextField(
                    controller: _dateController,
                    //editing controller of this TextField
                    decoration: InputDecoration(
                        labelText: "Enter Date",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: appColors.gray),
                      ),
                    ),
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101)
                      );

                      if(pickedDate != null ){
                        print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                        setState(() {
                          _date = formattedDate;
                          _dateController..text = formattedDate;
                          print(_date);//set output date to TextField value.
                        });
                      }else{
                        print("Date is not selected");
                      }
                    },
                  ),

                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: _des,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "catering_des".tr,
                      labelText:  "catering_des".tr,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: appColors.gray),
                      ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "input_error".tr;
                      }else{
                        return null;
                      }

                    },
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        setState((){
                          _creatCataring();
                        });
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                          backgroundColor: MaterialStateProperty.all(appColors.mainColor)
                      ),
                      child:Text("Submit",
                        style: TextStyle(
                          color: appColors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                    ),
                  ),
                ],
              ),
            ),
          ]
          ),
        ),
      ),


    );
  }


  //create caterin
  /// TODO: Create catering
  _creatCataring() async{

    if(_formKey.currentState!.validate()){
      EasyLoading.show(
        status: 'Sending...',
        maskType: EasyLoadingMaskType.black,
      );
      print(_name.text);
      print(_numberOfOrder.text);
      print(_date);
      print(_des.text);
      print(_number.text);
      var body =  {
        "name" : _name.text,
        "mobile" : _number.text,
        "amount" : _numberOfOrder.text,
        "date" : _date,
        "description" : _des.text,
      };

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var token = localStorage.getString("token");
      var response = await http.post(Uri.parse(ApiService.createCatering),
        body: body,
          headers: {
            "Authorization" : "Bearer $token"
          }
      );
      if(response.statusCode == 200){
        var responseData = jsonDecode(response.body.toString());
        print(responseData);

        if(responseData["status_code"] == 200){
          ShowToast(responseData["message"])..successToast();
          print(responseData["message"]);
          EasyLoading.dismiss();
        }else{
          ShowToast(responseData["message"])..successToast();;
          EasyLoading.dismiss();
        }
      }
      EasyLoading.dismiss();
    }


  }

}
