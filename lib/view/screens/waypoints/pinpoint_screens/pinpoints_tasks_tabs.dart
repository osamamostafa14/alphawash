import 'dart:async';
import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_pinpoint_task_screen.dart';
import 'list_pinpoint_tasks_screen.dart';

class PinpointsTasksScreen extends StatefulWidget {
  final PinPointModel? pinPoint;

  PinpointsTasksScreen({@required this.pinPoint});

  @override
  _PinpointsTasksScreenState createState() => _PinpointsTasksScreenState();
}

class _PinpointsTasksScreenState extends State<PinpointsTasksScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Timer(const Duration(seconds: 1), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Theme.of(context).primaryColor,
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 1170,
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).textTheme.bodyText1!.color,
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 3,
                unselectedLabelStyle: rubikRegular.copyWith(
                  color: ColorResources.COLOR_HINT,
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                ),
                labelStyle: rubikMedium.copyWith(
                  fontSize: Dimensions.FONT_SIZE_SMALL,
                ),
                tabs: [
                  Tab(text: 'Add New Tasks'),
                  Tab(text: 'All Pinpoints Tasks'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AddPinpointTaskScreen(
                  pinPoint: widget.pinPoint!,
                  user: Provider.of<ProfileProvider>(context, listen: false)
                      .userInfoModel!
                      .id,
                ),
                PinPointsTasksScreen(
                  user: Provider.of<ProfileProvider>(context, listen: false)
                      .userInfoModel!
                      .id,
                  pinPoint: widget.pinPoint!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
