import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project1/components/ExamPage/ExamResult.dart';

class ExamSent extends StatefulWidget {
  final String examId;
  ExamSent({
    Key? key,
    required this.examId,
  }) : super(key: key);

  @override
  _ExamSentState createState() => _ExamSentState();
}

class _ExamSentState extends State<ExamSent> with TickerProviderStateMixin {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/icons/ExamSuccess.json',
                repeat: false,
                alignment: Alignment.center,
              ),
              SizedBox(height: 20),
              AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: opacity,
                child: Container(
                  width: 400,
                  child: Text(
                    "ШАЛГАЛТ АМЖИЛТТАЙ ИЛГЭЭГДЛЭЭ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: opacity,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => ExamResult(examId: widget.examId));
                  },
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Хариугаа харах',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: opacity,
                child: GestureDetector(
                  onTap: () {
                    Get.close(2);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Буцах',
                      style: TextStyle(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
