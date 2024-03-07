import 'dart:convert';

TimeInsertModel timeInsertModelFromJson(String str) =>
    TimeInsertModel.fromJson(json.decode(str));

String timeInsertModelToJson(TimeInsertModel data) =>
    json.encode(data.toJson());

class TimeInsertModel {
  String success;
  String message;

  TimeInsertModel({
    required this.success,
    required this.message,
  });

  factory TimeInsertModel.fromJson(Map<String, dynamic> json) =>
      TimeInsertModel(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
