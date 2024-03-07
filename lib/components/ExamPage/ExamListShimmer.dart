import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ExamListShimmer extends StatelessWidget {
  final int numberOfContainers = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: numberOfContainers,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 170,
                margin: EdgeInsets.fromLTRB(8, 2, 8, 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey[500]!,
                      Colors.grey[400]!,
                      Colors.grey[300]!,
                      Colors.grey[200]!,
                    ],
                    stops: const [0.1, 0.3, 0.9, 1.0],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
