import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/screens/waypoints/pinpoint_screens/worker_pinpoints_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkerWayPointsScreen extends StatefulWidget {
  @override
  _WorkerWayPointsScreenState createState() => _WorkerWayPointsScreenState();
}

class _WorkerWayPointsScreenState extends State<WorkerWayPointsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    //  Timer(const Duration(seconds: 1), () {
    // int? userId = Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.id;
    Provider.of<LocationProvider>(context, listen: false).workerWaypoints;
    // .where((element) => userId==element.userId);
    //  });
    super.initState();
  }

  String getTodayDayName() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
       List<WorkerWaypointModel> filteredWaypoints;
          int todayDay = DateTime.now().day;

          locationProvider.showFilteredWaypoints
          ? filteredWaypoints = locationProvider.workerWaypoints
              .where((waypoint) =>
          waypoint.wayPoint?.day == todayDay)
              .toList()
              : filteredWaypoints = locationProvider.workerWaypoints;

          return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('Your Waypoints',
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
                        child: locationProvider.workerWaypointsListLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor)))
                            : locationProvider.workerWaypoints.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Center(
                                        child: Text('No  waypoints yet')),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MaterialButton(
                                        color: Theme.of(context).primaryColor,
                                        child: Text(
                                          locationProvider.showFilteredWaypoints
                                              ? "Back"
                                              : "Today Waypoints",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: locationProvider
                                            .changeFilteredWaypoints,
                                      ),

                                      locationProvider.showFilteredWaypoints
                                          ? ListView.builder(
                                              padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              itemCount:
                                                  filteredWaypoints.length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                WorkerWaypointModel _waypoint =
                                                    filteredWaypoints[index];

                                                return Column(
                                                  children: [
                                                    MaterialButton(
                                                      height: 50,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                WorkerPinpointsScreen(
                                                              workerWaypoint:
                                                                  _waypoint,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                              width: 8),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '${_waypoint.wayPoint!.name}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          const Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(),
                                                  ],
                                                );
                                              },
                                            )
                                          : ListView.builder(
                                              padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              itemCount: locationProvider
                                                  .workerWaypoints.length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                WorkerWaypointModel _waypoint =
                                                    locationProvider
                                                        .workerWaypoints[index];

                                                return Column(
                                                  children: [
                                                    MaterialButton(
                                                      height: 50,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                WorkerPinpointsScreen(
                                                              workerWaypoint:
                                                                  _waypoint,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                              width: 8),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '${_waypoint.wayPoint!.name}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          const Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(),
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
