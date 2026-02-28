// To parse this JSON data, do
//
//     final memberModel = memberModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

MemberModel memberModelFromJson(String str) =>
    MemberModel.fromJson(json.decode(str));

String memberModelToJson(MemberModel data) => json.encode(data.toJson());

class MemberModel {
  String? userId;
  String? id;
  String? memberName;
  String? memberContact;
  String? memberAddress;
  String? packageName;
  String? memberNic;
  num? discount;
  String? blockStatus;
  Timestamp? startDate;
  Timestamp? endDate;
  String? packagePrice;
  String? packageDuration;
  String? image;

  MemberModel({
    this.userId,
    this.id,
    this.memberName,
    this.memberContact,
    this.memberAddress,
    this.packageName,
    this.memberNic,
    this.discount,
    this.blockStatus,
    this.startDate,
    this.endDate,
    this.packagePrice,
    this.packageDuration,
    this.image,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
        userId: json["userId"],
        id: json["id"],
        memberName: json["memberName"],
        memberContact: json["memberContact"],
        memberAddress: json["memberAddress"],
        packageName: json["packageName"],
        memberNic: json["memberNic"],
        discount: json["discount"],
        blockStatus: json["blockStatus"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        packagePrice: json["packagePrice"],
        packageDuration: json["packageDuration"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "memberName": memberName,
        "memberContact": memberContact,
        "memberAddress": memberAddress,
        "packageName": packageName,
        "memberNic": memberNic,
        "discount": discount,
        "blockStatus": blockStatus,
        "startDate": startDate,
        "endDate": endDate,
        "packagePrice": packagePrice,
        "packageDuration": packageDuration,
        "image": image,
      };
}
