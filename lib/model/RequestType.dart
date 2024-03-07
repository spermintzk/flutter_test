import 'dart:convert';

List<RequestType> requestTypeFromJson(String str) => List<RequestType>.from(
    json.decode(str).map((x) => RequestType.fromJson(x)));

String requestTypeToJson(List<RequestType> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestType {
  String id;
  String type;
  String name;
  String? status;
  List<SubType> subType;

  RequestType({
    required this.id,
    required this.type,
    required this.name,
    required this.status,
    required this.subType,
  });

  factory RequestType.fromJson(Map<String, dynamic> json) => RequestType(
        id: json["id"],
        type: json["type"],
        name: json["name"],
        status: json["status"],
        subType: List<SubType>.from(
            json["sub_type"].map((x) => SubType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "status": status,
        "sub_type": List<dynamic>.from(subType.map((x) => x.toJson())),
      };
}

class SubType {
  String id;
  String subtype;
  String name;

  SubType({
    required this.id,
    required this.subtype,
    required this.name,
  });

  factory SubType.fromJson(Map<String, dynamic> json) => SubType(
        id: json["id"],
        subtype: json["subtype"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subtype": subtype,
        "name": name,
      };
}
