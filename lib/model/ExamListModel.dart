// To parse this JSON data, do
//
//     final examListModel = examListModelFromJson(jsonString);

import 'dart:convert';

ExamListModel examListModelFromJson(String str) =>
    ExamListModel.fromJson(json.decode(str));

String examListModelToJson(ExamListModel data) => json.encode(data.toJson());

class ExamListModel {
  String success;
  List<ExamList> examList;

  ExamListModel({
    required this.success,
    required this.examList,
  });

  factory ExamListModel.fromJson(Map<String, dynamic> json) => ExamListModel(
        success: json["success"],
        examList: List<ExamList>.from(
            json["examList"].map((x) => ExamList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "examList": List<dynamic>.from(examList.map((x) => x.toJson())),
      };
}

class ExamList {
  String examId;
  String examName;
  String picture;
  int examType;
  String? percent;
  String? score;
  String examCnt;
  DateTime startDate;
  DateTime startTime;
  DateTime endTime;

  ExamList({
    required this.examId,
    required this.examName,
    required this.picture,
    required this.examType,
    required this.percent,
    required this.score,
    required this.examCnt,
    required this.startDate,
    required this.startTime,
    required this.endTime,
  });

  factory ExamList.fromJson(Map<String, dynamic> json) => ExamList(
        examId: json["exam_id"],
        examName: json["exam_name"],
        picture: json["picture"],
        examType: json["exam_type"],
        percent: json["percent"],
        score: json["score"],
        examCnt: json["exam_cnt"],
        startDate: DateTime.parse(json["start_date"]),
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
      );

  Map<String, dynamic> toJson() => {
        "exam_id": examId,
        "exam_name": examName,
        "picture": picture,
        "exam_type": examType,
        "percent": percent,
        "score": score,
        "exam_cnt": examCnt,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
      };
}
