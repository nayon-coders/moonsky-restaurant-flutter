import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'medium-text.dart';
class NotDataFound extends StatelessWidget {
  final String text;
  const NotDataFound({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset("assets/images/nodata.png", fit: BoxFit.cover, width: 100, height: 100,),
          const SizedBox(height: 5,),
          MediunText(text: text),
        ],
      ),
    );
  }
}
