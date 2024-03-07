// To parse this JSON data, do
//
//     final examTakeModel = examTakeModelFromJson(jsonString);

import 'dart:convert';

ExamTakeModel examTakeModelFromJson(String str) =>
    ExamTakeModel.fromJson(json.decode(str));

String examTakeModelToJson(ExamTakeModel data) => json.encode(data.toJson());

class ExamTakeModel {
  String success;
  String examId;
  String examName;
  String timeQuestion;
  List<ExamQuestionList> examQuestionList;

  ExamTakeModel({
    required this.success,
    required this.examId,
    required this.examName,
    required this.timeQuestion,
    required this.examQuestionList,
  });

  factory ExamTakeModel.fromJson(Map<String, dynamic> json) => ExamTakeModel(
        success: json["success"] ?? 'NULL',
        examId: json["examId"] ?? 'NULL',
        examName: json["examName"] ?? 'NULL',
        timeQuestion: json["timeQuestion"] ?? 'NULL',
        examQuestionList: (json["examQuestionList"] as List<dynamic>?)
                ?.map((x) => ExamQuestionList.fromJson(x))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "examId": examId,
        "examName": examName,
        "timeQuestion": timeQuestion,
        "examQuestionList":
            List<dynamic>.from(examQuestionList.map((x) => x.toJson())),
      };
}

class ExamQuestionList {
  String questionId;
  String question;
  String correctAnswer;
  bool answered;
  List<AnswerList> answerList;

  ExamQuestionList({
    required this.questionId,
    required this.question,
    required this.correctAnswer,
    required this.answered,
    required this.answerList,
  });

  factory ExamQuestionList.fromJson(Map<String, dynamic> json) =>
      ExamQuestionList(
        questionId: json["questionId"],
        question: json["question"],
        correctAnswer: json["correctAnswer"],
        answered: json["answered"],
        answerList: List<AnswerList>.from(
            json["answerList"].map((x) => AnswerList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "question": question,
        "correctAnswer": correctAnswer,
        "answered": answered,
        "answerList": List<dynamic>.from(answerList.map((x) => x.toJson())),
      };
}

class AnswerList {
  String id;
  String answer;

  AnswerList({
    required this.id,
    required this.answer,
  });

  factory AnswerList.fromJson(Map<String, dynamic> json) => AnswerList(
        id: json["id"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "answer": answer,
      };
}

class ExamAnswerModel {
  ExamAnswerModel({
    this.questionId,
    this.chosenAnswer,
  });

  String? questionId;
  String? chosenAnswer;

  factory ExamAnswerModel.fromJson(Map<String, dynamic> json) =>
      ExamAnswerModel(
        questionId: json["questionId"],
        chosenAnswer: json["chosenAnswer"],
      );

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "chosenAnswer": chosenAnswer,
      };
}
