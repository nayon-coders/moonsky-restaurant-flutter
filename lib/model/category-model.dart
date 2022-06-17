// To parse this JSON data, do
//
//     final categoryListModel = categoryListModelFromJson(jsonString);

import 'dart:convert';

CategoryListModel categoryListModelFromJson(String str) => CategoryListModel.fromJson(json.decode(str));

String categoryListModelToJson(CategoryListModel data) => json.encode(data.toJson());

class CategoryListModel {
  CategoryListModel({
    required this.statusCode,
    required this.data,
    required this.message,
  });

  int statusCode;
  List<Data> data;
  String message;

  factory CategoryListModel.fromJson(Map<String, dynamic> json) => CategoryListModel(
    statusCode: json["status_code"],
    data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Data {
  Data({
    required this.id,
    required this.categoryName,
    required this.image,
    required this.isAvailable,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String categoryName;
  String image;
  int isAvailable;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    categoryName: json["category_name"],
    image: json["image"],
    isAvailable: json["is_available"],
    isDeleted: json["is_deleted"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_name": categoryName,
    "image": image,
    "is_available": isAvailable,
    "is_deleted": isDeleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
