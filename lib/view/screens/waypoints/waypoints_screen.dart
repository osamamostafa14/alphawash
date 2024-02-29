import 'package:alphawash/data/model/response/user_area_model.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/screens/users/area/update_areas_screen.dart';
import 'package:alphawash/view/screens/waypoints/add_waypoint_screen.dart';
import 'package:alphawash/view/screens/waypoints/edit/edit_waypoint_screen.dart';
import 'package:alphawash/view/screens/waypoints/edit/waypoint_tab_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WayPointsScreen extends StatefulWidget {
  @override
  _WayPointsScreenState createState() => _WayPointsScreenState();
}

class _WayPointsScreenState extends State<WayPointsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
      return Scaffold(
          key: _scaffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              locationProvider.resetWaypointInfo();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddWaypointScreen()));
            },
            tooltip: 'Add',
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title: const Text('Waypoints',
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
          body: Column(
            children: [
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
                        child: locationProvider.waypointsListLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor)))
                            : locationProvider.waypoints.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Center(
                                        child: Text('No saved waypoints yet')),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListView.builder(
                                        padding: const EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_SMALL),
                                        itemCount:
                                            locationProvider.waypoints.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          WaypointModel _waypoint =
                                              locationProvider.waypoints[index];
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  locationProvider
                                                      .setSearchedArea(
                                                          _waypoint.area!);

                                                  locationProvider
                                                      .initPinPoints(context,
                                                          _waypoint, true);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              WaypointTabScreen(
                                                                  waypoint:
                                                                      _waypoint)));
                                                },
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 8),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            '${_waypoint.name}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                        Text(
                                                            '${_waypoint.area!.name}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black45,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal)),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    const Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.black54),
                                                  ],
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 6, bottom: 6),
                                                child: Divider(),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ));
    });
  }
}
