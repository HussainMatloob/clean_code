// To parse this JSON data, do
//
//     final memberBillingModel = memberBillingModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

MemberBillingModel memberBillingModelFromJson(String str) => MemberBillingModel.fromJson(json.decode(str));

String memberBillingModelToJson(MemberBillingModel data) => json.encode(data.toJson());

class MemberBillingModel {
  String? userId;
  String? id;
  String? memberId;
  String? memberName;
  String? packageName;
  double? packagePrice;
  String? packageDuration;
  Timestamp? billDate;
  Timestamp? startDate;
  Timestamp? endDate;
  String? paymentMethod;

  MemberBillingModel({
    this.userId,
    this.id,
    this.memberId,
    this.memberName,
    this.packageName,
    this.packagePrice,
    this.packageDuration,
    this.billDate,
    this.startDate,
    this.endDate,
    this.paymentMethod,
  });

  factory MemberBillingModel.fromJson(Map<String, dynamic> json) => MemberBillingModel(
    userId: json["userId"],
    id: json["id"],
    memberId: json["memberId"],
    memberName: json["memberName"],
    packageName: json["packageName"],
    packagePrice: json["packagePrice"],
    packageDuration: json["packageDuration"],
    billDate: json["billDate"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    paymentMethod: json["paymentMethod"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "memberId": memberId,
    "memberName": memberName,
    "packageName": packageName,
    "packagePrice": packagePrice,
    "packageDuration": packageDuration,
    "billDate": billDate,
    "startDate": startDate,
    "endDate": endDate,
    "paymentMethod": paymentMethod,
  };
}
