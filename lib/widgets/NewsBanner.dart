import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/components/NewsPage/NewsDetail.dart';
import 'package:project1/controller/RequestController.dart';
import 'package:shadow_overlay/shadow_overlay.dart';

class NewsBanner extends StatelessWidget {
  final GetNewsController controller;
  final String categoryId;
  NewsBanner({required this.controller, required this.categoryId});

  double calculateFontSize(int textLength) {
    double baseFontSize = 25.0;
    double minLength = 20.0;
    double maxLength = 50.0;
    double reductionFactor = 0.3;

    double fontSize =
        baseFontSize - (reductionFactor * (textLength - maxLength).abs());

    if (textLength < minLength) {
      return baseFontSize.clamp(16.0, baseFontSize);
    }

    return fontSize.clamp(16.0, baseFontSize);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      pinned: false,
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        background: Obx(
          () {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            var featureList = controller.request.value.feature;
            var newsList = controller.request.value.news;

            if (featureList.isEmpty) {
              return SizedBox(
                height: 0,
                child: Container(
                  child: Text(
                    "Feature list Hooson",
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.amber,
                ),
              );
            }

            return CarouselSlider.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index, realIndex) {
                var newsItem = newsList[index];

                return GestureDetector(
                  onTap: () {
                    print(newsItem.name);

                    Get.to(() => NewsDetail(
                          thumbnailUrl: newsItem.picture,
                          articleTitle: newsItem.name,
                          articleContent: newsItem.description,
                          dateCreated: newsItem.createdAt,
                          articleViews: newsItem.counter,
                        ));
                  },
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Stack(
                      children: [
                        ShadowOverlay(
                          shadowHeight: 250,
                          shadowWidth: 800,
                          shadowColor: Colors.black.withOpacity(0.7),
                          child: Container(
                            height: 400,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              image: DecorationImage(
                                image: NetworkImage(newsItem.picture),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 25,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.orange),
                                  child: Center(
                                    child: Text(
                                      'Онцлох',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  newsItem.name,
                                  style: GoogleFonts.montserratAlternates(
                                    textStyle: TextStyle(
                                      fontSize: calculateFontSize(
                                          newsItem.name.length),
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 300,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
