// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';
//
//
// class NotificationScreen extends StatefulWidget {
//
//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//   GlobalKey<ScaffoldMessengerState>();
//
//   ScrollController scrollController =  ScrollController();
//
//   @override
//   void initState() {
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           elevation: 0.0,
//           backgroundColor: Colors.white,
//           centerTitle: true,
//           title: Text('Notifications', style: TextStyle(color: Colors.black87)),
//           leading: IconButton(
//               icon: Icon(Icons.arrow_back_ios),
//               color: Colors.black87,
//               onPressed: () =>  Navigator.pop(context)
//           ),
//
//         ),
//
//         body: Consumer<NotificationProvider>(
//           builder: (context, notificationProvider, child) {
//             int notificationsLength = notificationProvider.notificationsList != null? notificationProvider.notificationsList!.length : 0;
//             int notificationsTotalSize = notificationProvider.totalSize ?? 0;
//
//             var box = Hive.box('myBox');
//            // String notificationType = box.get('notification_type');
//
//            // var _todayRecords = notificationProvider.notificationsList!.where((notification) =>notification.createdAt == 1).length;
//
//             var _todayRecords = notificationProvider.notificationsList!
//                 .where((element) => DateConverter.isoStringToLocalDateOnly(element.createdAt!) == DateConverter.estimatedDate(DateTime.now()))
//                 .toList();
//
//             var _yesterdayRecords = notificationProvider.notificationsList!
//                 .where((element) => DateConverter.isoStringToLocalDateOnly(element.createdAt!) == DateConverter.estimatedDate(DateTime.now().subtract(Duration(days: 1))))
//                 .toList();
//
//             DateTime now = DateTime.now();
//             DateTime lastWeek = now.subtract(Duration(days: 7));
//
//             var _lastSevenDaysRecords = notificationProvider.notificationsList!
//                 .where((element) => DateTime.parse(element.createdAt!).isAfter(lastWeek) &&  DateConverter.isoStringToLocalDateOnly(element.createdAt!) != DateConverter.estimatedDate(DateTime.now().subtract(Duration(days: 1))))
//                 .toList();
//
//             var _earlier = notificationProvider.notificationsList!
//                 .where((element) => DateTime.parse(element.createdAt!).isBefore(lastWeek))
//                 .toList();
//
//             return Column(
//               children: [
//                 Expanded(
//                   child: Scrollbar(
//                     child: SingleChildScrollView(
//                       controller: scrollController,
//                       physics: const BouncingScrollPhysics(),
//                     //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                       child: Center(
//                         child: SizedBox(
//                           width: 1170,
//                           child: notificationProvider.loading?
//                           Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))):
//                           notificationProvider.notificationsList!.length == 0?
//                           Padding(
//                             padding: const EdgeInsets.only(top: 100),
//                             child: Center(child: Text('No notifications yet ')),
//                           ) :
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 10),
//                               notificationProvider.topCardVisibility?
//                               Center(
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(left: 15, right: 15),
//                                         child: Container(
//                                           height: 125,
//                                           decoration: BoxDecoration(
//                                               color: Colors.blueAccent,
//                                             borderRadius: BorderRadius.circular(10),
//                                           ),
//                                           child: Column(
//                                             children: [
//                                               const SizedBox(height: 15),
//                                               Row(
//                                                // mainAxisAlignment: MainAxisAlignment.center,
//                                                 children: [
//                                                   const SizedBox(width: 15),
//                                                   Icon(Icons.notifications_none, color: Colors.white, size: 30),
//                                                   const SizedBox(width: 10),
//                                                   Text('Account notifications', style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 18,
//                                                       fontWeight: FontWeight.bold)),
//
//                                                   Spacer(),
//                                                   InkWell(
//                                                       onTap: () {
//                                                         notificationProvider.setTopCardVisibility(false);
//                                                       },
//                                                       child: Icon(Icons.close_rounded, color: Colors.white)),
//                                                   const SizedBox(width: 15)
//                                                 ],
//                                               ),
//
//                                               const SizedBox(height: 8),
//
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 15, right: 15),
//                                                 child: Text('Your general notifications are here, you can find all your order notifications in the orders tab.',
//                                                     style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.w500)),
//                                               ),
//
//                                             // Row(
//                                             //   children: [
//                                             //     Expanded(
//                                             //       child: Padding(
//                                             //         padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
//                                             //         child: GestureDetector(
//                                             //           onTap: () {
//                                             //
//                                             //           },
//                                             //           child: Container(
//                                             //             height: 48,
//                                             //             width: 80,
//                                             //             decoration: BoxDecoration(
//                                             //               color: Colors.blueAccent,
//                                             //               borderRadius: BorderRadius.circular(10),
//                                             //               border: Border.all(width: 2, color: Colors.white),
//                                             //             ),
//                                             //             child: Center(
//                                             //               child: Text('Turn On Notifications',
//                                             //                   style: TextStyle(fontSize: 15,
//                                             //                     color: Colors.white,
//                                             //                     //fontWeight: FontWeight.bold
//                                             //                   )),
//                                             //             ),
//                                             //           ),
//                                             //         ),
//                                             //       ),
//                                             //     ),
//                                             //   ],
//                                             // )
//
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ) : SizedBox(),
//
//                               _todayRecords.length >0? Padding(
//                                 padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 8),
//                                 child: Text('Today', style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500)),
//                               ) : SizedBox(),
//
//                               _todayRecords.length >0?
//                               Container(
//                                 color: Colors.white,
//                                 child: ListView.builder(
//                                   padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                                   itemCount: _todayRecords.length,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemBuilder: (context, index) {
//                                     NotificationModel _notification = _todayRecords[index];
//                                     String _date = DateConverter.isoStringToLocalDateOnly(_notification.createdAt!) == DateConverter.estimatedDate(DateTime.now()) ? 'Today'
//                                         : DateConverter.isoStringToLocalDateOnly(_notification.createdAt!) == DateConverter.estimatedDate(DateTime.now().subtract(Duration(days: 1)))
//                                         ? 'Yesterday' : DateConverter.isoStringToLocalDateOnly(_notification.createdAt!);
//
//                                     return InkWell(
//                                       onTap: () {
//                                         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
//                                             NotificationDetailsScreen(notification: _notification)));
//                                       },
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Stack(
//                                                   children: [
//                                                     ClipRRect(
//                                                         borderRadius:  BorderRadius.circular(50),
//                                                         child:
//                                                         _notification.image != null?
//                                                         FadeInImage.assetNetwork(
//                                                           placeholder: Images.placeholder_rectangle,
//                                                           image: '${AppConstants.BASE_URL}/public/storage/${_notification.image!.fileFolder}/${_notification.image!.uid}.${_notification.image!.fileExtension}',
//                                                           height: 80,
//                                                           width: 80,
//                                                           fit: BoxFit.cover,
//                                                         ) :
//                                                         Container(
//                                                             height: 80,
//                                                             width: 80,
//                                                             decoration: BoxDecoration(
//                                                               borderRadius: BorderRadius.circular(50),
//                                                               color: Colors.black12,
//                                                             ),
//                                                             child: const Icon(Icons.person, color: Colors.black38)
//                                                         )
//                                                     ),
//
//                                                     Positioned(
//                                                         top:50,
//                                                         right:0,
//                                                         child: Container(
//                                                           height:25,
//                                                             width: 25,
//                                                             decoration: BoxDecoration(
//                                                               borderRadius: BorderRadius.circular(50),
//                                                               color: Theme.of(context).primaryColor,
//                                                             ),
//                                                             child: Icon(Icons.notifications, color: Colors.white, size: 19))
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 10),
//                                               Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 230,
//                                                     child: Text('${_notification.title}',
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         style: TextStyle(
//                                                         color: Colors.black87,
//                                                         fontWeight: FontWeight.w500,
//                                                       fontSize: 15
//                                                     )),
//                                                   ),
//                                                   const SizedBox(height: 5),
//                                                   SizedBox(
//                                                     width: 230,
//                                                     child: Text('${_notification.description}',
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         style: TextStyle(
//                                                         color: Colors.black54,
//                                                         fontWeight: FontWeight.w500,
//                                                         fontSize: 14
//                                                     )),
//                                                   ),
//                                                   const SizedBox(height: 10),
//                                                   Text('${_date}', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500)),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ) : SizedBox(),
//
//                               _yesterdayRecords.length >0? Padding(
//                                 padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 8),
//                                 child: Text('Yesterday', style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500)),
//                               ) : SizedBox(),
//
//                               _yesterdayRecords.length >0?
//                               Container(
//                                 color: Colors.white,
//                                 child: ListView.builder(
//                                   padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                                   itemCount: _yesterdayRecords.length,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemBuilder: (context, index) {
//                                     NotificationModel _notification = _yesterdayRecords[index];
//                                     String _date = DateConverter.isoStringToLocalDateOnly(_notification.createdAt!) == DateConverter.estimatedDate(DateTime.now()) ? 'Today'
//                                         : DateConverter.isoStringToLocalDateOnly(_notification.createdAt!) == DateConverter.estimatedDate(DateTime.now().subtract(Duration(days: 1)))
//                                         ? 'Yesterday' : DateConverter.isoStringToLocalDateOnly(_notification.createdAt!);
//
//                                     return InkWell(
//                                       onTap: () {
//                                         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
//                                             NotificationDetailsScreen(notification: _notification)));
//                                       },
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//
//                                           Row(
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Stack(
//                                                   children: [
//                                                     ClipRRect(
//                                                         borderRadius:  BorderRadius.circular(50),
//                                                         child:
//                                                         _notification.image != null?
//                                                         FadeInImage.assetNetwork(
//                                                           placeholder: Images.placeholder_rectangle,
//                                                           image: '${AppConstants.BASE_URL}/public/storage/${_notification.image!.fileFolder}/${_notification.image!.uid}.${_notification.image!.fileExtension}',
//                                                           height: 80,
//                                                           width: 80,
//                                                           fit: BoxFit.cover,
//                                                         ) :
//                                                         Container(
//                                                             height: 80,
//                                                             width: 80,
//                                                             decoration: BoxDecoration(
//                                                               borderRadius: BorderRadius.circular(50),
//                                                               color: Colors.black12,
//                                                             ),
//                                                             child: const Icon(Icons.person, color: Colors.black38)
//                                                         )
//                                                     ),
//
//                                                     Positioned(
//                                                         top:50,
//                                                         right:0,
//                                                         child: Container(
//                                                             height:25,
//                                                             width: 25,
//                                                             decoration: BoxDecoration(
//                                                               borderRadius: BorderRadius.circular(50),
//                                                               color: Theme.of(context).primaryColor,
//                                                             ),
//                                                             child: Icon(Icons.notifications, color: Colors.white, size: 19))
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 10),
//                                               Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 230,
//                                                     child: Text('${_notification.title}',
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         style: TextStyle(
//                                                             color: Colors.black87,
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 15
//                                                         )),
//                                                   ),
//                                                   const SizedBox(height: 5),
//                                                   SizedBox(
//                                                     width: 230,
//                                                     child: Text('${_notification.description}',
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         style: TextStyle(
//                                                             color: Colors.black54,
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 14
//                                                         )),
//                                                   ),
//                                                   const SizedBox(height: 10),
//                                                   Text('${_date}', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500)),
//                                                 ],
//                                               ),
//
//                                             ],
//                                           ),
//
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ) : SizedBox(),
//
//
//                               _lastSevenDaysRecords.length >0? Padding(
//                                 padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 8),
//                                 child: Text('Last Week', style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500)),
//                               ) : SizedBox(),
//
//                               _lastSevenDaysRecords.length >0?
//                               Container(
//                                 color: Colors.white,
//                                 child: ListView.builder(
//                                   //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                                   itemCount: _lastSevenDaysRecords.length,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemBuilder: (context, index) {
//                                     NotificationModel _notification = _lastSevenDaysRecords[index];
//                                     String _date = DateConverter.isoStringToLocalDateOnly(_notification.createdAt!) == DateConverter.estimatedDate(DateTime.now()) ? 'Today'
//                                         : DateConverter.isoStringToLocalDateOnly(_notification.createdAt!) == DateConverter.estimatedDate(DateTime.now().subtract(Duration(days: 1)))
//                                         ? 'Yesterday' : DateConverter.isoStringToLocalDateOnly(_notification.createdAt!);
//
//                                     return InkWell(
//                                       onTap: () {
//                                         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
//                                             NotificationDetailsScreen(notification: _notification)));
//                                       },
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//
//                                           Row(
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Stack(
//                                                   children: [
//                                                     ClipRRect(
//                                                         borderRadius:  BorderRadius.circular(50),
//                                                         child:
//                                                         _notification.image != null?
//                                                         FadeInImage.assetNetwork(
//                                                           placeholder: Images.placeholder_rectangle,
//                                                           image: '${AppConstants.BASE_URL}/public/storage/${_notification.image!.fileFolder}/${_notification.image!.uid}.${_notification.image!.fileExtension}',
//                                                           height: 80,
//                                                           width: 80,
//                                                           fit: BoxFit.cover,
//                                                         ) :
//                                                         Container(
//                                                             height: 80,
//                                                             width: 80,
//                                                             decoration: BoxDecoration(
//                                                               borderRadius: BorderRadius.circular(50),
//                                                               color: Colors.black12,
//                                                             ),
//                                                             child: const Icon(Icons.person, color: Colors.black38)
//                                                         )
//                                                     ),
//
//                                                     Positioned(
//                                                         top:50,
//                                                         right:0,
//                                                         child: Container(
//                                                             height:25,
//                                                             width: 25,
//                                                             decoration: BoxDecoration(
//                                                               borderRadius: BorderRadius.circular(50),
//                                                               color: Theme.of(context).primaryColor,
//                                                             ),
//                                                             child: Icon(Icons.notifications, color: Colors.white, size: 19))
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 10),
//                                               Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 230,
//                                                     child: Text('${_notification.title}',
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         style: TextStyle(
//                                                             color: Colors.black87,
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 15
//                                                         )),
//                                                   ),
//                                                   const SizedBox(height: 5),
//                                                   SizedBox(
//                                                     width: 230,
//                                                     child: Text('${_notification.description}',
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         style: TextStyle(
//                                                             color: Colors.black54,
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 14
//                                                         )),
//                                                   ),
//                                                   const SizedBox(height: 10),
//                                                   Text('${_date}', style:
//                                                   TextStyle(
//                                                       color: Colors.black54,
//                                                       fontSize: 12,
//                                                       fontWeight: FontWeight.w500)),
//                                                 ],
//                                               ),
//
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ) : SizedBox(),
//
//                               _earlier.length >0? Padding(
//                                 padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 8),
//                                 child: Text('Earlier', style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500)),
//                               ) : SizedBox(),
//
//                               _earlier.length >0?
//                               Container(
//                                 color: Colors.white,
//                                 child: ListView.builder(
//                                   //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                                   itemCount: _earlier.length,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemBuilder: (context, index) {
//                                     NotificationModel _notification = _earlier[index];
//                                     String _date = DateConverter.isoStringToLocalDateOnly(_notification.createdAt!) == DateConverter.estimatedDate(DateTime.now()) ? 'Today'
//                                         : DateConverter.isoStringToLocalDateOnly(_notification.createdAt!) == DateConverter.estimatedDate(DateTime.now().subtract(Duration(days: 1)))
//                                         ? 'Yesterday' : DateConverter.isoStringToLocalDateOnly(_notification.createdAt!);
//
//                                     return InkWell(
//                                       onTap: () {
//                                         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
//                                             NotificationDetailsScreen(notification: _notification)));
//                                       },
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//
//                                           Row(
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.all(8.0),
//                                                 child: Stack(
//                                                   children: [
//                                                     ClipRRect(
//                                                         borderRadius:  BorderRadius.circular(50),
//                                                         child:
//                                                         _notification.image != null?
//                                                         FadeInImage.assetNetwork(
//                                                           placeholder: Images.placeholder_rectangle,
//                                                           image: '${AppConstants.BASE_URL}/public/storage/${_notification.image!.fileFolder}/${_notification.image!.uid}.${_notification.image!.fileExtension}',
//                                                           height: 80,
//                                                           width: 80,
//                                                           fit: BoxFit.cover,
//                                                         ) :
//                                                         Container(
//                                                             height: 80,
//                                                             width: 80,
//                                                             decoration: BoxDecoration(
//                                                               borderRadius: BorderRadius.circular(50),
//                                                               color: Colors.black12,
//                                                             ),
//                                                             child: const Icon(Icons.person, color: Colors.black38)
//                                                         )
//                                                     ),
//
//                                                     Positioned(
//                                                         top:50,
//                                                         right:0,
//                                                         child: Container(
//                                                             height:25,
//                                                             width: 25,
//                                                             decoration: BoxDecoration(
//                                                               borderRadius: BorderRadius.circular(50),
//                                                               color: Theme.of(context).primaryColor,
//                                                             ),
//                                                             child: Icon(Icons.notifications, color: Colors.white, size: 19))
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//
//                                               const SizedBox(width: 10),
//
//                                               Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 230,
//                                                     child: Text('${_notification.title}',
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         style: TextStyle(
//                                                             color: Colors.black87,
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 15
//                                                         )),
//                                                   ),
//                                                   const SizedBox(height: 5),
//                                                   SizedBox(
//                                                     width: 230,
//                                                     child: Text('${_notification.description}',
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         style: TextStyle(
//                                                             color: Colors.black54,
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 14
//                                                         )),
//                                                   ),
//                                                   const SizedBox(height: 10),
//                                                   Text('${_date}', style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500)),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ) : SizedBox(),
//
//                               notificationProvider.bottomLoading?
//                               Column(
//                                 children: [
//                                   SizedBox(height: 10),
//                                   Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
//                                 ],
//                               ) :
//                               notificationsLength < notificationsTotalSize?
//                               Center(child:
//                               GestureDetector(
//                                   onTap: () {
//                                     String offset = notificationProvider.offset ?? '';
//                                     int offsetInt = int.parse(offset) + 1;
//                                     print('$offset -- $offsetInt');
//                                     notificationProvider.showBottomLoader();
//                                     notificationProvider.getNotificationsList(context, offsetInt.toString());
//                                   },
//                                   child: Text('Load more...',style: TextStyle(color: Theme.of(context).primaryColor)))) : SizedBox(),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 15),
//
//               ],
//             );
//           },
//         )
//     );
//   }
// }
