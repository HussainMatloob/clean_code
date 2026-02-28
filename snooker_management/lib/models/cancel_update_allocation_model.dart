// To parse this JSON data, do
//
//     final cancelAndUpdateAllocationModel = cancelAndUpdateAllocationModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

CancelAndUpdateAllocationModel cancelAndUpdateAllocationModelFromJson(String str) => CancelAndUpdateAllocationModel.fromJson(json.decode(str));

String cancelAndUpdateAllocationModelToJson(CancelAndUpdateAllocationModel data) => json.encode(data.toJson());

class CancelAndUpdateAllocationModel {
  String? userId;
  String? id;
  List<String>? playersName;
  bool? isAllocated;
  Timestamp? startTime;
  String? tableNumber;
  double? tablePrice;
  String? gameType;

  CancelAndUpdateAllocationModel({
    this.userId,
    this.id,
    this.playersName,
    this.isAllocated,
    this.startTime,
    this.tableNumber,
    this.tablePrice,
    this.gameType
  });

  factory CancelAndUpdateAllocationModel.fromJson(Map<String, dynamic> json) => CancelAndUpdateAllocationModel(
    userId: json["userId"],
    id: json["id"],
    playersName: json["playersName"] == null ? [] : List<String>.from(json["playersName"]!.map((x) => x)),
    isAllocated: json["isAllocated"],
    startTime: json["startTime"],
    tableNumber: json["tableNumber"],
    tablePrice: json["tablePrice"]?.toDouble(),
    gameType: json["gameType"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "playersName": playersName == null ? [] : List<dynamic>.from(playersName!.map((x) => x)),
    "isAllocated": isAllocated,
    "startTime": startTime,
    "tableNumber": tableNumber,
    "tablePrice": tablePrice,
    "gameType":gameType,
  };
}

