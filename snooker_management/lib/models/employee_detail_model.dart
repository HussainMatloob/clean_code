// To parse this JSON data, do
//
//     final employeeDetailModel = employeeDetailModelFromJson(jsonString);

import 'dart:convert';

EmployeeModel employeeDetailModelFromJson(String str) => EmployeeModel.fromJson(json.decode(str));

String employeeDetailModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  String userId;
  String id;
  String employeeName;
  String employeeNic;
  String employeeType;
  String employeeContact;
  String employeeAddress;
  String image;
  String shift;

  EmployeeModel({
    required this.userId,
    required this.id,
    required this.employeeName,
    required this.employeeNic,
    required this.employeeType,
    required this.employeeContact,
    required this.employeeAddress,
    required this.image,
    required this.shift,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    userId: json["userId"],
    id: json["id"],
    employeeName: json["employeeName"],
    employeeNic: json["employeeNIC"],
    employeeType: json["employeeType"],
    employeeContact: json["employeeContact"],
    employeeAddress: json["employeeAddress"],
    image: json["image"],
    shift:json["shift"]
  );

  Map<String, dynamic> toJson() => {
    "userId":userId,
    "id": id,
    "employeeName": employeeName,
    "employeeNIC": employeeNic,
    "employeeType": employeeType,
    "employeeContact": employeeContact,
    "employeeAddress": employeeAddress,
    "image": image,
    "shift":shift
  };
}
