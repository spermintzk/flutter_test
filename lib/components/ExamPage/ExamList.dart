import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project1/components/ExamPage/ExamListShimmer.dart';
import 'package:project1/components/ExamPage/ExamTake.dart';
import 'package:project1/controller/RequestController.dart';

class ExamList extends StatelessWidget {
  final ExamListController controller = Get.put(ExamListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? Center(child: ExamListShimmer())
          : Container(
              child: ListView.builder(
                itemCount: controller.request.value.examList.length,
                itemBuilder: (context, index) {
                  final exam = controller.request.value.examList[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        if (exam.examType != 1) {
                          Get.snackbar(
                            "Алдаа гарлаа",
                            "Та шалгалт өгсөн эсвэл дууссан байна",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  exam.examName,
                                  textAlign: TextAlign.center,
                                ),
                                content: Text(
                                  "Та шалгалт өгөхдөө итгэлтэй байна уу?\nУтсаа унтраах аппаас гарах, апп хаах үед дахин шалгалт өгөх боломжгүй болохыг анхаарна уу.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Үгүй"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Get.to(() =>
                                          ExamTake(examId: exam.examId))?.then(
                                        (value) {
                                          controller.getExamList();
                                        },
                                      );
                                    },
                                    child: Text("Тийм"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 150,
                        ),
                        child: Stack(
                          children: [
                            Container(
                              height: 170,
                              margin: EdgeInsets.fromLTRB(8, 2, 8, 2),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y29ycG9yYXRlJTIwYmFja2dyb3VuZHxlbnwwfHwwfHx8MA%3D%3D',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange[400]!,
                                    offset: const Offset(0, 5),
                                    blurRadius: 20,
                                    spreadRadius: -5,
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                            // Overlay
                            Container(
                              height: 170,
                              margin: EdgeInsets.fromLTRB(8, 2, 8, 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                            // Content
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 16, 16, 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${exam.examName}' ?? '',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: _getExamTypeColor(
                                                exam.examType),
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 70,
                                            maxWidth: 70,
                                          ),
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              _getExamTypeText(exam.examType),
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Нийт асуулт: ${exam.examCnt}',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Row(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(exam.startDate),
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Эхлэх өдөр',
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    '${DateFormat('HH:mm').format(exam.startTime)}-${DateFormat('HH:mm').format(exam.endTime)}',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Эхлэх цаг',
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  exam.score == null
                                                      ? ''
                                                      : '${exam.score}',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  exam.score == null
                                                      ? ''
                                                      : 'Зөв хариулсан',
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          exam.percent != null
                                              ? '${exam.percent}%'
                                              : '0%',
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Гүйцэтгэл',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

String _getExamTypeText(int examType) {
  switch (examType) {
    case 3:
      return "Өгсөн";
    case 0:
      return "Дууссан";
    case 2:
      return "Шалгалт эхлээгүй";
    case 1:
      return "Эхэлсэн";
    default:
      return "";
  }
}

Color _getExamTypeColor(int examType) {
  switch (examType) {
    case 3:
      return Colors.yellow[700]!;
    case 1:
      return Colors.green;
    case 0:
      return Colors.red;
    case 2:
      return Colors.yellow;
    default:
      return Colors.transparent;
  }
}

String _extractDate(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedDate = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  return formattedDate;
}
