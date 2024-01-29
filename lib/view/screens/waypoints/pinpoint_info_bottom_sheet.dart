import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/view/base/border_button.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/screens/waypoints/pinpoint_screens/list_pinpoint_tasks_screen.dart';
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
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Last Task on this Pinpoint",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Icon(Icons.close),
                                          )
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

                                      Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                                '${Provider.of<SplashProvider>(
                                                  context,
                                                ).baseUrls!.taskImageUrl}/${pinPointModel!.lastTask!.image}',
                                                width: 300,
                                                height: 200,
                                                fit: BoxFit.cover)),
                                      ),

                                      const SizedBox(height: 20),

                                      Text('Task Details: ',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .color,
                                              fontSize: 15)),

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
                                          Provider.of<WorkerProvider>(context, listen: false).getAdminTasksList(context, pinPointId!);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PinPointsTasksScreen(
                                                user: null,
                                                pinPoint: pinPointModel,
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
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 18)
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 10),
                                      CustomButton(
                                          btnTxt: 'Remove',
                                          height: 38,
                                          backgroundColor: Colors.red,
                                          onTap: () {
                                            // Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('If you remove the pin that will delete all tasks on it too.',textAlign:TextAlign.justify  ,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.red,fontWeight: FontWeight.w300,
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
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "You don't have tasks yet in this pinpoint",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    CustomButton(
                                        btnTxt: 'Ok',
                                        height: 38,
                                        onTap: () {
                                          Navigator.pop(context);
                                        }),
                                    CustomButton(
                                        btnTxt: 'Remove',
                                        height: 38,
                                        backgroundColor: Colors.red,
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Are you sure?',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 15)),
                                                content: const Text(
                                                    'Do you want to remove this pin?',
                                                    style: TextStyle(
                                                        fontSize: 13)),
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
                                                        BorderButton(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          btnTxt: 'No',
                                                          borderColor:
                                                              Colors.black26,
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        BorderButton(
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
                                                          btnTxt: 'Yes',
                                                          borderColor:
                                                              Colors.black26,
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
