import 'dart:async';

import 'package:alphawash/data/model/response/worker_task_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/base/border_button.dart';
import 'package:alphawash/view/base/home_button_widget.dart';
import 'package:alphawash/view/screens/waypoints/waypoints_screen.dart';
import 'package:alphawash/view/screens/waypoints/worker-tasks/worker_tasks_screen.dart';
import 'package:alphawash/view/worker-screens/area/worker_areas_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/screens/live_location_tracking/worker_live_location_screen.dart';

import '../../screens/waypoints/worker_waypoints_screen.dart';

class WorkerHomeScreen extends StatefulWidget {
  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      Provider.of<WorkerProvider>(context, listen: false).getReminder(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(Images.logo_2, height: 80),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Provider.of<ProfileProvider>(context, listen: false)
                          .userInfoModel!
                          .image !=
                      null
                  ? FadeInImage.assetNetwork(
                      placeholder: Images.profile_icon,
                      image: '${Provider.of<SplashProvider>(
                        context,
                      ).baseUrls!.userImageUrl}/${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.image}',
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 45,
                      width: 45,
                      child:
                          Icon(Icons.person, size: 30, color: Colors.black54)),
            ),
            //Text('Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
          ],
        ),
        // centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF063261),
        elevation: 0.5,

        toolbarHeight: 100.0,
      ),
      body: Consumer2<CustomerAuthProvider, ProfileProvider>(
        builder:
            (context, authProvider, profileProvider , child) {


          return SafeArea(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                          ),
                        ),
                        if (profileProvider
                                    .userInfoModel!.workerPermissions?.area ==
                                1 ||
                            profileProvider.userInfoModel!.workerPermissions
                                    ?.waypoints ==
                                1)
                          Row(
                            children: [
                              profileProvider.userInfoModel!.workerPermissions
                                          ?.area ==
                                      1
                                  ? Expanded(
                                      child: HomeButton(
                                        onTap: () async {


                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          WorkerAreasScreen()))
                                              ;

                                          // workerProvider.reminder.isNotEmpty
                                          //     ? showDialog(
                                          //         context: context,
                                          //         builder: (context) {
                                          //           return Dialog(
                                          //             insetPadding:
                                          //                 EdgeInsets.symmetric(
                                          //                     horizontal: 10),
                                          //             child: Padding(
                                          //               padding:
                                          //                   const EdgeInsets
                                          //                       .all(10.0),
                                          //               child: Column(
                                          //                   crossAxisAlignment:
                                          //                       CrossAxisAlignment
                                          //                           .start,
                                          //                   mainAxisSize:
                                          //                       MainAxisSize
                                          //                           .min,
                                          //                   children: [
                                          //                     Padding(
                                          //                       padding:
                                          //                           const EdgeInsets
                                          //                               .all(
                                          //                               10.0),
                                          //                       child: Text(
                                          //                           'You have ${workerProvider.reminder.length} pinpointed areas where you haven\'t taken any action.',
                                          //                           style: TextStyle(
                                          //                               color: Theme.of(context)
                                          //                                   .primaryColor,
                                          //                               fontSize:
                                          //                                   15)),
                                          //                     ),
                                          //                     Divider(),
                                          //                     ListView.builder(
                                          //                       itemCount:
                                          //                           workerProvider
                                          //                               .reminder!
                                          //                               .length,
                                          //                       physics:
                                          //                           const NeverScrollableScrollPhysics(),
                                          //                       shrinkWrap:
                                          //                           true,
                                          //                       itemBuilder:
                                          //                           (context,
                                          //                               index) {
                                          //                         ReminderModel
                                          //                             _reminder =
                                          //                             workerProvider
                                          //                                     .reminder![
                                          //                                 index];
                                          //                         return Column(
                                          //                           children: [
                                          //                             Container(
                                          //                               decoration: BoxDecoration(
                                          //                                   borderRadius: BorderRadius.circular(
                                          //                                     10,
                                          //                                   ),
                                          //                                   color: Colors.white),
                                          //                               child:
                                          //                                   Padding(
                                          //                                 padding: const EdgeInsets
                                          //                                     .all(
                                          //                                     10.0),
                                          //                                 child:
                                          //                                     Column(
                                          //                                   children: [
                                          //                                     Row(children: [
                                          //                                       Text("Pinpoint ID :", style: TextStyle(fontSize: 16)),
                                          //                                       SizedBox(
                                          //                                         width: 10,
                                          //                                       ),
                                          //                                       Text(_reminder.pinpointId.toString(), style: TextStyle(fontSize: 14)),
                                          //                                     ]),
                                          //                                     Row(children: [
                                          //                                       Text("Pinpoint Task Day :", style: TextStyle(fontSize: 16)),
                                          //                                       SizedBox(
                                          //                                         width: 10,
                                          //                                       ),
                                          //                                       Text(_reminder.dayOfTask.toString(), style: TextStyle(fontSize: 14)),
                                          //                                     ]),
                                          //                                   ],
                                          //                                 ),
                                          //                               ),
                                          //                             ),
                                          //                             SizedBox(
                                          //                               height:
                                          //                                   15,
                                          //                             ),
                                          //                           ],
                                          //                         );
                                          //                       },
                                          //                     ),
                                          //                     SizedBox(
                                          //                       height: 10,
                                          //                     ),
                                          //                     Padding(
                                          //                       padding:
                                          //                           const EdgeInsets
                                          //                               .only(
                                          //                               bottom:
                                          //                                   10),
                                          //                       child: Row(
                                          //                         mainAxisAlignment:
                                          //                             MainAxisAlignment
                                          //                                 .center,
                                          //                         children: [
                                          //                           BorderButton(
                                          //                             onTap:
                                          //                                 () {
                                          //                               Navigator.push(
                                          //                                   context,
                                          //                                   MaterialPageRoute(
                                          //                                       builder: (BuildContext context) => WorkerAreasScreen())).then((value) =>
                                          //                                   Navigator.pop(context));
                                          //                             },
                                          //                             btnTxt:
                                          //                                 'Ok',
                                          //                             borderColor:
                                          //                                 Colors
                                          //                                     .black26,
                                          //                           ),
                                          //                         ],
                                          //                       ),
                                          //                     ),
                                          //                   ]),
                                          //             ),
                                          //           );
                                          //         },
                                          //       )
                                          //     : Navigator.push(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //             builder: (BuildContext
                                          //                     context) =>
                                          //                 WorkerAreasScreen()));
                                        },
                                        icon: Icons.map,
                                        text: 'Areas',
                                      ),
                                    )
                                  : SizedBox(),
                              profileProvider.userInfoModel!.workerPermissions
                                          ?.area ==
                                      1
                                  ? const SizedBox(width: 20)
                                  : SizedBox(),
                              profileProvider.userInfoModel!.workerPermissions
                                          ?.waypoints ==
                                      1
                                  ? Expanded(
                                      child: HomeButton(
                                        onTap: () {
                                          Provider.of<LocationProvider>(context,
                                                  listen: false)
                                              .getWorkerWaypointsList(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      WorkerWayPointsScreen()));
                                        },
                                        icon: Icons.pin_drop_outlined,
                                        text: 'Waypoints',
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        const SizedBox(height: 20),
                        // Row(
                        //   children: [
                        //     profileProvider.userInfoModel!.workerPermissions
                        //                 ?.tasks ==
                        //             1
                        //         ? Expanded(
                        //             child: HomeButton(
                        //               onTap: () {
                        //                 Provider.of<WorkerProvider>(context,
                        //                         listen: false)
                        //                     .getWorkerTasksList(context);
                        //                 Navigator.push(
                        //                     context,
                        //                     MaterialPageRoute(
                        //                         builder:
                        //                             (BuildContext context) =>
                        //                                 WorkerTaskScreen()));
                        //               },
                        //               icon: Icons.task,
                        //               text: 'Tasks',
                        //             ),
                        //           )
                        //         : const SizedBox(),
                        //
                        //     profileProvider.userInfoModel!.workerPermissions
                        //                 ?.tasks ==
                        //             1
                        //         ? const SizedBox(width: 20)
                        //         : const SizedBox(),
                        //
                        //   ],
                        // ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
