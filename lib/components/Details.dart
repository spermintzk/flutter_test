import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/controller/RequestController.dart';
import 'package:project1/model/RequestDetails.dart';
import 'package:project1/repo/Repository.dart';

final controller = Get.put(RequestController());

class Details extends StatelessWidget {
  final String? requestId;

  Details({required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Дэлгэрэнгүй'),
      ),
      body: requestId == null
          ? Center(
              child: Text('ID Олдсонгүй'),
            )
          : FutureBuilder(
              future: Repository().getRequestDetails(requestId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  RequestDetails requestDetails =
                      snapshot.data as RequestDetails;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Төлөв:', requestDetails.status),
                        _buildDetailRow('Төрөл:', requestDetails.requestType),
                        _buildDetailRow(
                            'Шалгасан админ:', requestDetails.approvedBy),
                        _buildDetailRow(
                            'Дэд төрөл:', requestDetails.requestSubType),
                        _buildDetailRow(
                            'Хүсэлт илгээсэн огноо:', requestDetails.date),
                        _buildDetailRow(
                            'Эхлэх огно:', requestDetails.startDate),
                        _buildDetailRow(
                            'Дуусах огноо:', requestDetails.endDate),
                        _buildDetailRow('Нийт цаг:', requestDetails.time),
                        _buildDetailRow(
                            'Шалтгаан:', requestDetails.description),
                      ],
                    ),
                  );
                }
              },
            ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    Color textColor = Colors.black;

    if (label == 'Төлөв:') {
      textColor = value == 'Зөвшөөрсөн'
          ? Colors.green
          : value == 'Хүлээгдэж буй'
              ? Colors.orange
              : Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(width: 8.0),
          Flexible(
            child: Text(
              value ?? '',
              style: TextStyle(
                color: textColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
