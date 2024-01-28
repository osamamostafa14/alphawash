import 'dart:async';

import 'package:alphawash/data/model/response/admin_task_model.dart';
import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/theme_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/view/screens/users/admin_tasks/admin_add_task_screen.dart';
import 'package:alphawash/view/screens/users/admin_tasks/task_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/utill/dimensions.dart';

class AdminTasksScreen extends StatefulWidget {
  @override
  State<AdminTasksScreen> createState() => _AdminTasksScreenState();
}

class _AdminTasksScreenState extends State<AdminTasksScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      Provider.of<LocationProvider>(context, listen: false).clearOffset();
      Provider.of<LocationProvider>(context, listen: false)
          .getTasksList(context, '1');
    });
    super.initState();
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext? context) {
    return Scaffold(
        backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Theme.of(context).primaryColor,
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (BuildContext context) => AdminAddTaskScreen()));
        //   },
        //   tooltip: 'Add',
        //   child: const Icon(
        //     Icons.add,
        //     color: Colors.white,
        //   ),
        // ),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: const Text('Tasks', style: TextStyle(color: Colors.white)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () => Navigator.pop(context)),
        ),
        body: Consumer<LocationProvider>(
            builder: (context, locationProvider, child) {
          int? tasksLength;
          int? totalSize;
          if (locationProvider.tasksList != null) {
            tasksLength = locationProvider.tasksList?.length ?? 0;
            totalSize = locationProvider.totalTasksSize ?? 0;
          }

          return Column(children: [
            Expanded(
                child: Scrollbar(
                    child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding:
                            const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: Center(
                            child: SizedBox(
                                width: 1170,
                                child: locationProvider.tasksListIsLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .primaryColor)),
                                      )
                                    : locationProvider.tasksList == null
                                        ? Center(child: Text(''))
                                        : locationProvider.tasksList!.length > 0
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                    ListView.builder(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15,
                                                              bottom: 15),
                                                      itemCount:
                                                          locationProvider
                                                              .tasksList!
                                                              .length,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index) {
                                                        PinPointsTaskModel
                                                            _tasks =
                                                            locationProvider
                                                                    .tasksList![
                                                                index];
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              TaskDetailsScreen(
                                                                        tasks:
                                                                            _tasks,
                                                                        // worker: _tasks
                                                                        //     .worker,
                                                                        // waypoint: _tasks
                                                                        //     .waypoint,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            'Pinpoint ID : ${_tasks.pinpointId}',
                                                                            style:
                                                                                const TextStyle(color: Colors.black87, fontSize: 17)),
                                                                        Text(
                                                                            '${_tasks.user!.fullName}',
                                                                            style:
                                                                                const TextStyle(color: Colors.black45, fontSize: 15)),
                                                                      ],
                                                                    ),
                                                                    const Spacer(),
                                                                    const Icon(
                                                                        Icons
                                                                            .arrow_forward_ios_rounded,
                                                                        color: Colors
                                                                            .black54,
                                                                        size:
                                                                            20)
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Divider(),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                    locationProvider
                                                            .bottomTasksListLoading
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10),
                                                            child: Center(
                                                                child: CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation<
                                                                        Color>(Theme.of(
                                                                            context)
                                                                        .primaryColor))),
                                                          )
                                                        : tasksLength! <
                                                                totalSize!
                                                            ? Center(
                                                                child:
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          String
                                                                              offset =
                                                                              locationProvider.tasksOffset ?? '';
                                                                          int offsetInt =
                                                                              int.parse(offset) + 1;
                                                                          locationProvider
                                                                              .showBottomTasksLoader();
                                                                          locationProvider.getTasksList(
                                                                              context,
                                                                              offsetInt.toString());
                                                                        },
                                                                        child: Text(
                                                                            'Load more',
                                                                            style:
                                                                                TextStyle(color: Theme.of(context).primaryColor))))
                                                            : const SizedBox()
                                                  ])
                                            : Center(
                                                child:
                                                    Text('No orders yet'))))))),
            const SizedBox(height: 15)
          ]);
        }));
  }
}
