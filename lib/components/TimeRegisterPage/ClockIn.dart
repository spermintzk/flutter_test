import 'dart:async';
import 'package:get/get.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:async_button_builder/async_button_builder.dart';
import 'package:intl/intl.dart';
import 'package:project1/controller/RequestController.dart';
import 'package:project1/screens/ExamPage.dart';

class ClockIn extends StatelessWidget {
  final mainController = Get.put(ClockInController());

  Future<bool?> showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Цаг бүртгэх"),
          content: Text("Та цаг бүртгэхээ итгэлтэй байна уу?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Тийм"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Үгүй"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Цаг бүртгүүлэх",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            scrollGesturesEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            initialCameraPosition:
                CameraPosition(target: LatLng(46.860942, 103.836983), zoom: 5),
            onMapCreated: (GoogleMapController controller) {
              if (!mainController.controller.isCompleted) {
                controller.setMapStyle(
                    JsonEncoder().convert(jsonDecode(mapStyleJson)));
                mainController.controller.complete(controller);
                mainController.mapController = controller;
              }
            },
            markers: mainController.markers,
            circles: mainController.circles,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              dateDisplay(),
            ],
          ),
          Obx(
            () => Visibility(
              visible: mainController.showClockInButton.value,
              child: Center(
                heightFactor: 12,
                child: AsyncButtonBuilder(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: Colors.white,
                        ),
                        Text(
                          'Эхлэх',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  loadingWidget: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),
                  successWidget: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.check,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    bool? confirmClockIn =
                        await showConfirmationDialog(context);

                    if (confirmClockIn != null && confirmClockIn) {
                      await Future.delayed(Duration(seconds: 2));
                      mainController.timeInsert('1');
                    }
                  },
                  loadingSwitchInCurve: Curves.bounceInOut,
                  loadingTransitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 1.0),
                        end: Offset(0, 0),
                      ).animate(animation),
                      child: child,
                    );
                  },
                  builder: (context, child, callback, state) {
                    return SizedBox(
                      height: 150.0,
                      width: 150.0,
                      child: AvatarGlow(
                        glowRadiusFactor: 0.5,
                        glowColor: Colors.green,
                        child: Material(
                          color: state.maybeWhen(
                            success: () => Colors.greenAccent[700],
                            orElse: () => Colors.greenAccent[700],
                          ),
                          clipBehavior: Clip.hardEdge,
                          shape: CircleBorder(),
                          child: InkWell(
                            child: child,
                            onTap: callback,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dateDisplay() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print(formattedDate);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 25.0),
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Color(0xfff6f6f6),
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0.0, 0.1),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: Text(
          "Өнөөдөр  •  ${formattedDate}",
        ),
      ),
    );
  }
}

final String mapStyleJson = '''
    [
      {
        "featureType": "poi",
        "elementType": "labels",
        "stylers": [
          { "visibility": "off" }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels",
        "stylers": [
          { "visibility": "on" }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "labels",
        "stylers": [
          { "visibility": "off" }
        ]
      },
      {
        "featureType": "administrative",
        "elementType": "labels",
        "stylers": [
          { "visibility": "off" }
        ]
      },
      {
        "featureType": "landscape",
        "elementType": "labels",
        "stylers": [
          { "visibility": "on" }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels",
        "stylers": [
          { "visibility": "off" }
        ]
      },
      {
        "featureType": "road",
        "stylers": [
          { "visibility": "on",
            "color": "#dbd6ff" }
        ]
      },
      {
        "featureType": "landscape",
        "stylers": [
          { "color": "#f2f2f2" }
        ]
      }
    ]
  ''';
