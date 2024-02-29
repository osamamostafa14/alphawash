import 'dart:async';
import 'dart:async';

import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/base/border_button.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/screens/waypoints/pinpoint_screens/list_pinpoint_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../../../../data/model/response/waypoint_model.dart';

class AddAndPressPinPointScreen extends StatefulWidget {
  final WaypointModel? waypoint;

  AddAndPressPinPointScreen({
    @required this.waypoint,
  });

  @override
  _AddAndPressPinPointScreenState createState() =>
      _AddAndPressPinPointScreenState();
}

class _AddAndPressPinPointScreenState extends State<AddAndPressPinPointScreen> {
  GoogleMapController? _controller;

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      // Provider.of<WorkerProvider>(context, listen: false)
      //     .getOldTasks(context, 43!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Consumer2<WorkerProvider, LocationProvider>(
        builder: (context, workerProvider, locationProvider, child) {
          List<Marker> markers = [];

          if (widget.waypoint != null &&
              widget.waypoint!.pinPoints != null &&
              widget.waypoint!.pinPoints!.isNotEmpty) {
            markers = widget.waypoint!.pinPoints!.map((pinPoint) {
              LatLng point = LatLng(double.parse(pinPoint.latitude!),
                  double.parse(pinPoint.longitude!));

              return Marker(
                markerId: MarkerId(pinPoint.id.toString()),
                position: point,
                onTap: () {
                  Timer(const Duration(seconds: 2), () {
                    if (workerProvider.workerOldTasksListLoading) {
                      Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor)));
                    }

                    int? pinPointId = pinPoint.id;
                    final tasks = workerProvider.tasks;

                    tasks.forEach((task) {
                      print('Task pinpoint ID: ${task.pinpointId}');
                    });

                    print('pinpoint : ${pinPointId}');
                    workerProvider.getOldTasks(context, pinPointId!);
                  });

                  final tasks = workerProvider.tasks;
                  // .where((taskId) => taskId.pinpointId == pinPoint.id)
                  // .toList();
                  final lastTask = tasks.isNotEmpty ? tasks[0] : null;

                  workerProvider.workerOldTasksListLoading
                      ? Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)))
                      : lastTask != null
                      ? showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: EdgeInsets.all(10),
                        child: Container(
                          width: 400,
                          height: 460,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  "Last Task on this Pinpoint",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Align(
                                        child: Text(
                                            'Image Task : ',
                                            style: TextStyle(
                                                color: Theme.of(
                                                    context)
                                                    .textTheme
                                                    .headline1!
                                                    .color,
                                                fontSize: 15)),
                                        alignment:
                                        Alignment.centerLeft,
                                      ),
                                      const SizedBox(
                                          height: Dimensions
                                              .PADDING_SIZE_SMALL),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                              Colors.black),
                                          borderRadius:
                                          BorderRadius
                                              .circular(10),
                                        ),
                                        child: ClipRRect(
                                            borderRadius:
                                            BorderRadius
                                                .circular(10),
                                            child: Image.network(
                                                '${Provider.of<SplashProvider>(
                                                  context,
                                                ).baseUrls!.taskImageUrl}/${lastTask.image}',
                                                width: 300,
                                                height: 200,
                                                fit: BoxFit
                                                    .cover)),
                                      ),
                                      SizedBox(height: 5),
                                      Align(
                                        child: Text(
                                            'Details Task : ',
                                            style: TextStyle(
                                                color: Theme.of(
                                                    context)
                                                    .textTheme
                                                    .headline1!
                                                    .color,
                                                fontSize: 15)),
                                        alignment:
                                        Alignment.centerLeft,
                                      ),
                                      const SizedBox(
                                          height: Dimensions
                                              .PADDING_SIZE_SMALL),
                                      Container(
                                        width: 300,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                              Colors.black),
                                          borderRadius:
                                          BorderRadius
                                              .circular(10),
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(5.0),
                                          child: Text(
                                            lastTask.details
                                                .toString(),
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.black,
                                              overflow:
                                              TextOverflow
                                                  .ellipsis,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 80,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft:
                                    Radius.circular(20),
                                    bottomRight:
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 5, top: 5),
                                  child: Column(
                                    children: [
                                      Text(
                                          "Did you need see all tasks on this point ? ",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color:
                                              Colors.white)),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: MaterialButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                    context) =>
                                                        PinPointsTasksScreen(
                                                          user: null,
                                                          pinPoint: PinPointModel(
                                                              id: pinPoint
                                                                  .id),
                                                        ),
                                                  ),
                                                );
                                                print(PinPointModel(
                                                    id: pinPoint
                                                        .id));
                                              },
                                              color: Colors.white,
                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    40),
                                              ),
                                              child: Text(
                                                "Yes",
                                                style: TextStyle(
                                                  color: Theme.of(
                                                      context)
                                                      .primaryColor,
                                                  // fontWeight: FontWeight.bold,
                                                  // fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: MaterialButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context);
                                              },
                                              shape:
                                              RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors
                                                        .white),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    40),
                                              ),
                                              child: Text(
                                                "No",
                                                style: TextStyle(
                                                  color: Colors
                                                      .white,
                                                  // fontWeight: FontWeight.bold,
                                                  // fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                          child: Container(
                              width: double.infinity,
                              height: 200,
                              child: Center(
                                  child: Column(children: [
                                    Expanded(
                                        child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: [
                                              Text(
                                                "Don't have tasks yet in this pinpoint",
                                                style: TextStyle(
                                                    fontSize: 16),
                                              )
                                            ])),
                                    Container(
                                        height: 80,
                                        width: double.infinity,
                                        child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                bottom: 10),
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .end,
                                                children: [
                                                  const SizedBox(
                                                      width: 10),
                                                  Expanded(
                                                      child:
                                                      MaterialButton(
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(
                                                                  40)),
                                                          onPressed:
                                                              () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                              "Ok",
                                                              style:
                                                              TextStyle(color: Colors.white)))),
                                                  const SizedBox(
                                                      width: 10),
                                                ])),
                                        decoration: BoxDecoration(
                                          // color: Theme.of(context)
                                          //     .primaryColor,
                                            borderRadius:
                                            BorderRadiusDirectional.only(
                                                bottomStart:
                                                Radius
                                                    .circular(
                                                    28),
                                                bottomEnd: Radius
                                                    .circular(
                                                    28))))
                                  ]))),
                          insetPadding: EdgeInsets.all(10));
                    },
                  );
                },
              );
            }).toList();
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Worker Pins',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              centerTitle: true,
              actions: [
                InkWell(
                  onTap: () {
                    locationProvider.setSatelliteMode();
                  },
                  child: Center(child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(locationProvider.satelliteMode? 'Normal Mode': 'Satellite Mode', style: TextStyle(fontSize: 14)),
                  )),
                )
              ],
            ),
            body: Center(
              child: Container(
                width: 1170,
                child:
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GoogleMap(
                      mapType: locationProvider.satelliteMode? MapType.satellite: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: markers.isNotEmpty
                            ? markers[0].position
                            : LatLng(0, 0),
                        zoom: 15,
                      ),
                      markers: Set<Marker>.of(markers),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });

  }
}
