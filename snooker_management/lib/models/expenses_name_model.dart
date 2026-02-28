// To parse this JSON data, do
//
//     final expensesNameModel = expensesNameModelFromJson(jsonString);

import 'dart:convert';

ExpensesNameModel expensesNameModelFromJson(String str) => ExpensesNameModel.fromJson(json.decode(str));

String expensesNameModelToJson(ExpensesNameModel data) => json.encode(data.toJson());

class ExpensesNameModel {
  String? userId;
  String? id;
  String? expenseName;

  ExpensesNameModel({
    this.userId,
    this.id,
    this.expenseName,
  });

  factory ExpensesNameModel.fromJson(Map<String, dynamic> json) => ExpensesNameModel(
    userId: json["userId"],
    id: json["id"],
    expenseName: json["expenseName"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "expenseName": expenseName,
  };
}
