import 'dart:async';

import 'package:alphawash/data/model/response/worker_task_model.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/screens/waypoints/worker-tasks/worker_task_details_pinpoints_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkerTasksDetailsScreen extends StatefulWidget {
  final WorkerTaskModel? tasks;

  const WorkerTasksDetailsScreen({super.key, required this.tasks});
  @override
  _WorkerTasksDetailsScreenState createState() =>
      _WorkerTasksDetailsScreenState();
}

class _WorkerTasksDetailsScreenState extends State<WorkerTasksDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Provider.of<WorkerProvider>(context, listen: false).workerTasks;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkerProvider>(builder: (context, workerProvider, child) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('${widget.tasks!.wayPoint!.name}',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.normal)),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Center(
                child: SizedBox(
                  width: 1170,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Waypoint Name:',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                              fontSize: 15),
                        ),
                        const SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                )),
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    widget.tasks!.wayPoint!.name.toString(),
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor,
                                    )))),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          'PinPoints:',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                              fontSize: 15),
                        ),
                        const SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                )),
                            width: double.infinity,
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        WorkerTasksPinpointsScreen(
                                      tasks: widget.tasks,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text('Check Pinpoints',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).primaryColor,
                                      )),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            )),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          'Date :',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                              fontSize: 15),
                        ),
                        const SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                )),
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(widget.tasks!.taskDate!),
                                    // widget.tasks!.waypoint!.area!.name.toString(),
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor,
                                    )))),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          'Time :',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color,
                              fontSize: 15),
                        ),
                        const SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                )),
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    DateFormat('hh:mm a')
                                        .format(widget.tasks!.taskDate!),

                                    // widget.tasks!.waypoint!.area!.name.toString(),
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).primaryColor,
                                    )))),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        widget.tasks!.taskDetails == null
                            ? SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      'Task Details :',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .color,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                        height: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadiusDirectional
                                                    .circular(10),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            )),
                                        width: double.infinity,
                                        child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                                widget.tasks!.taskDetails
                                                    .toString(),
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )))),
                                  ])
                      ]),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
