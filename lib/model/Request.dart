import 'dart:convert';

List<Request> requestFromJson(String? str) =>
    List<Request>.from(json.decode(str!).map((x) => Request.fromJson(x)));

String? requestToJson(List<Request> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Request {
  String? id;
  String? requestType;
  String? requestTypeText;
  String? requestSubType;
  String? startDate;
  String? endDate;
  String? time;
  String? description;
  String? adminDesc;
  String? status;
  String? subType;
  String? date;

  Request(
      {this.id,
      this.requestType,
      this.requestTypeText,
      this.requestSubType,
      this.startDate,
      this.endDate,
      this.time,
      this.description,
      this.adminDesc,
      this.status,
      this.subType,
      this.date});

  Request.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestType = json['requestType'];
    requestTypeText = json['requestTypeText'];
    requestSubType = json['requestSubType'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    time = json['time'];
    description = json['description'];
    adminDesc = json['admin_desc'];
    status = json['status'];
    subType = json['subType'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requestType'] = this.requestType;
    data['requestTypeText'] = this.requestTypeText;
    data['requestSubType'] = this.requestSubType;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['time'] = this.time;
    data['description'] = this.description;
    data['admin_desc'] = this.adminDesc;
    data['status'] = this.status;
    data['subType'] = this.subType;
    data['date'] = this.date;
    return data;
  }
}
