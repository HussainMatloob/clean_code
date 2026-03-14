// To parse this JSON data, do
//
//     final attendanceModel = attendanceModelFromJson(jsonString);
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

AttendanceModel attendanceModelFromJson(String str) =>
    AttendanceModel.fromJson(json.decode(str));
String attendanceModelToJson(AttendanceModel data) =>
    json.encode(data.toJson());

class AttendanceModel {
  String? userId;
  String? id;
  String? employeeName;
  Timestamp? date;
  String? shift;
  String? status;

  AttendanceModel({
    this.userId,
    this.id,
    this.employeeName,
    this.date,
    this.shift,
    this.status,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        userId: json["userId"],
        id: json["id"],
        employeeName: json["employeeName"],
        date: json["date"],
        shift: json["shift"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "employeeName": employeeName,
        "date": date ?? FieldValue.serverTimestamp(),
        "shift": shift,
        "status": status,
      };
}
