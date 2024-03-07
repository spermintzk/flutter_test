// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tiimee/GetController/LoginController/LoginController.dart';
// import 'package:tiimee/Models/Request/Calculate.dart';
// import 'package:tiimee/Models/Request/Request.dart';
// import 'package:tiimee/Models/Request/RequestPictureRequired.dart';
// import 'package:tiimee/Models/Request/RequestTime.dart';
// import 'package:tiimee/Models/Request/RequestType.dart';
// import 'package:tiimee/Models/Request/TimelessDaysModel.dart';

// import 'package:tiimee/Repository/Repository.dart';
// import 'package:tiimee/Utils/CustomColors.dart';
// import 'package:tiimee/Utils/ReusableWidgets.dart';

// import '../../Models/Month.dart';
// import '../../Models/Request/RequestDetail.dart';
// import '../../Screens/HomeScreen/HomeMainMenus/RequestScreen/RequestSend/RequestSend.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project1/model/ExamListModel.dart';
import 'package:project1/model/ExamTakeModel.dart';
import 'package:project1/model/GetCategory.dart';
import 'package:project1/model/GetNews.dart';
import 'package:project1/model/Request.dart';
import 'package:project1/model/CalculateTime.dart';
import 'package:project1/model/RequestDetails.dart';
import 'package:project1/model/RequestTime.dart';
import 'package:project1/model/RequestType.dart';
import 'package:project1/repo/Repository.dart';

class RequestController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getRequest();
  }

  var request = <Request>[].obs;
  var isLoading = false.obs;
  final RxString selectedMonth = ''.obs;

  Future<void> getRequest() async {
    isLoading.value = true;
    request.value = await Repository().getRequest();
    print(request.length);
    isLoading.value = false;
  }
}

class ExamListController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getExamList();
  }

  var request = ExamListModel(success: '', examList: []).obs;
  var isLoading = false.obs;

  Future<void> getExamList() async {
    isLoading.value = true;
    request.value = await Repository().getExamList();
    isLoading.value = false;
  }
}

class GetNewsController extends GetxController {
  var request = GetNews(success: '', feature: [], news: []).obs;
  var isLoading = false.obs;
  var selectedCategoryIds = <String, bool>{};

  Future<void> getNews(String categoryId) async {
    isLoading.value = true;
    request.value = await Repository().getNews(int.parse(categoryId));
    isLoading.value = false;
    print('1');
  }

  Future<void> getNewsIfNeeded(String categoryId) async {
    if (!request.value.news.any((news) => news.id == int.parse(categoryId))) {
      await getNews(categoryId);
    }
    print('1');
  }
}

class GetCategoryController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getCategory();
  }

  var request = <GetCategory>[].obs;
  var isLoading = false.obs;
  void getCategory() async {
    isLoading.value = true;
    request.value = await Repository().getCategory();
    isLoading.value = false;
  }
}

class RequestTypeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getRequestType();
  }

  var request = <RequestType>[].obs;
  var isLoading = false.obs;
  void getRequestType() async {
    isLoading.value = true;
    request.value = await Repository().getRequestType();
    isLoading.value = false;
  }
}

class RequestTimeController extends GetxController {
  get calculatedTime => null;

  @override
  void onInit() {
    super.onInit();
    getRequestTime("2023-01-10 00:00:00.000", 2);
  }

  var request = <RequestTime>[].obs;
  var isLoading = false.obs;

  void getRequestTime(String date, int requestTypeId) async {
    isLoading.value = true;
    request.value = await Repository().getRequestTime(date, requestTypeId);
    isLoading.value = false;
  }
}

class CalculateTimeController extends GetxController {
  var isCalculating = false.obs;
  var calculatedTime = CalculateTime(
    success: "0",
    message: "",
    totalTime: "0",
  ).obs;

