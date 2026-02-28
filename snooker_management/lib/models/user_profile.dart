// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

UsersModel usersModelFromJson(String str) =>
    UsersModel.fromJson(json.decode(str));

String usersModelToJson(UsersModel data) => json.encode(data.toJson());

class UsersModel {
  String? id;
  String? uId;
  String? role;
  String? userName;
  String? email;
  String? password;
  String? snookerLogo;
  String? snookerName;
  String? createdAt;
  String? userDeviceToken;
  List<String>? permissionsList;

  UsersModel({
    this.id,
    this.uId,
    this.role,
    this.userName,
    this.email,
    this.password,
    this.snookerLogo,
    this.snookerName,
    this.createdAt,
    this.userDeviceToken,
    this.permissionsList,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        id: json["id"],
        uId: json["uId"],
        role: json["role"],
        userName: json["userName"],
        email: json["email"],
        password: json["password"],
        snookerLogo: json["snookerLogo"],
        snookerName: json["snookerName"],
        createdAt: json["createdAt"],
        userDeviceToken: json["userDeviceToken"],
        permissionsList:
            List<String>.from(json["permissionsList"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uId": uId,
        "role": role,
        "userName": userName,
        "email": email,
        "password": password,
        "snookerLogo": snookerLogo,
        "snookerName": snookerName,
        "createdAt": createdAt,
        "userDeviceToken": userDeviceToken,
        "permissionsList": permissionsList == null
            ? []
            : List<dynamic>.from(permissionsList!.map((x) => x)),
      };
}
