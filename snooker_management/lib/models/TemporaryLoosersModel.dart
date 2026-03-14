// To parse this JSON data, do
//
//     final temporaryLosersModel = temporaryLosersModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

TemporaryLosersModel temporaryLosersModelFromJson(String str) =>
    TemporaryLosersModel.fromJson(json.decode(str));

String temporaryLosersModelToJson(TemporaryLosersModel data) =>
    json.encode(data.toJson());

class TemporaryLosersModel {
  String? userId;
  String? id;
  String? looserName;
  String? gameType;
  String? tableNumber;
  String? tablePrice;
  double? payAmount;
  int? loosGames;
  String? startTime;
  String? endTime;
  String? totalTime;
  Timestamp? date;

  TemporaryLosersModel({
    this.userId,
    this.id,
    this.looserName,
    this.gameType,
    this.tableNumber,
    this.tablePrice,
    this.payAmount,
    this.loosGames,
    this.startTime,
    this.endTime,
    this.totalTime,
    this.date,
  });

  factory TemporaryLosersModel.fromJson(Map<String, dynamic> json) =>
      TemporaryLosersModel(
        userId: json["userId"],
        id: json["id"],
        looserName: json["looserName"],
        gameType: json["gameType"],
        tableNumber: json["tableNumber"],
        tablePrice: json["tablePrice"],
        payAmount: json["payAmount"],
        loosGames: json["loosGames"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        totalTime: json["totalTime"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "looserName": looserName,
        "gameType": gameType,
        "tableNumber": tableNumber,
        "tablePrice": tablePrice,
        "payAmount": payAmount,
        "loosGames": loosGames,
        "startTime": startTime,
        "endTime": endTime,
        "totalTime": totalTime,
        "date": date ?? FieldValue.serverTimestamp(),
      };
}
