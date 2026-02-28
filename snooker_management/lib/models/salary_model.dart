// To parse this JSON data, do
//
//     final salaryModel = salaryModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

SalaryModel salaryModelFromJson(String str) => SalaryModel.fromJson(json.decode(str));

String salaryModelToJson(SalaryModel data) => json.encode(data.toJson());

class SalaryModel {
  String? userId;
  String? id;
  String? employeeName;
  double? employeeSalary;
  String? shift;
  Timestamp? date;

  SalaryModel({
    this.userId,
    this.id,
    this.employeeName,
    this.employeeSalary,
    this.shift,
    this.date,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) => SalaryModel(
    userId: json["userId"],
    id: json["id"],
    employeeName: json["employeeName"],
    employeeSalary: json["employeeSalary"]?.toDouble(),
    shift: json["shift"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "employeeName": employeeName,
    "employeeSalary": employeeSalary,
    "shift": shift,
    "date": date,
  };
}
