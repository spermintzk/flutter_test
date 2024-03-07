// To parse this JSON data, do
//
//     final requestDetails = requestDetailsFromJson(jsonString);

import 'dart:convert';

RequestDetails requestDetailsFromJson(String str) =>
    RequestDetails.fromJson(json.decode(str));

String requestDetailsToJson(RequestDetails data) => json.encode(data.toJson());

class RequestDetails {
  String? id;
  String? requestType;
  String? requestSubType;
  String? startDate;
  String? endDate;
  String? time;
  String? description;
  String? adminDescription;
  String? status;
  String? date;
  String? approvedBy;
  String? approvedDate;
  String? longitude;
  String? latitude;
  String? picture;

  RequestDetails(
      {this.id,
      this.requestType,
      this.requestSubType,
      this.startDate,
      this.endDate,
      this.time,
      this.description,
      this.adminDescription,
      this.status,
      this.date,
      this.approvedBy,
      this.approvedDate,
      this.longitude,
      this.latitude,
      this.picture});

  RequestDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestType = json['requestType'];
    requestSubType = json['requestSubType'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    time = json['time'];
    description = json['description'];
    adminDescription = json['admin_description'];
    status = json['status'];
    date = json['date'];
    approvedBy = json['approvedBy'];
    approvedDate = json['approvedDate'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requestType'] = this.requestType;
    data['requestSubType'] = this.requestSubType;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['time'] = this.time;
    data['description'] = this.description;
    data['admin_description'] = this.adminDescription;
    data['status'] = this.status;
    data['date'] = this.date;
    data['approvedBy'] = this.approvedBy;
    data['approvedDate'] = this.approvedDate;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['picture'] = this.picture;
    return data;
  }
}
