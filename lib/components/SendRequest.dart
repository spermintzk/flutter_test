import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/controller/RequestController.dart';
import 'package:project1/widgets/TimePicker.dart';

class SendRequest extends StatefulWidget {
  @override
  _SendRequestState createState() => _SendRequestState();
}

class _SendRequestState extends State<SendRequest> {
  String selectedOption = 'Сонгох';
  int selectedRadio = 0;
  int numberOfRadioButtons = 0;
  int selectedSubType = 0;
  DateTime startDate = DateTime(2024, 1, 10, 9, 0);
  DateTime endDate = DateTime(2024, 1, 10, 18, 0);

  final controller = Get.put(RequestTypeController());
  final controllerl = Get.put(RequestSendController());
  final calculateTimeController = Get.put(CalculateTimeController());
  final requestTimeDateController = Get.put(RequestTimeDateController());
  final TextEditingController textController = TextEditingController();

  Future<void> _calculateTime() async {
    print("Calc called");

    await calculateTimeController.getCalculateTime(
      requestTimeDateController.startDate.value,
      requestTimeDateController.endDate.value,
      selectedRadio.toString(),
      selectedSubType.toString(),
    );
    print(requestTimeDateController.startDate.value);
    print(requestTimeDateController.endDate.value);
  }

  void _sendRequest() async {
    await _calculateTime();

    inspect(calculateTimeController.calculatedTime.value);

    bool success = await controllerl.sendRequest(
      requestTimeDateController.startDate.value,
      requestTimeDateController.endDate.value,
      selectedRadio,
      selectedSubType,
      calculateTimeController.calculatedTime.value.totalTime,
      textController.text,
      date: "",
    );

    if (success) {
      requestTimeDateController.startDate.value = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0);
      requestTimeDateController.endDate.value = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 9, 0);
      print("Request sent successfully");
    } else {
      print("Request send failed");
    }
  }

  void _showOptionsModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.request.length,
                  itemBuilder: (context, index) {
                    var requestType = controller.request[index];
                    return ListTile(
                      title: Text(requestType.name),
                      onTap: () {
                        _selectOption(index, requestType.subType.length);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getRequestTimeForSelectedType() {
    if (selectedRadio >= 0 && selectedRadio < controller.request.length) {
      final selectedTypeString = controller.request[selectedRadio].type;
      final selectedType = int.tryParse(selectedTypeString);

      if (selectedType != null) {
        final selectedDate = "2023-01-10 00:00:00.000";

        Get.find<RequestTimeController>()
            .getRequestTime(selectedDate, selectedType);
      }
    }
  }

  void _selectOption(int selectedIndex, int numberOfButtons) {
    Navigator.pop(context);
    setState(() {
      selectedRadio = selectedIndex;
      selectedOption = controller.request[selectedIndex].name;
      numberOfRadioButtons = numberOfButtons;
    });

    _getRequestTimeForSelectedType();
  }

  List<Widget> buildSubTypeRadioButtons() {
    List<Widget> radioButtons = [];
    if (controller.request.isNotEmpty &&
        controller.request[selectedRadio].subType.isNotEmpty) {
      for (int i = 0;
          i < controller.request[selectedRadio].subType.length;
          i++) {
        radioButtons.add(
          RadioListTile(
            title: Text(controller.request[selectedRadio].subType[i].name),
            value: i,
            groupValue: selectedRadio,
            onChanged: (value) {
              print(controller.request[selectedRadio]);
              setState(() {
                selectedRadio = value!;
                print(value);
              });
            },
          ),
        );
      }
    }
    return radioButtons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: Text('Хүсэлт илгээх'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                "Хүсэлтийн төрлөө сонгоно уу",
                textAlign: TextAlign.left,
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 50)),
              ),
              onPressed: _showOptionsModal,
              child: Text(
                '$selectedOption',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            for (int i = 0; i < numberOfRadioButtons; i++)
              RadioListTile(
                title: Text(
                  controller.request.isNotEmpty &&
                          selectedRadio < controller.request.length &&
                          controller
                              .request[selectedRadio].subType.isNotEmpty &&
                          i < controller.request[selectedRadio].subType.length
                      ? controller.request[selectedRadio].subType[i].name
                      : 'Unknown',
                ),
                value: i,
                groupValue: selectedSubType,
                onChanged: (value) {
                  setState(() {
                    selectedSubType = value!;
                  });
                },
              ),
            DatePickerExample(),
            CupertinoButton(
              onPressed: () => _calculateTime(),
              child: const Text('Calculate Time'),
            ),
            Obx(
              () {
                if (calculateTimeController.isCalculating.value) {
                  return const CircularProgressIndicator();
                } else {
                  return Text(
                    'Нийт цаг: ${calculateTimeController.calculatedTime.value.totalTime}',
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: textController,
                minLines: 6,
                maxLines: null,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  labelText: 'Тайлбар оруулна уу',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _sendRequest,
              child: Text('Хүсэлт илгээх'),
            ),
          ],
        ),
      ),
    );
  }
}