  Future<void> getCalculateTime(DateTime startDate, DateTime endDate,
      String requestType, String requestSubType) async {
    isCalculating.value = true;

    var result = await Repository().getCalculateTime(
      startDate.toString(),
      endDate.toString(),
      requestType,
      requestSubType,
    );

    if (result.success == "1") {
      calculatedTime.value = result;
    }

    isCalculating.value = false;
  }
}

class RequestDetailController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getRequestDetails("889581");
  }

  var request = RequestDetails().obs;
  var isLoading = false.obs;

  void getRequestDetails(String requestId) async {
    isLoading.value = true;
    request.value = await Repository().getRequestDetails(requestId);
    isLoading.value = false;
  }
}

class ExamTakeController extends GetxController {
  List<ExamAnswerModel> selectedAnswers = <ExamAnswerModel>[].obs;

  void updateSelectedAnswer(int questionId, String answerId) {
    bool isSelected = selectedAnswers
        .map((element) => element.questionId)
        .toList()
        .contains(questionId.toString());

    if (isSelected) {
      selectedAnswers.removeWhere(
          (element) => element.questionId == questionId.toString());
    }
    selectedAnswers.add(
      ExamAnswerModel(
        questionId: questionId.toString(),
        chosenAnswer: answerId,
      ),
    );
  }

  void printStoredAnswers() {
    selectedAnswers.forEach((answer) {
      print(
          'QuestionId: ${answer.questionId}, AnswerId: ${answer.chosenAnswer}');
    });
  }

  var isExamSent = false.obs;

  Future<bool> sendExam(String examId) async {
    isExamSent.value = true;

    var result = await Repository().sendExam(examId, selectedAnswers);

    if (result.success == "1") {
      isExamSent.value = false;
      return true;
    } else {
      isExamSent.value = false;
      return false;
    }
  }

  var request = ExamTakeModel(
    success: '',
    examId: '',
    examName: '',
    timeQuestion: '',
    examQuestionList: [],
  ).obs;

  var isLoading = true.obs;

  Future<void> getExamDetails(String examId) async {
    isLoading.value = true;
    request.value = await Repository().getExamDetails(examId);
    isLoading.value = false;
  }
}

class RequestSendController extends GetxController {
  var isSentRequest = false.obs;

  Future<bool> sendRequest(DateTime? startDate, DateTime? endDate, int type,
      int subType, String time, String description,
      {String? date}) async {
    isSentRequest.value = true;

    var result = await Repository().sendRequest(
        startDate, endDate, type, subType, time, description,
        date: date);

    if (result.success == "1") {
      Get.back(result: true);

      isSentRequest.value = false;
      return true;
    } else {
      isSentRequest.value = false;
      return false;
    }
  }
}

class RequestTimeDateController extends GetxController {
  Rx<DateTime> startDate = Rx<DateTime>(
    DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      9,
      0,
    ),
  );

  Rx<DateTime> endDate = Rx<DateTime>(
    DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      9,
      0,
    ),
  );

  @override
  void onInit() {
    super.onInit();

    print('object');

    startDate.value = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0);
    endDate.value = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0);
  }
}

class ClockInController extends GetxController {
  final Completer<GoogleMapController> controller = Completer();
  late GoogleMapController mapController;

  Set<Marker> markers = {};
  Set<Circle> circles = {};
  RxBool showClockInButton = false.obs;

