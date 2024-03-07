import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/components/ExamPage/ExamList.dart';
import 'package:project1/controller/RequestController.dart';
import 'package:project1/model/ExamTakeModel.dart';

class ExamResult extends StatefulWidget {
  final String examId;

  ExamResult({
    Key? key,
    required this.examId,
  }) : super(key: key);

  @override
  _ExamResultState createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult> {
  final controller = Get.put(ExamTakeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Icon(Icons.question_mark_outlined, color: Colors.orange),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${controller.request.value.examQuestionList.length}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Нийт асуулт",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
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
                              int correctAnswersCount = controller
                                  .selectedAnswers
                                  .where((answerModel) =>
                                      answerModel.chosenAnswer ==
                                      controller
                                          .request
                                          .value
                                          .examQuestionList[controller
                                              .selectedAnswers
                                              .indexOf(answerModel)]
                                          .correctAnswer)
                                  .length;
                              return Text(
                                "$correctAnswersCount",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                              );
                            },
                          ),
                          Text(
                            "Зөв",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
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
                      Icon(Icons.cancel_outlined, color: Colors.orange),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () {
                              int wrongAnswersCount = controller.selectedAnswers
                                  .where((answerModel) =>
                                      answerModel.chosenAnswer != null &&
                                      answerModel.chosenAnswer !=
                                          controller
                                              .request
                                              .value
                                              .examQuestionList[controller
                                                  .selectedAnswers
                                                  .indexOf(answerModel)]
                                              .correctAnswer)
                                  .length;
                              return Text(
                                "$wrongAnswersCount",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                          Text(
                            "Буруу",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
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
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (controller.request.value.examQuestionList ?? [])
                        .length,
                    itemBuilder: (context, index) {
                      final question =
                          controller.request.value.examQuestionList?[index];
                      final questionId = controller
                          .request.value.examQuestionList[index].questionId;
                      return question != null
                          ? buildQuestionWidget(
                              question,
                              index,
                              RxList<String?>.from(
                                controller.selectedAnswers.map(
                                  (answerModel) => answerModel.chosenAnswer,
                                ),
                              ),
                              questionId,
                            )
                          : SizedBox.shrink();
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Going back to home screen");
                      Get.close(3);
                      Get.find<ExamTakeController>().printStoredAnswers();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Буцах',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildQuestionWidget(
    ExamQuestionList question,
    int questionIndex,
    RxList<String?> selectedAnswers,
    questionId,
  ) {
    String? chosenAnswer = controller.selectedAnswers
        .singleWhere(
          (eachAnswer) => eachAnswer.questionId == question.questionId,
          orElse: () => ExamAnswerModel(),
        )
        .chosenAnswer;

    bool isCorrect =
        chosenAnswer == question.correctAnswer && chosenAnswer != null;

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
                  color: isCorrect ? Colors.green[300] : Colors.red[300],
                ),
                alignment: Alignment.center,
                child: Text(
                  "${questionIndex + 1}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
        buildAnswerList(
          questionIndex,
          question.answerList,
          selectedAnswers,
          questionId,
          question,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget buildAnswerList(
    int questionIndex,
    List<AnswerList> answers,
    RxList<String?> selectedAnswers,
    questionId,
    ExamQuestionList question,
  ) {
    return Column(
      children: answers
          .map((answer) => buildAnswerOption(
                questionIndex,
                answer,
                selectedAnswers,
                questionId,
                question,
              ))
          .toList(),
    );
  }

  Widget buildAnswerOption(
    int questionIndex,
    AnswerList answer,
    RxList<String?> selectedAnswers,
    String questionId,
    ExamQuestionList question,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Obx(() {
        String? chosenAnswer = controller.selectedAnswers
            .singleWhere(
              (eachAnswer) => eachAnswer.questionId == question.questionId,
              orElse: () => ExamAnswerModel(),
            )
            .chosenAnswer;

        bool isSelected = chosenAnswer != null && chosenAnswer == answer.id;
        // bool isCorrect =
        //     chosenAnswer == answer.id && chosenAnswer == question.correctAnswer;

        bool isCorrect = answer.id == question.correctAnswer;

        print(question.correctAnswer);

        final color = isSelected
            ? isCorrect
                ? Colors.green[300]
                : Colors.red[300]
            : isCorrect
                ? Colors.green[300]
                : Colors.white;

        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? isCorrect
                    ? Colors.green[300]
                    : Colors.red[300]
                : isCorrect
                    ? Colors.green[300]
                    : Colors.white,
            border: Border.all(
              color: isSelected
                  ? isCorrect
                      ? Colors.green[300] ?? Colors.green
                      : Colors.red[300] ?? Colors.red
                  : isCorrect
                      ? Colors.green[300] ?? Colors.green
                      : Colors.black,
              width: 0.3,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isSelected
                    ? Icon(
                        isCorrect ? Icons.check : Icons.close,
                        color: isCorrect ? Colors.green : Colors.red,
                      )
                    : Icon(
                        isCorrect ? Icons.check : null,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
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
    );
  }
}
