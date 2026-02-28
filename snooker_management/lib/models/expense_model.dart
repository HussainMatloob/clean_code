// To parse this JSON data, do
//
//     final expensesModel = expensesModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ExpensesModel expensesModelFromJson(String str) =>
    ExpensesModel.fromJson(json.decode(str));

String expensesModelToJson(ExpensesModel data) => json.encode(data.toJson());

class ExpensesModel {
  String? userId;
  String? id;
  String? expenseName;
  String? expenseDescription;
  num? expenseAmount;
  Timestamp? expenseDate;

  ExpensesModel({
    this.userId,
    this.id,
    this.expenseName,
    this.expenseDescription,
    this.expenseAmount,
    this.expenseDate,
  });

  factory ExpensesModel.fromJson(Map<String, dynamic> json) => ExpensesModel(
        userId: json["userId"],
        id: json["id"],
        expenseName: json["expenseName"],
        expenseDescription: json["expenseDescription"],
        expenseAmount: json["expenseAmount"],
        expenseDate: json["expenseDate"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "expenseName": expenseName,
        "expenseDescription": expenseDescription,
        "expenseAmount": expenseAmount,
        "expenseDate": expenseDate,
      };
}
