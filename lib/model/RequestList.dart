import 'package:flutter/material.dart';
import 'package:project1/model/Request.dart';

class RequestList extends StatelessWidget {
  final String status;

  RequestList({required this.status});

  @override
  Widget build(BuildContext context) {
    List<Request> allRequests = getRequests();

    List<Request> filteredRequests =
        allRequests.where((request) => request.status == status).toList();

    return ListView.builder(
      itemCount: filteredRequests.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredRequests[index].requestType ?? ''),
          subtitle: Text(filteredRequests[index].startDate ?? ''),
        );
      },
    );
  }

  List<Request> getRequests() {
    return [
      Request(
          id: '1',
          requestType: '30',
          status: 'approved',
          startDate: '2022-01-01'),
      Request(
          id: '2',
          requestType: '30',
          status: 'denied',
          startDate: '2022-02-01'),
    ];
  }
}
