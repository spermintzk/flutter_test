import 'dart:convert';

Success successFromJson(String str) => Success.fromJson(json.decode(str));

String successToJson(Success data) => json.encode(data.toJson());

class Success {
  String success;
  String message;

  Success({
    required this.success,
    required this.message,
  });

  factory Success.fromJson(Map<String, dynamic> json) => Success(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
