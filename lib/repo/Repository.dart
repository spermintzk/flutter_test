import 'dart:async';

import 'package:get/get_connect/connect.dart';
import 'package:project1/components/ExamPage/ExamList.dart';
import 'package:project1/model/ExamListModel.dart';
import 'package:project1/model/ExamTakeModel.dart';
import 'package:project1/model/GetCategory.dart';
import 'package:project1/model/GetNews.dart';
import 'package:project1/model/Request.dart';
import 'package:project1/model/CalculateTime.dart';
import 'package:project1/model/RequestDetails.dart';
import 'package:project1/model/RequestSend.dart';
import 'package:project1/model/RequestTime.dart';
import 'package:project1/model/RequestType.dart';
import 'package:project1/model/TimeInsertMode.dart';
import 'package:project1/repo/Endpoint.dart';

class Repository extends GetConnect {
  int userId = 874459;
  String userToken = '7dcba961e9b9e40012bce25bda6b4f7e';
  int company_id = 3305;

  Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  Future<List<Request>> getRequest() async {
    String endpoint = EndpointConfig.getEnpoint(ENDPOINT.GET_REQUEST);
    print(endpoint + '?user_id=$userId&token=$userToken');
    var response = await get(endpoint + '?user_id=$userId&token=$userToken');
    print(response.statusText);
    if (response.statusCode == 200) {
      return requestFromJson(response.bodyString);
    } else {
      return requestFromJson(response.bodyString);
    }
  }

  Future<ExamListModel> getExamList() async {
    String endpoint = EndpointConfig.getEnpoint(ENDPOINT.GET_EXAM_LIST);
    print(endpoint + '?user_id=$userId&token=$userToken');
    var response = await get(endpoint + '?user_id=$userId&token=$userToken');
    print(response.statusCode);

    if (response.statusCode == 200) {
      return examListModelFromJson(response.bodyString.toString());
    } else {
      return examListModelFromJson(response.bodyString.toString());
    }
  }

  Future<GetNews> getNews(int categoryId) async {
    String endpoint = EndpointConfig.getEnpoint(ENDPOINT.GET_NEWS);
    print(endpoint + '?category_id=$categoryId');
    var response = await get(endpoint + '?category_id=$categoryId');

    if (response.statusCode == 200) {
      return getNewsFromJson(response.bodyString.toString());
    } else {
      throw Exception('Failed to load news ${response.statusCode}');
    }
  }

  Future<List<GetCategory>> getCategory() async {
    String endpoint = EndpointConfig.getEnpoint(ENDPOINT.GET_CATEGORY);
    print(endpoint + '?company_id=$company_id');
    var response = await get(endpoint + '?company_id=$company_id');

    if (response.statusCode == 200) {
      return getCategoryFromJson(response.bodyString.toString());
    }

    throw Exception('DNS tohiruulahaa martsin bishu bro?');
  }

  Future<RequestDetails> getRequestDetails(String requestId) async {
    String endpoint = EndpointConfig.getEnpoint(ENDPOINT.GET_REQUEST_DETAIL);

    var response = await get(
        endpoint + '?user_id=$userId&token=$userToken&request_id=$requestId');

    if (response.statusCode == 200) {
      return requestDetailsFromJson(response.bodyString.toString());
    } else {
      return requestDetailsFromJson(response.bodyString.toString());
    }
  }

  Future<ExamTakeModel> getExamDetails(String examId) async {
    String endpoint = EndpointConfig.getEnpoint(ENDPOINT.GET_EXAM);

    var response = await get(
        endpoint + '?user_id=$userId&token=$userToken&exam_id=$examId');

    print(endpoint + '?user_id=$userId&token=$userToken&exam_id=$examId');

    if (response.statusCode == 200) {
      return examTakeModelFromJson(response.bodyString.toString());
    } else {
      return examTakeModelFromJson(response.bodyString.toString());
    }
  }

  // //** GET NOTIFICATION   */
  // Future<RequestDeleteModel> deleteRequest(String id) async {
  //   String endpoint = EndpointConfig.getEnpoint(
  //     ENDPOINT.DELETE_REQUEST,
  //   );
  //   Map<String, dynamic> data = {
  //     'user_id': userId,
  //     'token': userToken,
  //     'id': id,
  //   };

  //   var formData = FormData(data);
  //   var response = await post(endpoint, formData);

  //   if (response.statusCode == 200) {
  //     return requestDeleteModelFromJson(response.bodyString);
  //   } else {
  //     return requestDeleteModelFromJson(response.bodyString);
  //   }
  // }

