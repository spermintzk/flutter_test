import 'package:flutter/material.dart';
import 'package:project1/components/TimeRegisterPage/ClockIn.dart';

class TimeRegisterPage extends StatefulWidget {
  const TimeRegisterPage({Key? key});

  @override
  State<TimeRegisterPage> createState() => _TimeRegisterPageState();
}

class _TimeRegisterPageState extends State<TimeRegisterPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ClockIn(),
    );
  }
}
