import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/widgets/CustomTag.dart';
import 'package:project1/widgets/ImageContainer.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shadow_overlay/shadow_overlay.dart';

class NewsDetail extends StatelessWidget {
  final String articleTitle;
  final String articleContent;
  final String thumbnailUrl;
  final DateTime dateCreated;
  final String articleViews;
  final String formattedDate;

  const NewsDetail({
    Key? key,
    required this.articleTitle,
    required this.articleContent,
    required this.thumbnailUrl,
    required this.dateCreated,
    required this.articleViews,
    this.formattedDate = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (thumbnailUrl.isNotEmpty)
            ShadowOverlay(
              shadowHeight: 250,
              shadowWidth: 800,
              shadowColor: Colors.black.withOpacity(0.8),
              child: Container(
                width: double.infinity,
                child: Image.network(
                  thumbnailUrl,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) {
                    // Handle image loading error
                    return Container(
                      color: Colors.grey, // Placeholder color
                    );
                  },
                ),
              ),
            ),
          ListView(
            children: [
              Column(
                children: [
                  _NewsHeadline(
                    articleTitle: articleTitle,
                  ),
                  _NewsBody(
                    articleContent: articleContent,
                    dateCreated: dateCreated,
                    articleViews: articleViews,
                    articleTitle: articleTitle,
                    thumbnailUrl: thumbnailUrl,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}

class _NewsBody extends StatelessWidget {
  const _NewsBody({
    Key? key,
    required this.articleContent,
    required this.dateCreated,
    required this.articleViews,
    required this.articleTitle,
    required this.thumbnailUrl,
    this.formattedDate = '',
  }) : super(key: key);

  final String articleContent;
  final DateTime dateCreated;
  final String articleViews;
  final String articleTitle;
  final String thumbnailUrl;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomTag(
                backgroundColor: Colors.grey.shade200,
                children: [
                  const Icon(
                    Icons.access_time_filled,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${dateCreated.year}-${dateCreated.month.toString().padLeft(2, '0')}-${dateCreated.day.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(width: 10),
              CustomTag(
                backgroundColor: Colors.grey.shade200,
                children: [
                  const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${articleViews}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            articleTitle,
            style: GoogleFonts.montserratAlternates(
              textStyle: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ImageContainer(
            height: 300,
            width: MediaQuery.of(context).size.width,
            imageUrl: thumbnailUrl,
            margin: const EdgeInsets.only(right: 5.0, bottom: 5.0),
          ),
          const SizedBox(height: 20),
          Html(data: articleContent, style: {
            "p": Style(
              fontSize: FontSize(18),
              color: Colors.black,
            ),
            "li": Style(
              fontSize: FontSize(18),
              color: Colors.black,
            ),
            "span": Style(
              fontSize: FontSize(18),
              color: Colors.black,
            ),
          })
        ],
      ),
    );
  }
}

class _NewsHeadline extends StatelessWidget {
  const _NewsHeadline({
    Key? key,
    required this.articleTitle,
  }) : super(key: key);

  final String articleTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.09,
          ),
          CustomTag(
            backgroundColor: Colors.grey.withAlpha(150),
            children: [
              Text('Онцлох',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            articleTitle,
            style: GoogleFonts.montserratAlternates(
              textStyle: TextStyle(
                fontSize: calculateFontSize(articleTitle.length),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
}
