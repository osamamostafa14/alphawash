import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/utill/styles.dart';
import 'package:alphawash/view/screens/live_location_tracking/track_all_users_same_screen/live_location_all_users_screen.dart';
import 'package:alphawash/view/screens/waypoints/edit/edit_waypoint_screen.dart';
import 'package:alphawash/view/screens/waypoints/edit/selest_user_waypoints_screen.dart';
import 'package:flutter/cupertino.dart';
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

    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        onTabTapped(_tabController!.index);
      }
    });
  }

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
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context!).primaryColor,
      //   elevation: 0.0,
      //   title: Text('Waypoints',
      //       style: TextStyle(
      //           color: Theme.of(context).primaryColor,
      //           fontWeight: FontWeight.normal)),
      //   centerTitle: true,
      // ),
      body: Column(children: [
        Container(
            decoration: BoxDecoration(color: Theme.of(context!).primaryColor),
            height: 120,
            width: double.infinity,
            child: SizedBox(
              height: 100,
              child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 45),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: 24,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 15,
                        ),
                        Image.asset(
                          Images.logo_2,
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 28,
                            )),
                      ])),
            )),
        Center(
          child: Container(
            width: 1170,
            //color: Colors.white,
            child: Container(
              color: Theme.of(context!).primaryColor,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                indicatorWeight: 2,
                unselectedLabelStyle: rubikRegular.copyWith(
                    color: ColorResources.COLOR_WHITE,
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