  final double workplaceLatitude = 47.908928;
  final double workplaceLongitude = 106.9296605;
  final double workplaceRadius = 100;
  var isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initMap();
  }

  Future<bool> timeInsert(String type) async {
    isSending.value = true;

    try {
      Position currentPosition = await Geolocator.getCurrentPosition();

      var result = await Repository().timeInsert(
        type,
        currentPosition.latitude.toString(),
        currentPosition.longitude.toString(),
      );

      if (result.success == "1") {
        Get.back(result: true);

        isSending.value = false;
        return true;
      } else {
        isSending.value = false;
        return false;
      }
    } catch (e) {
      isSending.value = false;
      _showLocationErrorDialog(e.toString());
      return false;
    }
  }

  Future<void> _initMap() async {
    try {
      await getLocation();
    } catch (e) {
      print("Error initializing map: $e");
    }
  }

  Future<void> getLocation() async {
    try {
      await Geolocator.requestPermission();
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {}

      Position currentPosition = await Geolocator.getCurrentPosition();

      _updateUserLocation(currentPosition);
      _animateCameraToUserLocation(currentPosition);

      double distanceToWorkplace = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        workplaceLatitude,
        workplaceLongitude,
      );

      showClockInButton.value = distanceToWorkplace <= workplaceRadius;
    } catch (e) {
      _showLocationErrorDialog(e.toString());
    }
  }

  void _updateUserLocation(Position position) {
    LatLng userLocation = LatLng(position.latitude, position.longitude);

    markers.add(
      Marker(
        markerId: MarkerId("userLocation"),
        position: userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: "Your Location"),
      ),
    );

    markers.add(
      Marker(
        markerId: MarkerId("workplace"),
        position: LatLng(workplaceLatitude, workplaceLongitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: "Workplace"),
      ),
    );

    circles.add(
      Circle(
        circleId: CircleId("workplaceRadius"),
        center: LatLng(workplaceLatitude, workplaceLongitude),
        radius: workplaceRadius,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.2),
      ),
    );
  }

  void _animateCameraToUserLocation(Position position) {
    LatLng userLocation = LatLng(position.latitude, position.longitude);

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: userLocation, zoom: 15),
      ),
    );
  }

  void _showLocationErrorDialog(String e) {
    Get.dialog(
      AlertDialog(
        title: Text("Location Error"),
        content: Text(e),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


//   var login = Get.find<LoginController>();
//   RxList<dynamic> timelessDays = [].obs;
//   var timelessDayModel = TimelessDaysModel().obs;

//   var sendExamSelectedType = RequestType(id: "-1").obs;
//   var sendExamSelectSubType = SubType(id: "-1").obs;
//   var sendExamStartTime = TimeOfDay(hour: 0, minute: 0).obs;
//   var sendExamEndTime = TimeOfDay(hour: 0, minute: 0).obs;
//   var sendExamStartDate = DateTime.now().obs;
//   var sendExamEndDate = DateTime.now().obs;
//   Rx<TimeOfDay> sendExamCalculatedTime = TimeOfDay(hour: 0, minute: 0).obs;
//   RxList<MissedTimeModel> missedTimeList = <MissedTimeModel>[].obs;

//   var isTimelessDaysLoading = false.obs;

//   var isRequestLoading = false.obs;
//   var isDeleteLoading = false.obs;
//   var isSentRequest = false.obs;

//   var isRequestDetail = false.obs;

//   var approvedList = <Request>[].obs;
//   var denyList = <Request>[].obs;
//   var newList = <Request>[].obs;
//   var requestTypeList = <RequestType>[].obs;
//   var requestDetailModel = RequestDetail().obs;
//   var sendExamTFC = TextEditingController(text: '0${"h".tr}').obs;

//   var requestPictureRequired = <RequestPictureRequired>[].obs;

//   var isMonthLoading = false.obs;
//   var isTimeLoading = false.obs;
//   var isCalculating = false.obs;
//   var isRequestType = false.obs;
//   var isRequestSubType = false.obs;

//   var isNewListCalled = false.obs;
//   var isApprovedListCalled = false.obs;
//   var isDeniedListCalled = false.obs;

//   var calculatedTime = CalculateTime().obs;

//   @override
//   void onInit() {
//     super.onInit();
//     getMonth();
//     getRequestType();
//     getRequest("new", month: "");
//     getRequestPictureRequired();
//   }

//   void getRequest(String requestId, {String? month, int? tabbarIndex}) async {
//     isRequestLoading.value = true;

//     var result = await Repository().getRequest(requestId, month ?? "");
//     if (requestId == "approved") {
//       approvedList.value = result;
//       isApprovedListCalled.value = true;
//     }
//     if (requestId == "new") {
//       newList.value = result;
//       isNewListCalled.value = true;
//     }
//     if (requestId == "denied") {
//       denyList.value = result;
//       isDeniedListCalled.value = true;
//     }
//     isRequestLoading.value = false;
//   }

//   void deteleRequest(String id, String requestId) async {
//     isDeleteLoading.value = true;
//     var result = await Repository().deleteRequest(id);

//     if (result.success == "1") {
//       ReusableWidgets.showSnackBar(
//           "${result.message}", "", Icons.send, Colors.amber,
//           backgroundColor: CustomColors.mainGreen,
//           position: SnackPosition.BOTTOM);

//       isDeleteLoading.value = false;
//       if (requestId == "new") newList(result.requestList);
//     } else {
//       ReusableWidgets.showSnackBar(
//           "Амжилтгүй, ${result.message}", "", Icons.send, Colors.white,
//           iconSize: 20, position: SnackPosition.BOTTOM);
//     }
//     isDeleteLoading.value = false;
//   }

  

//   Future getRequestDetail(String id) async {
//     isRequestDetail.value = true;
//     var result = await Repository().getRequestDetail(id);

//     requestDetailModel.value = result;
//     isRequestDetail.value = false;
//   }

//   var monthList = <Month>[].obs;

//   void getMonth() async {
//     isMonthLoading.value = true;
//     var result = await Repository().getMonth();

//     if (result.length > 0) {
//       isMonthLoading.value = false;
//       monthList(result);
//     }
//     isMonthLoading.value = false;
//   }

//   var requestTimelist = <RequestTime>[].obs;

// Future<void> getRequestTime(String date, int requestType) async {
//   isLoading.value = true;
//   var result = await Repository().getRequestTime(date, requestType);

//   if (result.length > 0) {
//     isLoading.value = false;
//     requestTimelist.clear();
//     requestTimelist.value = result;
//   }
//   isLoading.value = false;
// }

  
//   void getRequestType() async {
//     isRequestType.value = true;
//     var result = await Repository().getRequestType();

//     if (result.length > 0) {
//       requestTypeList.value = result;
//       isRequestType.value = false;
//     }
//     isRequestType.value = false;
//   }

//   Future<void> getTimelessDays(int type) async {
//     isTimelessDaysLoading.value = true;

//     var result = await Repository().getTimelessDays(type);
//     timelessDayModel.value = result;
//     timelessDays.value = result.timelessDays!;
//     missedTimeList.clear();

//     for (int i = 0; i < timelessDays.length; i++) {
//       try {
//         var hour = type == 1
//             ? timelessDays[i].startTime.toString().substring(0, 2).obs
//             : timelessDays[i].endTime.toString().substring(0, 2).obs;

//         var minute = type == 1
//             ? timelessDays[i]
//                 .startTime
//                 .toString()
//                 .substring(
//                   timelessDays[i].startTime!.length - 2,
//                   timelessDays[i].startTime!.length,
//                 )
//                 .obs
//             : timelessDays[i]
//                 .endTime
//                 .toString()
//                 .substring(
//                   timelessDays[i].endTime!.length - 2,
//                   timelessDays[i].endTime!.length,
//                 )
//                 .obs;
//         var date = timelessDays[i].date!.toString().obs;
//         var hourIndex = (int.parse(hour.value) - 1).obs;
//         var minuteIndex = (int.parse(minute.value)).obs;
//         missedTimeList.add(
//           MissedTimeModel(
//             hour: hour,
//             minute: minute,
//             date: date,
//             hourIndex: hourIndex,
//             minuteIndex: minuteIndex,
//             isSelected: false.obs,
//           ),
//         );
//       } catch (e) {}
//     }

//     isTimelessDaysLoading.value = false;
//   }

//   Future<void> getRequestPictureRequired() async {
//     List<RequestPictureRequired> _result =
//         await Repository().getRequestPictureRequired();

//     requestPictureRequired.value = _result;
//   }
// }
