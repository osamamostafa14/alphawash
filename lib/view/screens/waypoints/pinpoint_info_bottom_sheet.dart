import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/view/base/border_button.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/screens/waypoints/pinpoint_screens/add_pinpoint_task_screen.dart';
import 'package:alphawash/view/screens/waypoints/pinpoint_screens/list_pinpoint_tasks_screen.dart';
import 'package:alphawash/view/screens/waypoints/pinpoint_screens/pinpoints_tasks_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/utill/dimensions.dart';

import '../../../provider/location_provider.dart';

class PinpointInfoBottomSheet extends StatelessWidget {
  final PinPointModel? pinPointModel;

  PinpointInfoBottomSheet({
    @required this.pinPointModel,
  });
  @override
  Widget build(BuildContext? context) {
    return Consumer<WorkerProvider>(builder: (context, workerProvider, child) {
      // final tasks = workerProvider.tasks;
      // final lastTask = tasks.isNotEmpty ? tasks[0] : null;
      return Stack(
        children: [
          workerProvider.workerOldTasksListLoading
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)))
              : Container(
                  width: 550,
                  padding:
                      const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                      physics: BouncingScrollPhysics(),
                      child: Center(
                        child: SizedBox(
                          width: 1170,
                          child: pinPointModel!.lastTask != null
                              ? Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Task Pinpoint",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            // textAlign: TextAlign.center,
                                          ),
                                          const Spacer(),
                                          // InkWell(
                                          //   onTap: () {
                                          //     Navigator.of(context).pop();
                                          //   },
                                          //   child: const Icon(Icons.close),
                                          // )
                                        ],
                                      ),

                                      const SizedBox(height: 20),

                                      // Text(
                                      //     'Task Image: ',
                                      //     style: TextStyle(
                                      //         color: Theme.of(
                                      //             context)
                                      //             .textTheme
                                      //             .headline1!
                                      //             .color,
                                      //         fontSize: 15)),
                                      //
                                      // const SizedBox(height: 7),

                                      Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[400]!,
                                                spreadRadius: 0,
                                                blurRadius: 1.2,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            // border:
                                            //     Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                                child: Image.network(
                                                    '${Provider.of<SplashProvider>(
                                                      context,
                                                    ).baseUrls!.taskImageUrl}/${pinPointModel!.lastTask!.image}',
                                                    width: 150,
                                                    height: 150,
                                                    fit: BoxFit.cover)),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      Text('Task Details: ',
                                          style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),

                                      const SizedBox(height: 7),

                                      Text(
                                        pinPointModel!.lastTask!.details
                                            .toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 16,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          int? pinPointId = pinPointModel!.id;
                                          Provider.of<WorkerProvider>(context,
                                                  listen: false)
                                              .getAdminTasksList(
                                                  context, pinPointId!);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PinPointsTasksScreen(
                                                user: null,
                                                pinPoint: pinPointModel,
                                                admin: true,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Show all tasks',
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(width: 10),
                                            Icon(Icons.arrow_forward_ios,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 12)
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 10),
                                      CustomButton(
                                          fromPinPointPage: true,
                                          btnTxt: 'Remove',
                                          height: 45,
                                          backgroundColor: Colors.red,
                                          onTap: () {
                                            // Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'If you remove the pin that will delete all tasks on it too.',
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 15)),
                                                  // content: const Text(
                                                  //     'If you remove the pin that will delete all tasks on it too . ',
                                                  //     style: TextStyle(
                                                  //         fontSize: 13)),
                                                  actions: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: BorderButton(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              btnTxt: 'Cancel',
                                                              borderColor:
                                                                  Colors
                                                                      .black26,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Expanded(
                                                            child: BorderButton(
                                                              onTap: () {
                                                                Provider.of<LocationProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .removeMarker(
                                                                        pinPointModel!
                                                                            .id
                                                                            .toString());
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              btnTxt:
                                                                  'Continue',
                                                              borderColor:
                                                                  Colors
                                                                      .black26,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                            // Provider.of<LocationProvider>(
                                            //         context,
                                            //         listen: false)
                                            //     .removeMarker(pinPointModel!.id
                                            //         .toString());
                                            // Navigator.pop(context);
                                          }),

                                      const SizedBox(height: 10),
                                      CustomButton(
                                          fromPinPointPage: true,
                                          btnTxt: 'Add new task',
                                          height: 45,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        PinpointsTasksScreen(
                                                          pinPoint:
                                                              pinPointModel,
                                                        )));
                                          }),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "You don't have tasks yet in this pinpoint",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                              fromPinPointPage: true,
                                              btnTxt: 'Ok',
                                              height: 38,
                                              onTap: () {
                                                Navigator.pop(context);
                                              }),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                            child: CustomButton(
                                                fromPinPointPage: true,
                                                btnTxt: 'Remove',
                                                height: 38,
                                                backgroundColor: Colors.red,
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Are you sure?',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: 15)),
                                                        content: const Text(
                                                            'Do you want to remove this pin?',
                                                            style: TextStyle(
                                                                fontSize: 13)),
                                                        actions: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                BorderButton(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  btnTxt: 'No',
                                                                  borderColor:
                                                                      Colors
                                                                          .black26,
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                BorderButton(
                                                                  onTap: () {
                                                                    Provider.of<LocationProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .removeMarker(pinPointModel!
                                                                            .id
                                                                            .toString());
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  btnTxt: 'Yes',
                                                                  borderColor:
                                                                      Colors
                                                                          .black26,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  // Provider.of<LocationProvider>(
                                                  //         context,
                                                  //         listen: false)
                                                  //     .removeMarker(pinPointModel!.id
                                                  //         .toString());
                                                  // Navigator.pop(context);
                                                }))
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  )),
        ],
      );
    });
  }
}
