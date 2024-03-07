import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/controller/RequestController.dart';

class DatePickerExample extends StatefulWidget {
  const DatePickerExample({Key? key}) : super(key: key);

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  final controller = Get.put(RequestTimeController());
  final calculateTimeController = Get.put(CalculateTimeController());
  final requestTimeDateController = Get.put(RequestTimeDateController());

  late DateTime now;
  late DateTime date1 = DateTime(2000, 1, 1, 9, 0);
  late DateTime time1 = DateTime(2000, 1, 1, 9, 0);
  late DateTime date2 = DateTime(2000, 1, 1, 9, 0);
  late DateTime time2 = DateTime(2000, 1, 1, 9, 0);
  String first = '';

  final List<String> minutesList = List.generate(60, (index) => '$index');
  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    date1 = DateTime(now.year, now.month, now.day);
    date2 = DateTime(now.year, now.month, now.day);

    if (controller.request.isNotEmpty) {
      time1 = DateTime(now.year, now.month, now.day,
          int.parse(controller.request.first.hour), 0);
      time2 = DateTime(now.year, now.month, now.day,
          int.parse(controller.request.first.hour), 0);
    }
  }

  void _showDialog(Widget child, bool isStartTime) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  _onStartTimeSelected(int hour, int minute, bool isStartTime) {
    setState(() {
      if (isStartTime) {
        time1 = DateTime(
          date1.year,
          date1.month,
          date1.day,
          hour,
          minute,
        );
        requestTimeDateController.startDate.value = time1;
      } else {
        time2 = DateTime(
          date2.year,
          date2.month,
          date2.day,
          hour,
          minute,
        );
        requestTimeDateController.endDate.value = time2;
      }
    });
  }

  _onDateSelected(DateTime newDate, bool isStartTime) {
    setState(() {
      if (isStartTime) {
        date1 = newDate;
        requestTimeDateController.startDate.value = DateTime(
          date1.year,
          date1.month,
          date1.day,
          time1.hour,
          time1.minute,
        );
      } else {
        date2 = newDate;
        requestTimeDateController.endDate.value = DateTime(
          date2.year,
          date2.month,
          date2.day,
          time2.hour,
          time2.minute,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 22.0,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _DatePickerItem(
                    isStartTime: true,
                    children: <Widget>[
                      const Text('Date 1'),
                      CupertinoButton(
                        onPressed: () => _showDialog(
                          CupertinoDatePicker(
                            initialDateTime: date1,
                            mode: CupertinoDatePickerMode.date,
                            use24hFormat: true,
                            showDayOfWeek: false,
                            onDateTimeChanged: (DateTime newDate) {
                              _onDateSelected(newDate, true);
                            },
                          ),
                          true,
                        ),
                        child: Text(
                          '${date1.year}-${date1.month}-${date1.day}',
                          style: const TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _DatePickerItem(
                    isStartTime: true,
                    children: <Widget>[
                      const Text('Time 1'),
                      CupertinoButton(
                        onPressed: () => _showDialog(
                          CupertinoPicker(
                            itemExtent: 32.0,
                            scrollController: FixedExtentScrollController(
                              initialItem: controller.request.indexWhere(
                                (requestTime) =>
                                    requestTime.hour == '${time1.hour}',
                              ),
                            ),
                            onSelectedItemChanged: (index) {
                              final hour =
                                  int.parse(controller.request[index].hour);
                              final minute = time1.minute;
                              _onStartTimeSelected(hour, minute, true);
                            },
                            children: controller.request
                                .map((requestTime) => Text(
                                      '${requestTime.hour}',
                                      style: const TextStyle(
                                        fontSize: 22.0,
                                      ),
                                    ))
                                .toList(),
                          ),
                          true,
                        ),
                        child: Text(
                          '${time1.hour}:${time1.minute}0',
                          style: const TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _DatePickerItem(
                    isStartTime: false,
                    children: <Widget>[
                      const Text('Date 2'),
                      CupertinoButton(
                        onPressed: () => _showDialog(
                          CupertinoDatePicker(
                            initialDateTime: date2,
                            mode: CupertinoDatePickerMode.date,
                            use24hFormat: true,
                            showDayOfWeek: false,
                            onDateTimeChanged: (DateTime newDate) {
                              _onDateSelected(newDate, false);
                            },
                          ),
                          false,
                        ),
                        child: Text(
                          '${date2.year}-${date2.month}-${date2.day}',
                          style: const TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _DatePickerItem(
                    isStartTime: false,
                    children: <Widget>[
                      const Text('Time 2'),
                      CupertinoButton(
                        onPressed: () => _showDialog(
                          CupertinoPicker(
                            itemExtent: 32.0,
                            scrollController: FixedExtentScrollController(
                              initialItem: controller.request.indexWhere(
                                (requestTime) =>
                                    requestTime.hour == '${time2.hour}',
                              ),
                            ),
                            onSelectedItemChanged: (index) {
                              final hour =
                                  int.parse(controller.request[index].hour);
                              final minute = time2.minute;
                              _onStartTimeSelected(hour, minute, false);
                            },
                            children: controller.request
                                .map((requestTime) => Text(
                                      '${requestTime.hour}',
                                      style: const TextStyle(
                                        fontSize: 22.0,
                                      ),
                                    ))
                                .toList(),
                          ),
                          false, // isStartTime
                        ),
                        child: Text(
                          '${time2.hour}:${time2.minute}0',
                          style: const TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children, required this.isStartTime});

  final List<Widget> children;
  final bool isStartTime;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
