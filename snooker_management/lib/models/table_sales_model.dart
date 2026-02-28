// To parse this JSON data, do
//
//     final tableSalesModel = tableSalesModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

TableSalesModel tableSalesModelFromJson(String str) => TableSalesModel.fromJson(json.decode(str));

String tableSalesModelToJson(TableSalesModel data) => json.encode(data.toJson());

class TableSalesModel {
  String? userId;
  String? id;
  String? looserName;
  int? loosGames;
  String? totalAmount;
  int? payedAmount;
  String? status;
  String? paymentMethod;
  Timestamp? date;

  TableSalesModel({
    this.userId,
    this.id,
    this.looserName,
    this.loosGames,
    this.totalAmount,
    this.payedAmount,
    this.status,
    this.paymentMethod,
    this.date,
  });

  factory TableSalesModel.fromJson(Map<String, dynamic> json) => TableSalesModel(
    userId: json["userId"],
    id: json["id"],
    looserName: json["looserName"],
    loosGames: json["loosGames"],
    totalAmount: json["totalAmount"],
    payedAmount: json["payedAmount"],
    status: json["status"],
    paymentMethod: json["paymentMethod"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "looserName": looserName,
    "loosGames": loosGames,
    "totalAmount": totalAmount,
    "payedAmount": payedAmount,
    "status": status,
    "paymentMethod": paymentMethod,
    "date": date,
  };
}
