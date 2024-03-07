// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:tiimee/Configs/StoragePreference.dart';
// import 'package:tiimee/GetController/MainMenuControllers/RequestController.dart';
// import 'package:tiimee/Models/Request/Request.dart';
// import 'package:tiimee/Screens/HomeScreen/HomeWidgets/CustomDialogBox.dart';
// import 'package:tiimee/Utils/CustomColors.dart';
// import 'package:tiimee/Utils/ReusableWidgets.dart';

// // ignore: must_be_immutable
// class RequestListTile extends StatelessWidget {
//   final int tabIndex;
//   final Request request;
//   final int index;
//   RequestListTile({
//     Key? key,
//     required this.tabIndex,
//     required this.request,
//     required this.index,
//   }) : super(key: key);

//   var _controller = Get.find<RequestController>();

//   double fontSize =
//       !StorageUtil.getDicString("DEVICE_INFO").contains("Redmi") ? 12 : 10;

//   void requestDelete(int index, int tabIndex) {
//     _controller.deteleRequest(request.id!, 'new');
//   }

//   @override
//   Widget build(BuildContext context) {
//     String time =
//         ReusableWidgets.requestTimeFormatter(request.requestType!, request.time)
//             .replaceAll(' ', '')
//             .trim();
//     return Stack(
//       children: [
//         Container(
//           height: 120,
//           width: MediaQuery.of(context).size.width,
//           color: Colors.white,
//           child: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Container(
//                   height: 90,
//                   width: 90,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: getColor(request.status!),
//                   ),
//                   child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Text(
//                           "Total time".tr,
//                           style: TextStyle(
//                               fontSize: 13,
//                               fontFamily: 'nunito',
//                               fontWeight: FontWeight.w200,
//                               color: Colors.white),
//                         ),
//                         Text(
//                           time,
//                           style: TextStyle(
//                               fontSize: time.length > 6
//                                   ? 14
//                                   : time.length > 5
//                                       ? 16
//                                       : 22,
//                               fontFamily: 'nunito',
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                         Container(
//                           padding: EdgeInsets.all(5),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Color.fromARGB(255, 224, 226, 231)
//                                   .withOpacity(0.4)),
//                           child: Text(
//                             getStatus(tabIndex),
//                             style: TextStyle(
//                                 fontSize: fontSize,
//                                 fontFamily: 'nunito',
//                                 fontWeight: FontWeight.w200,
//                                 color: Colors.white),
//                           ),
//                         )
//                       ]),
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.only(left: 10.0, top: 10, right: 10),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: request.requestTypeText.toString(),
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 fontFamily: 'nunito',
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             if (request.requestSubTypeText != null &&
//                                 request.requestSubTypeText != '')
//                               TextSpan(
//                                 text: " (" +
//                                     "${request.requestSubTypeText != null ? request.requestSubTypeText!.split(' ')[0] : ''}" +
//                                     ')',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontFamily: 'nunito',
//                                   color: Colors.black,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         request.description ?? '-',
//                         maxLines: 2,
//                         softWrap: false,
//                         textAlign: TextAlign.left,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(fontFamily: 'nunito'),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.calendar_month_outlined,
//                                     size: 27,
//                                     color: getColor(request.status!),
//                                   ),
//                                   SizedBox(width: 5),
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         request.startDate == null
//                                             ? ''
//                                             : DateFormat('yyyy/MM/dd')
//                                                 .format(request.startDate!),
//                                         style: TextStyle(
//                                           fontFamily: 'nunito',
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                       Text(
//                                         request.startDate == null
//                                             ? ''
//                                             : DateFormat('HH:mm')
//                                                 .format(request.startDate!),
//                                         style: TextStyle(
//                                           fontFamily: 'nunito',
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               if (request.requestType != '6' &&
//                                   request.requestType != '8')
//                                 SizedBox(width: 5),
//                               if (request.requestType != '6' &&
//                                   request.requestType != '8')
//                                 Text(
//                                   '-',
//                                   style: TextStyle(
//                                     fontFamily: 'nunito',
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               if (request.requestType != '6' &&
//                                   request.requestType != '8')
//                                 SizedBox(width: 5),
//                               if (request.requestType != '6' &&
//                                   request.requestType != '8')
//                                 Row(
//                                   children: [
//                                     SizedBox(width: 5),
//                                     Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           request.endDate == null
//                                               ? ''
//                                               : DateFormat('yyyy/MM/dd')
//                                                   .format(request.endDate!),
//                                           style: TextStyle(
//                                             fontFamily: 'nunito',
//                                             fontSize: 10,
//                                           ),
//                                         ),
//                                         Text(
//                                           request.endDate == null
//                                               ? ''
//                                               : DateFormat('HH:mm')
//                                                   .format(request.endDate!),
//                                           style: TextStyle(
//                                             fontFamily: 'nunito',
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                             ],
//                           ),
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 CircleAvatar(
//                                   radius: fontSize == 12 ? 20 : 15,
//                                   backgroundColor: Colors.green[50],
//                                   child: const Icon(
//                                     Icons.remove_red_eye,
//                                     color: Colors.green,
//                                     size: 20,
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Visibility(
//                                     visible: tabIndex == 0,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         if (tabIndex == 0) {
//                                           showDialog(
//                                               context: context,
//                                               builder: (BuildContext context) {
//                                                 return CustomDialogBox(
//                                                   title: "Хүсэлт устгах",
//                                                   descriptions:
//                                                       "Та хүсэлтээ устгахдаа итгэлтэй байна уу",
//                                                   yesTxt: "Тийм",
//                                                   noTxt: "Үгүй",
//                                                   pressYesButton: () {
//                                                     Navigator.pop(context);
//                                                     requestDelete(
//                                                         index, tabIndex);
//                                                   },
//                                                   pressNoButton: () =>
//                                                       Navigator.pop(context),
//                                                 );
//                                               });
//                                         }
//                                       },
//                                       child: CircleAvatar(
//                                           radius: fontSize == 12 ? 20 : 15,
//                                           backgroundColor: Colors.red[50],
//                                           child: const Icon(
//                                             Icons.delete,
//                                             color: CustomColors.mainRedColor,
//                                             size: 20,
//                                           )),
//                                     ))
//                               ]),
//                         ],
//                       ),
//                       SizedBox(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         if (index != 0)
//           Divider(
//             height: 1,
//             color: Colors.grey,
//           ),
//       ],
//     );
//   }
// }

// String getStatus(int tabIndex) {
//   if (tabIndex == 0) return "Хүлээлтэнд";
//   if (tabIndex == 1) return "Зөвшөөрсөн";
//   if (tabIndex == 2) return "Татгалзсан";
//   return "";
// }

// Color getColor(String type) {
//   Color? color;
//   switch (type) {
//     case "new":
//       color = Colors.amber;

//       break;
//     case "approved":
//       color = CustomColors.mainGreen;

//       break;
//     case "denied":
//       color = CustomColors.mainPinkColor;

//       break;

//     default:
//   }

//   return color!;
// }
