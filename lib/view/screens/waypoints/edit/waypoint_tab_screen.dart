import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/styles.dart';
import 'package:alphawash/view/screens/waypoints/edit/edit_waypoint_screen.dart';
import 'package:alphawash/view/screens/waypoints/edit/selest_user_waypoints_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaypointTabScreen extends StatefulWidget {
  final WaypointModel? waypoint;

  WaypointTabScreen({@required this.waypoint});
  @override
  _WaypointTabScreenState createState() => _WaypointTabScreenState();
}

class _WaypointTabScreenState extends State<WaypointTabScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    // Add a listener to execute a function when the tab changes
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        // This is called when the tab is tapped
        onTabTapped(_tabController!.index);
      }
    });
  }

  // Function to be executed when a tab is tapped
  void onTabTapped(int tabIndex) {
    if (tabIndex == 0) {
      _tabIndex = 0;
    } else if (tabIndex == 1) {
      _tabIndex = 1;

      Provider.of<WorkerProvider>(context, listen: false)
          .resetSelectedUsersList();
      Provider.of<WorkerProvider>(context, listen: false)
          .getWorkersList(context)
          .then((value) {
        // has new waypoints models
        Provider.of<WorkerProvider>(context, listen: false)
            .workersList!
            .forEach((worker) {
          // loop for each worker to see if has waypoint id same as waypoint of this sreen
          worker.userWaypoints!.forEach((userWaypoint) {
            if (userWaypoint.waypointId == widget.waypoint!.id) {
              Provider.of<WorkerProvider>(context, listen: false)
                  .initSelectedUsersList(
                      userWaypoint.userId, widget.waypoint!.id);
            }
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context!).primaryColor,
        elevation: 0.0,
        title: Text('Waypoints',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.normal)),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios),
        //   color: Theme.of(context!).primaryColor,
        //   onPressed: () => Navigator.pop(context),
        // ),
        centerTitle: true,
      ),
      body: Column(children: [
        Center(
          child: Container(
            width: 1170,
            //color: Colors.white,
            child: Container(
              color: Theme.of(context).primaryColor,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                indicatorColor: Theme.of(context).primaryColor,
                indicatorWeight: 3,
                unselectedLabelStyle: rubikRegular.copyWith(
                    color: ColorResources.COLOR_HINT,
                    fontSize: Dimensions.FONT_SIZE_SMALL),
                labelStyle: rubikMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Edit'),
                  Tab(text: 'Assigned Users'),
                ],
              ),
            ),
          ),
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: [
            EditWaypointScreen(waypoint: widget.waypoint),
            SelectUserScreen(waypoint: widget.waypoint),
          ],
        )),
      ]),
    );
  }
}
