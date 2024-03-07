import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project1/components/Details.dart';
import 'package:project1/controller/RequestController.dart';

class OnHold extends StatefulWidget {
  @override
  State<OnHold> createState() => _OnHoldState();
}

class _OnHoldState extends State<OnHold> {
  final controller = Get.put(RequestController());

  Future<void> _refresh() async {
    await controller.getRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: _refresh,
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
                    final requestDate =
                        DateTime.tryParse(request.startDate ?? '');
                    final formattedMonth = DateFormat('yyyy-MM')
                        .format(requestDate ?? DateTime.now());

                    if (controller.selectedMonth.isEmpty ||
                        controller.selectedMonth == formattedMonth) {
                      if (request.status == 'new') {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.orange,
                              child: InkWell(
                                onTap: () {
                                  print(controller.request[index].id);
                                  Get.to(() => Details(
                                      requestId: controller.request[index].id));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.request[index]
                                                .requestTypeText ??
                                            '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        controller.request[index].description ??
                                            '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Date: ${controller.request[index].startDate}',
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
                        );
                      }
                    }
                    return Container();
                  },
                ),
        ),
      ),
    );
  }
}
