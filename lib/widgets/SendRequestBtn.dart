import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:project1/components/SendRequest.dart';
import 'package:project1/controller/RequestController.dart';

class SendRequestBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Get.to(() => SendRequest());
        RequestTimeDateController().onInit();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          'assets/icons/paperplane.svg',
          height: 35,
          width: 35,
        ),
      ),
    );
  }
}
