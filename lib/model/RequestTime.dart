import 'dart:convert';

List<RequestTime> requestTimeFromJson(String str) => List<RequestTime>.from(
    json.decode(str).map((x) => RequestTime.fromJson(x)));

String requestTimeToJson(List<RequestTime> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestTime {
  String hour;

  var startTime;

  var endTime;

  RequestTime({
    required this.hour,
  });

  factory RequestTime.fromJson(Map<String, dynamic> json) => RequestTime(
        hour: json["hour"],
      );

  Map<String, dynamic> toJson() => {
        "hour": hour,
      };
}