  Future<Success> sendExam(
      String examId, List<ExamAnswerModel> selectedAnswers) async {
    String endpoint = EndpointConfig.getEnpoint(ENDPOINT.INSERT_EXAM);

    Map<String, dynamic> data = {
      'user_id': userId,
      'token': userToken,
      'exam_id': examId,
      'examQuestionList': selectedAnswers
    };

    print(data);

    final Response response = await post(endpoint, data);

    if (response.statusCode == 200) {
      print(response.bodyString);
      return successFromJson(response.bodyString ?? '');
    } else {
      print(response.bodyString);
      return successFromJson(response.bodyString ?? '');
    }
  }

  Future<Success> sendRequest(DateTime? startDate, DateTime? endDate, int type,
      int subType, String time, String description,
      {String? date}) async {
    String endpoint = EndpointConfig.getEnpoint(ENDPOINT.INSERT_REQUEST);

    Map<String, dynamic> data;
    if (type == 6) {
      data = {
        'id': userId,
        'token': userToken,
        'startDate': startDate,
        'endDate': endDate,
        'type': type,
        'subType': subType,
        'time': time,
        'description': description,
      };
    } else if (type == 8) {
      data = {
        'id': userId,
        'token': userToken,
        'type': type,
        'subType': subType,
        'time': time,
        'date': date,
        'description': description,
      };
    } else {
      data = {
        'id': userId,
        'token': userToken,
        'startDate': startDate,
        'endDate': endDate,
        'type': type,
        'subType': subType,
        'time': time,
        'description': description,
      };
    }
    print(data);

    var formData = FormData(data);

    final Response response = await post(endpoint, formData);

    if (response.statusCode == 200) {
      return successFromJson(response.bodyString ?? '');
    } else {
      return Success(
        success: "0",
        message: getNoNetworkText(response.statusCode),
      );
    }
  }

  Future<TimeInsertModel> timeInsert(
      String type, String? latitude, String? longitude) async {
    try {
      Map<String, dynamic> data = {
        'id': userId,
        'token': userToken,
        'type': type,
        'latitude': latitude,
        'longitude': longitude,
      };

      final formData = FormData(data);
      String endpoint = EndpointConfig.getEnpoint(ENDPOINT.TIME_INSERT);

      GetConnect timeInsertController =
          GetConnect(timeout: Duration(seconds: 10));
      final Response response =
          await timeInsertController.post(endpoint, formData);

      if (response.statusCode == 200) {
        print(response.bodyString);
        return timeInsertModelFromJson(response.bodyString.toString());
      } else {
        return TimeInsertModel(
          success: "0",
          message: getNoNetworkText(response.statusCode),
        );
      }
    } catch (e) {
      return TimeInsertModel(
        success: "0",
        message: e.toString(),
      );
    }
  }

  //** GET REQUEST TIME   */
  Future<List<RequestTime>> getRequestTime(String date, int requestType) async {
    String endpoint = EndpointConfig.getEnpoint(ENDPOINT.GET_REQUEST_TIME);
    var response = await get(endpoint +
        '?user_id=$userId&token=$userToken&date=$date&requestType=$requestType');

    if (response.statusCode == 200) {
      return requestTimeFromJson(response.bodyString.toString());
    } else {
      return requestTimeFromJson(response.bodyString.toString());
    }
  }

  // //** GET CALCULATE TIME   */
  Future<CalculateTime> getCalculateTime(String startDate, String endDate,
      String requestType, String requestSubType) async {
    String endpoint = EndpointConfig.getEnpoint(ENDPOINT.GET_CALCULATE_TIME);
    var response = await get(endpoint +
        '?user_id=$userId&token=$userToken&startDate=$startDate&endDate=$endDate&requestType=$requestType&reqSuBType=$requestSubType');

    if (response.statusCode == 200) {
      return calculateTimeFromJson(response.bodyString.toString());
    } else {
      return calculateTimeFromJson(response.bodyString.toString());
    }
  }

  // //** GET REQUEST TYPE   */
  Future<List<RequestType>> getRequestType() async {
    String endpoint = EndpointConfig.getEnpoint(ENDPOINT.GET_REQUEST_TYPE);
    var response = await get(endpoint + '?user_id=$userId&token=$userToken');

    if (response.statusCode == 200) {
      return requestTypeFromJson(response.bodyString.toString());
    } else {
      return [];
    }
  }

  // Future<List<RequestPictureRequired>> getRequestPictureRequired() async {
  //   final _endpoint =
  //       EndpointConfig.getEnpoint(ENDPOINT.REQUEST_PICTURE_REQUIRED);

  //   final _response =
  //       await get(_endpoint + '?user_id=$userId&token=$userToken');

  //   if (_response.statusCode == 200) {
  //     return requestPictureRequiredFromJson(_response.bodyString.toString());
  //   } else {
  //     return [];
  //   }
  // }

  String getNoNetworkText(int? statusCode) {
    String text =
        "Та дахин оролдоно уу ${statusCode != null ? "\nАлдааны код:$statusCode" : ''}";
    return text;
  }
}
