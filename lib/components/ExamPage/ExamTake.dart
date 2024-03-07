import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/components/ExamPage/ExamResult.dart';
import 'package:project1/components/ExamPage/ExamSent.dart';
import 'package:project1/controller/RequestController.dart';
import 'package:project1/model/ExamTakeModel.dart';

class ExamTake extends StatefulWidget {
  final String examId;

  ExamTake({
    Key? key,
    required this.examId,
  }) : super(key: key);

  @override
  _ExamTakeState createState() => _ExamTakeState();
}

class _ExamTakeState extends State<ExamTake> with WidgetsBindingObserver {
  final controller = Get.put(ExamTakeController());

  late int totalTimeInSeconds;
  late int currentRemainingSeconds;
  final RxString formattedTime = "".obs;
  RxString controllerMinutes = '300'.obs;

  late Timer timer;

  @override
  void initState() {
    super.initState();

    controller.getExamDetails(widget.examId).then((_) {
      initializeTimer();
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  void initializeTimer() {
    controllerMinutes = RxString(controller.request.value.timeQuestion);
    print('controller minutes: ${controller.request.value.timeQuestion}');
    int parsedMinutes = _parseMinutes(controllerMinutes.value);

    totalTimeInSeconds = parsedMinutes * 60;
    print(parsedMinutes);

    currentRemainingSeconds = totalTimeInSeconds;
    formattedTime.value = _formatTime(currentRemainingSeconds).value;

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (currentRemainingSeconds > 0) {
        currentRemainingSeconds--;
        formattedTime.value = _formatTime(currentRemainingSeconds).value;
      } else {
        timer.cancel();
        print("timer cancelled");
        Get.find<ExamTakeController>().sendExam(widget.examId);
        Get.to(() => ExamSent(examId: widget.examId));
      }
    });
  }

  int _parseMinutes(String input) {
    RegExp regExp = RegExp(r'\d+');
    Iterable<RegExpMatch> matches = regExp.allMatches(input);

    if (matches.isNotEmpty) {
      String numericString = matches.first.group(0)!;
      return int.parse(numericString);
    } else {
      print('input: $input');
      return 120;
    }
  }

  RxString _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    return "$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}"
        .obs;
  }

  @override
  void dispose() {
    timer.cancel();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      print("App idevhgui");

      handleExamSubmission();
    }
  }

  void handleExamSubmission() async {
    try {
      await Get.find<ExamTakeController>().sendExam(widget.examId);
      Get.to(() => ExamSent(examId: widget.examId));
      timer.cancel();
      print("timer cancelled");
    } catch (e) {
      Get.snackbar(
        'Алдаа гарлаа',
        'Та интернэт холболтоо шалгана уу',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.question_mark_outlined,
                            color: Colors.orange),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${controller.request.value.examQuestionList.length}",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Асуулт",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.timer_outlined, color: Colors.orange),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${formattedTime.value}",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Хугацаа",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_box_outlined, color: Colors.orange),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () {
                                int checkedAnswersCount = controller
                                    .selectedAnswers
                                    .where((answerModel) =>
                                        answerModel.chosenAnswer != null)
                                    .length;
                                return Text(
                                  "$checkedAnswersCount",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                );
                              },
                            ),
                            Text(
                              "Бөгөлсөн",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: controller.getExamDetails(widget.examId),
            builder: (context, snapshot) {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                          (controller.request.value.examQuestionList ?? [])
                              .length,
                      itemBuilder: (context, index) {
                        final question =
                            controller.request.value.examQuestionList?[index];
                        final questionId = controller
                            .request.value.examQuestionList?[index].questionId;
                        return question != null
                            ? buildQuestionWidget(
                                question,
                                index,
                                RxList<String?>.from(
                                  controller.selectedAnswers.map(
                                      (answerModel) =>
                                          answerModel.chosenAnswer),
                                ),
                                questionId,
                              )
                            : SizedBox.shrink();
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        print("Submit pressed");
                        if (allQuestionsAnswered()) {
                          try {
                            await Get.find<ExamTakeController>()
                                .sendExam(widget.examId);
                            Get.to(() => ExamSent(examId: widget.examId));
                            timer.cancel();
                            print("timer cancelled");
                          } catch (e) {
                            Get.snackbar(
                              'Алдаа гарлаа',
                              'Та интернэт холболтоо шалгана уу',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } else {
                          Get.snackbar(
                            'Алдаа гарлаа',
                            'Бүх асуултанд хариулна уу',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Дуусгах',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
            },
          ),
        ),
      ),
    );
  }

  Widget buildQuestionWidget(ExamQuestionList question, int questionIndex,
      RxList<String?> selectedAnswers, questionId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange[300],
                ),
                alignment: Alignment.center,
                child: Text(
                  "${questionIndex + 1}",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "${question.question}",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        buildAnswerList(questionIndex, question.answerList, selectedAnswers,
            questionId, question),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget buildAnswerList(int questionIndex, List<AnswerList> answers,
      RxList<String?> selectedAnswers, questionId, ExamQuestionList question) {
    return Column(
      children: answers
          .map((answer) => buildAnswerOption(
              questionIndex, answer, selectedAnswers, questionId, question))
          .toList(),
    );
  }

  Widget buildAnswerOption(
      int questionIndex,
      AnswerList answer,
      RxList<String?> selectedAnswers,
      String questionId,
      ExamQuestionList question) {
    return GestureDetector(
      onTap: () {
        int intQuestionId = int.parse(questionId);
        Get.find<ExamTakeController>()
            .updateSelectedAnswer(intQuestionId, answer.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
        child: Obx(() {
          String? chosenAnswer = controller.selectedAnswers
              .singleWhere(
                  (eachAnswer) => eachAnswer.questionId == question.questionId,
                  orElse: () => ExamAnswerModel())
              .chosenAnswer;

          bool isSelected = chosenAnswer != null && chosenAnswer == answer.id;
          return Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                          Colors.orange[500]!,
                          Colors.orange[400]!,
                          Colors.orange[300]!,
                          Colors.orange[200]!,
                        ],
                      stops: const [
                          0.1,
                          0.3,
                          0.9,
                          1.0
                        ])
                  : LinearGradient(colors: [
                      Colors.white,
                      Colors.white,
                    ], stops: const [
                      0.1,
                      1.0
                    ]),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.black.withAlpha(100),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : null,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    answer.answer,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<bool> showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Шалгалтыг дуусгахдаа итгэлтэй байна уу?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.find<ExamTakeController>().sendExam(widget.examId);
                Get.to(() => ExamSent(
                      examId: widget.examId,
                    ));
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  bool allQuestionsAnswered() {
    final answeredQuestions = controller.selectedAnswers
        .where((answerModel) => answerModel.chosenAnswer != null);
    return answeredQuestions.length ==
        controller.request.value.examQuestionList.length;
  }
}
