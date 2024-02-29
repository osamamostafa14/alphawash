// import 'dart:async';
//
// import 'package:alphawash/data/model/response/admin_task_model.dart';
// import 'package:alphawash/data/model/response/user_info_model.dart';
// import 'package:alphawash/data/model/response/waypoint_model.dart';
// import 'package:alphawash/provider/location_provider.dart';
// import 'package:alphawash/provider/theme_provider.dart';
// import 'package:alphawash/utill/color_resources.dart';
// import 'package:alphawash/view/screens/users/admin_tasks/admin_add_task_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:alphawash/provider/auth_provider.dart';
// import 'package:alphawash/utill/dimensions.dart';
//
// class TaskDetailsScreen extends StatefulWidget {
//   AdminTaskModel? tasks;
//   UserInfoModel? worker;
//   WaypointModel? waypoint;
//   TaskDetailsScreen(
//       {@required this.worker, @required this.waypoint, @required this.tasks});
//
//   @override
//   State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
// }
//
// class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
//   @override
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//       GlobalKey<ScaffoldMessengerState>();
//
//   ScrollController scrollController = ScrollController();
//   @override
//   Widget build(BuildContext? context) {
//     return Scaffold(
//         backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
//         appBar: AppBar(
//           elevation: 0.0,
//           backgroundColor: Theme.of(context).primaryColor,
//           centerTitle: true,
//           title:
//               const Text('Task Details', style: TextStyle(color: Colors.white)),
//           leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               color: Colors.white,
//               onPressed: () => Navigator.pop(context)),
//         ),
//         body: Scrollbar(
//           child: SingleChildScrollView(
//               padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 30),
//                     Text(
//                       'Waypoint Name:',
//                       style: TextStyle(
//                           color: Theme.of(context).textTheme.headline1!.color,
//                           fontSize: 15),
//                     ),
//                     const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//
//                     Text(widget.tasks!.waypoint!.name.toString(),
//                         textAlign: TextAlign.justify,
//                         style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w500
//                         )),
//
//                     const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
//
//                     Text(
//                       'Worker Name:',
//                       style: TextStyle(
//                           color: Theme.of(context).textTheme.headline1!.color,
//                           fontSize: 15),
//                     ),
//
//                     const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//
//                     Text(widget.worker!.fullName.toString(),
//                         // widget.tasks!.waypoint!.area!.name.toString(),
//                         textAlign: TextAlign.justify,
//                         style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w500
//                         )),
//
//                     const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
//
//                     Text(
//                       'Date :',
//                       style: TextStyle(
//                           color: Theme.of(context).textTheme.headline1!.color,
//                           fontSize: 15),
//                     ),
//                     const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                     Text(
//                         DateFormat('dd/MM/yyyy')
//                             .format(widget.tasks!.requiredDateTime!),
//                         // widget.tasks!.waypoint!.area!.name.toString(),
//                         textAlign: TextAlign.justify,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black87,
//                         )),
//
//                     const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
//
//                     Text(
//                       'Time :',
//                       style: TextStyle(
//                           color: Theme.of(context).textTheme.headline1!.color,
//                           fontSize: 15),
//                     ),
//                     const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                     Text(
//                         DateFormat('hh:mm a')
//                             .format(widget.tasks!.requiredDateTime!),
//
//                         // widget.tasks!.waypoint!.area!.name.toString(),
//                         textAlign: TextAlign.justify,
//                         style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black87,
//                             fontWeight: FontWeight.w500
//                         )),
//                     const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
//                     widget.tasks!.taskDetails == null
//                         ? SizedBox()
//                         : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Task Details:',
//                           style: TextStyle(
//                               color: Theme.of(context)
//                                   .textTheme
//                                   .headline1!
//                                   .color,
//                               fontSize: 15),
//                         ),
//                         const SizedBox(
//                             height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                         Text(
//                             '${widget.tasks!.taskDetails.toString()}',
//                             textAlign: TextAlign.justify,
//                             style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.w500
//                             )),
//                       ],
//                     ),
//                     const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
//                   ])),
//         ));
//   }
// }
import 'dart:async';

import 'package:alphawash/data/model/response/admin_task_model.dart';
import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/theme_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/view/screens/users/admin_tasks/admin_add_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/utill/dimensions.dart';

class TaskDetailsScreen extends StatefulWidget {
  PinPointsTaskModel? tasks;

  TaskDetailsScreen({
    @required this.tasks,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext? context) {
    return Scaffold(
        backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title:
              const Text('Task Details', style: TextStyle(color: Colors.white)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () => Navigator.pop(context)),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: const BouncingScrollPhysics(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8),
                          child: Text(
                            "ID: ${widget.tasks!.pinpointId}",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color!
                                    .withOpacity(0.5),
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                            '${Provider.of<SplashProvider>(
                              context,
                            ).baseUrls!.taskImageUrl}/${widget.tasks!.image}',
                            width: 300,
                            height: 200,
                            fit: BoxFit.cover)),
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    Row(
                      children: [
                        Text(
                          'Details :',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .color!
                                  .withOpacity(0.5),
                              fontSize: 15),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text(widget.tasks!.details.toString(),
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Row(
                      children: [
                        Text(
                          'Day of task:',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .color!
                                  .withOpacity(0.5),
                              fontSize: 15),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(widget.tasks!.dayOfTask.toString(),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Row(
                      children: [
                        Text(
                          'User Name:',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .color!
                                  .withOpacity(0.5),
                              fontSize: 15),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(widget.tasks!.user!.fullName.toString(),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Row(
                      children: [
                        Text(
                          'User Email:',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .color!
                                  .withOpacity(0.5),
                              fontSize: 15),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(widget.tasks!.user!.email.toString(),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Row(
                      children: [
                        Text(
                          'User Phone:',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .color!
                                  .withOpacity(0.5),
                              fontSize: 15),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(widget.tasks!.user!.phone.toString(),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  ])),
        ));
  }
}
