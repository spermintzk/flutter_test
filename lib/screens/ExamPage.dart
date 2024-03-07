import 'package:flutter/material.dart';
import 'package:project1/components/ExamPage/ExamList.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Шалгалт",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: ExamList(),
    );
  }
}
