// To parse this JSON data, do
//
//     final packageModel = packageModelFromJson(jsonString);

import 'dart:convert';

PackageModel packageModelFromJson(String str) => PackageModel.fromJson(json.decode(str));

String packageModelToJson(PackageModel data) => json.encode(data.toJson());

class PackageModel {
  String? userId;
  String? id;
  String? packageName;
  String? packagePrice;
  String? packageDescription;
  String? packageDuration;

  PackageModel({
    this.userId,
    this.id,
    this.packageName,
    this.packagePrice,
    this.packageDescription,
    this.packageDuration,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
    userId: json["userId"],
    id: json["id"],
    packageName: json["packageName"],
    packagePrice: json["packagePrice"],
    packageDescription: json["packageDescription"],
    packageDuration: json["packageDuration"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "packageName": packageName,
    "packagePrice": packagePrice,
    "packageDescription": packageDescription,
    "packageDuration": packageDuration,
  };
}