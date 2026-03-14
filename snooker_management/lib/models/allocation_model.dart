import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

AllocationModel allocationModelFromJson(String str) =>
    AllocationModel.fromJson(json.decode(str));

String allocationModelToJson(AllocationModel data) =>
    json.encode(data.toJson());

class AllocationModel {
  String? userId;
  String? id;
  List<String>? playersName;
  String? gameType;
  String? tableNumber;
  String? totalAmount;
  String? startTime;
  String? endTime;
  String? totalTime;
  Timestamp? date;

  AllocationModel({
    this.userId,
    this.id,
    this.playersName,
    this.gameType,
    this.tableNumber,
    this.totalAmount,
    this.startTime,
    this.endTime,
    this.totalTime,
    this.date,
  });

  factory AllocationModel.fromJson(Map<String, dynamic> json) {
    return AllocationModel(
      userId: json["userId"],
      id: json["id"],
      playersName: json["playersName"] == null
          ? []
          : List<String>.from(json["playersName"]!.map((x) => x)),
      gameType: json["gameType"],
      tableNumber: json["tableNumber"],
      totalAmount: json["totalAmount"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      totalTime: json["totalTime"],
      date: json["date"],
    );
  }
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "playersName": playersName == null
            ? []
            : List<dynamic>.from(playersName!.map((x) => x)),
        "gameType": gameType,
        "tableNumber": tableNumber,
        "totalAmount": totalAmount,
        "startTime": startTime,
        "endTime": endTime,
        "totalTime": totalTime,
        "date": date ?? FieldValue.serverTimestamp(),
      };
}
