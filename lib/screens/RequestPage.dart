import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project1/components/Approved.dart';
import 'package:project1/components/Denied.dart';
import 'package:project1/components/OnHold.dart';
import 'package:project1/controller/RequestController.dart';
import 'package:project1/widgets/SendRequestBtn.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(RequestController());

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Хүсэлт',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: () {
              _showFilterModal(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.watch_later_outlined, color: Colors.orange)),
            Tab(icon: Icon(Icons.check_circle_outline, color: Colors.orange)),
            Tab(icon: Icon(Icons.no_accounts_outlined, color: Colors.orange)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OnHold(),
          Approved(),
          Denied(),
        ],
      ),
      floatingActionButton: SendRequestBtn(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Шүүлтүүр',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 13,
                itemBuilder: (BuildContext context, int index) {
                  DateTime currentDate = DateTime.now();
                  DateTime previousMonth =
                      DateTime(currentDate.year, currentDate.month - index, 1);

                  String formattedDate =
                      DateFormat('yyyy-MM').format(previousMonth);

                  return ListTile(
                    title: Text(formattedDate),
                    onTap: () {
                      print('Selected: $formattedDate');
                      controller.selectedMonth.value = formattedDate;
                      print(
                          'Updated selectedMonth: ${controller.selectedMonth.value}');
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
