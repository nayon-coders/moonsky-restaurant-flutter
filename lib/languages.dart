import 'package:get/get.dart';
import 'package:moonskynl_food_delivery/langauge/english.dart';
import 'package:moonskynl_food_delivery/langauge/netherland.dart';

class Languages extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
      "en_US" : eng,
      "nl_BQ" : netherland,
  };

}