import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:project1/widgets/NewsList.dart';
import 'package:project1/controller/RequestController.dart';
import 'package:project1/widgets/NewsBanner.dart';

class NewsTab1 extends StatefulWidget {
  final String categoryId;
  final GetNewsController tabController;

  const NewsTab1(
      {Key? key, required this.categoryId, required this.tabController})
      : super(key: key);

  @override
  NewsTab1State createState() => NewsTab1State();
}

class NewsTab1State extends State<NewsTab1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if (widget.tabController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return CustomScrollView(
              slivers: [
                NewsBanner(
                  controller: widget.tabController,
                  categoryId: widget.categoryId,
                ),
                NewsList(
                  controller: widget.tabController,
                  categoryId: widget.categoryId,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
