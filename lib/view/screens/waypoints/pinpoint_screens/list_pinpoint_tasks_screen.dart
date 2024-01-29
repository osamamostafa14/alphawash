import 'dart:async';
import 'dart:math';

import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/data/model/response/worker_task_model.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/screens/waypoints/pinpoint_screens/pinpoint_task_details_screen.dart';
import 'package:alphawash/view/screens/waypoints/worker-tasks/edit_worker_pinpoint_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/utill/dimensions.dart';

class PinPointsTasksScreen extends StatefulWidget {
  PinPointModel? pinPoint;
  //final WorkerTaskModel? tasks;
  int? user;

  PinPointsTasksScreen(
      {@required this.user, @required this.pinPoint});

  @override
  State<PinPointsTasksScreen> createState() => _PinPointsTasksScreenState();
}

class _PinPointsTasksScreenState extends State<PinPointsTasksScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 0), () {
      int? pinPointId = widget.pinPoint!.id;
      Provider.of<ProfileProvider>(context, listen: false)
                  .userInfoModel
                  ?.userType ==
              'admin'
          ? Provider.of<WorkerProvider>(context, listen: false)
              .getAdminTasksList(context, pinPointId!)
          : Provider.of<WorkerProvider>(context, listen: false)
              .getOldTasks(context, pinPointId!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
        appBar: Provider.of<ProfileProvider>(context!, listen: false)
                    .userInfoModel
                    ?.userType ==
                'admin'
            ? AppBar(
                title: Text('Pin Point Tasks',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                centerTitle: true,
                elevation: 0.2,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => Navigator.pop(context),
                ),
              )
            : PreferredSize(
                preferredSize: Size.fromHeight(0.0),
                child: SizedBox(),
              ),
        body:
            Consumer<WorkerProvider>(builder: (context, workerProvider, child) {
          bool hasPermissions = false;
          if (Provider.of<ProfileProvider>(context).userInfoModel!.userType ==
              'admin') {
            hasPermissions = true;
          } else {
            if (Provider.of<ProfileProvider>(context)
                    .userInfoModel!
                    .workerPermissions !=
                null) {
              if (Provider.of<ProfileProvider>(context)
                      .userInfoModel!
                      .workerPermissions!
                      .showPinpoints ==
                  1) {
                hasPermissions = true;
              } else {
                hasPermissions = false;
              }
            }
          }

          return !hasPermissions
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Text(
                      "You don't have any permission to show tasks.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline2!.color,
                          fontSize: 16),
                    ),
                  ),
                )
              : Scrollbar(
                  child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                      child: SizedBox(
                          width: 1170,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (Provider.of<ProfileProvider>(context!,
                                                    listen: false)
                                                .userInfoModel
                                                ?.userType ==
                                            'admin'
                                        ? workerProvider
                                            .workerOldAdminTasksListLoading
                                        : workerProvider
                                            .workerOldTasksListLoading)
                                    ? Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .primaryColor)))
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: Provider.of<ProfileProvider>(
                                                        context!,
                                                        listen: false)
                                                    .userInfoModel
                                                    ?.userType ==
                                                'admin'
                                            ? workerProvider.adminTasks.length
                                            : workerProvider.tasks.length,
                                        itemBuilder: (_, index) {
                                          final task =
                                              Provider.of<ProfileProvider>(
                                                              context!,
                                                              listen: false)
                                                          .userInfoModel
                                                          ?.userType ==
                                                      'admin'
                                                  ? workerProvider
                                                      .adminTasks[index]
                                                  : workerProvider.tasks[index];
                                          print(
                                              'url=> ${Provider.of<SplashProvider>(
                                            context,
                                          ).baseUrls!.taskImageUrl}/${task.image}');

                                          // Provider.of<SplashProvider>(context,).baseUrls.taskImageUrl
                                          // https://agreements.winji.org/storage/app/public/task/2024-01-01-659295a99b130.png
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            EditPinPointTasksDetailsScreen(
                                                              imageUrl: task
                                                                  .image
                                                                  .toString(),
                                                              details: task
                                                                  .details
                                                                  .toString(),
                                                              task: task,
                                                            )));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 2,
                                                      offset: const Offset(0,
                                                          1), // changes position of shadow
                                                    ),
                                                  ],
                                                  // border: Border.all(width: 1, color: borderColor!),
                                                ),
                                                child: Row(children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        height: 80,
                                                        width: 100,
                                                        placeholder:
                                                            Images.placeholder,
                                                        image:
                                                            '${Provider.of<SplashProvider>(
                                                          context,
                                                        ).baseUrls!.taskImageUrl}/${task.image}',
                                                        fit: BoxFit.cover,
                                                      )),
                                                  const SizedBox(width: 15),
                                                  Container(
                                                    child: Expanded(
                                                      child: Text(
                                                          task.details
                                                              .toString(),
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis)),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  const Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      color: Colors.black54,
                                                      size: 20),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ]))),
                ));
        }));
  }
}
