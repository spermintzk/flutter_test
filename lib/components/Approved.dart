import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project1/components/Details.dart';
import 'package:project1/controller/RequestController.dart';

class Approved extends StatefulWidget {
  @override
  State<Approved> createState() => _ApprovedState();
}

class _ApprovedState extends State<Approved> {
  final controller = Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(
        () => controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: controller.request.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final request = controller.request[index];
                  final requestDate = DateTime.parse(request.date ?? '');
                  final formattedMonth =
                      DateFormat('yyyy-MM').format(requestDate);

                  if (controller.selectedMonth.isEmpty ||
                      controller.selectedMonth == formattedMonth) {
                    if (request.status == 'approved') {
                      return Dismissible(
                        key: Key(request.id.toString()),
                        onDismissed: (direction) {
                          setState(() {
                            controller.request.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Бүртгэл устгагдлаа')));
                        },
                        background: Container(color: Colors.green),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green[400],
                              child: InkWell(
                                onTap: () {
                                  print(controller.request[index].id);
                                  Get.to(() => Details(requestId: request.id));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        request.requestTypeText ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        request.description ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Date: ${request.date}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }

                  return Container();
                },
              ),
      ),
    );
  }
}
