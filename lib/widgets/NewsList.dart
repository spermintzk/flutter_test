import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/components/NewsPage/NewsDetail.dart';
import 'package:project1/controller/RequestController.dart';

class NewsList extends StatelessWidget {
  final GetNewsController controller;
  final String categoryId;

  NewsList({required this.controller, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final newsList = controller.request.value.news;
          final newsItem =
              index >= 0 && index < newsList.length ? newsList[index] : null;

          if (newsItem != null) {
            final formattedDate =
                '${newsItem.createdAt.year}-${newsItem.createdAt.month.toString().padLeft(2, '0')}-${newsItem.createdAt.day.toString().padLeft(2, '0')}';

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      print(newsItem.name);

                      Get.to(NewsDetail(
                        thumbnailUrl: newsItem.picture,
                        articleTitle: newsItem.name,
                        articleContent: newsItem.description,
                        dateCreated: newsItem.createdAt,
                        articleViews: newsItem.counter,
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: loadImage(newsItem.picture),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      newsItem.name,
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Огноо: $formattedDate',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
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
          } else {
            return SizedBox.shrink();
          }
        },
        childCount: controller.request.value.news.length,
      ),
    );
  }

  DecorationImage? loadImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
        onError: (exception, stackTrace) {
          print('Error loading image: $exception');

          Center(
            child: Text(
              'Зураг олдсонгүй',
              style: TextStyle(color: Colors.black),
            ),
          );
        },
      );
    } else {
      return null;
    }
  }
}
