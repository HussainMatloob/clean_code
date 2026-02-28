import 'dart:convert';

TableDetailModel tableDetailModelFromJson(String str) =>
    TableDetailModel.fromJson(json.decode(str));

String tableDetailModelToJson(TableDetailModel data) =>
    json.encode(data.toJson());

List<TableDetailModel> tableDetailModelListFromJson(String str) {
  final jsonData = json.decode(str) as List<dynamic>;
  return jsonData
      .map((item) => TableDetailModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

String tableDetailModelListToJson(List<TableDetailModel> data) {
  final jsonData = data.map((item) => item.toJson()).toList();
  return json.encode(jsonData);
}

class TableDetailModel {
  String userId;
  String id;
  String tableNumber;
  String tableName;
  String tableType;
  String tableDescription;
  String tablePrice;
  String tableStatus;

  TableDetailModel(
      {
        required this.userId,
        required this.id,
      required this.tableNumber,
      required this.tableName,
      required this.tableType,
      required this.tableDescription,
      required this.tablePrice,
      this.tableStatus = 'free'});

  factory TableDetailModel.fromJson(Map<String, dynamic> json) =>
      TableDetailModel(
        userId:json["userId"],
        id: json["id"],
        tableNumber: json["tableNumber"],
        tableName: json["tableName"],
        tableType: json["tableType"],
        tableDescription: json["tableDescription"],
        tablePrice: json["tablePrice"],
        tableStatus: json["tableStatus"],
      );

  Map<String, dynamic> toJson() => {
        "userId":userId,
        "id": id,
        "tableNumber": tableNumber,
        "tableName": tableName,
        "tableType": tableType,
        "tableDescription": tableDescription,
        "tablePrice": tablePrice,
        "tableStatus": tableStatus,
      };
}
