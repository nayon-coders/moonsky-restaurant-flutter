import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moonskynl_food_delivery/utility/collor.dart';
import 'package:sizer/sizer.dart';

class BigText extends StatelessWidget {
  String text;
  double? size;
  Color? color;
  BigText({required this.text, this.size = 16, this.color = appColors.black});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size?.sp,
          color: color
      ),
    );
  }
}