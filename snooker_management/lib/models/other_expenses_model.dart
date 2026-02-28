// To parse this JSON data, do
//
//     final otherExpensesModel = otherExpensesModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

OtherExpensesModel otherExpensesModelFromJson(String str) => OtherExpensesModel.fromJson(json.decode(str));

String otherExpensesModelToJson(OtherExpensesModel data) => json.encode(data.toJson());

class OtherExpensesModel {
  String? userId;
  String? id;
  String? name;
  String? expenseName;
  double? otherExpenseAmount;
  Timestamp? expenseDate;

  OtherExpensesModel({
    this.userId,
    this.id,
    this.name,
    this.expenseName,
    this.otherExpenseAmount,
    this.expenseDate,
  });

  factory OtherExpensesModel.fromJson(Map<String, dynamic> json) => OtherExpensesModel(
    userId: json["userId"],
    id: json["id"],
    name: json["name"],
    expenseName: json["expenseName"],
    otherExpenseAmount: json["otherExpenseAmount"]?.toDouble(),
    expenseDate: json["expenseDate"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "name": name,
    "expenseName": expenseName,
    "otherExpenseAmount": otherExpenseAmount,
    "expenseDate": expenseDate,
  };
}
