import 'dart:convert';

CalculateTime calculateTimeFromJson(String str) =>
    CalculateTime.fromJson(json.decode(str));

String calculateTimeToJson(CalculateTime data) => json.encode(data.toJson());

class CalculateTime {
  String success;
  String message;
  dynamic totalTime;

  CalculateTime({
    required this.success,
    required this.message,
    required this.totalTime,
  });

  factory CalculateTime.fromJson(Map<String, dynamic> json) {
    if (json["total_time"] is int) {
      return CalculateTime(
        success: json["success"],
        message: json["message"],
        totalTime: '0',
      );
    }

    return CalculateTime(
      success: json["success"],
      message: json["message"],
      totalTime: json["total_time"],
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "total_time": totalTime,
      };
}
