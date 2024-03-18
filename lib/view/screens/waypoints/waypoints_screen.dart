// import 'package:alphawash/data/model/response/user_area_model.dart';
// import 'package:alphawash/data/model/response/user_info_model.dart';
// import 'package:alphawash/data/model/response/waypoint_model.dart';
// import 'package:alphawash/provider/location_provider.dart';
// import 'package:alphawash/provider/profile_provider.dart';
// import 'package:alphawash/utill/dimensions.dart';
// import 'package:alphawash/view/screens/users/area/update_areas_screen.dart';
// import 'package:alphawash/view/screens/waypoints/add_waypoint_screen.dart';
// import 'package:alphawash/view/screens/waypoints/edit/edit_waypoint_screen.dart';
// import 'package:alphawash/view/screens/waypoints/edit/waypoint_tab_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class WayPointsScreen extends StatefulWidget {
//   @override
//   _WayPointsScreenState createState() => _WayPointsScreenState();
// }
//
// class _WayPointsScreenState extends State<WayPointsScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   ScrollController scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LocationProvider>(
//         builder: (context, locationProvider, child) {
//       return Scaffold(
//           key: _scaffoldKey,
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {
//               locationProvider.resetWaypointInfo();
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (BuildContext context) => AddWaypointScreen()));
//             },
//             tooltip: 'Add',
//             child: const Icon(Icons.add),
//           ),
//           appBar: AppBar(
//             title: const Text('Waypoints',
//                 style: TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.normal)),
//             centerTitle: true,
//             backgroundColor: Theme.of(context).primaryColor,
//             elevation: 0.5,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               color: Colors.white,
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                 child: Scrollbar(
//                   child: SingleChildScrollView(
//                     controller: scrollController,
//                     physics: const BouncingScrollPhysics(),
//                     padding:
//                         const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                     child: Center(
//                       child: SizedBox(
//                         width: 1170,
//                         child: locationProvider.waypointsListLoading
//                             ? Center(
//                                 child: CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Theme.of(context).primaryColor)))
//                             : locationProvider.waypoints.isEmpty
//                                 ? const Padding(
//                                     padding: EdgeInsets.only(top: 100),
//                                     child: Center(
//                                         child: Text('No saved waypoints yet')),
//                                   )
//                                 : Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       ListView.builder(
//                                         padding: const EdgeInsets.all(
//                                             Dimensions.PADDING_SIZE_SMALL),
//                                         itemCount:
//                                             locationProvider.waypoints.length,
//                                         physics:
//                                             const NeverScrollableScrollPhysics(),
//                                         shrinkWrap: true,
//                                         itemBuilder: (context, index) {
//                                           WaypointModel _waypoint =
//                                               locationProvider.waypoints[index];
//                                           return Column(
//                                             children: [
//                                               InkWell(
//                                                 onTap: () {
//                                                   locationProvider
//                                                       .setSearchedArea(
//                                                           _waypoint.area!);
//
//                                                   locationProvider
//                                                       .initPinPoints(context,
//                                                           _waypoint, true);
//                                                   Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (BuildContext
//                                                                   context) =>
//                                                               WaypointTabScreen(
//                                                                   waypoint:
//                                                                       _waypoint)));
//                                                 },
//                                                 child: Row(
//                                                   children: [
//                                                     const SizedBox(width: 8),
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text(
//                                                             '${_waypoint.name}',
//                                                             style: const TextStyle(
//                                                                 color: Colors
//                                                                     .black87,
//                                                                 fontSize: 16,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500)),
//                                                         Text(
//                                                             '${_waypoint.area!.name}',
//                                                             style: const TextStyle(
//                                                                 color: Colors
//                                                                     .black45,
//                                                                 fontSize: 16,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .normal)),
//                                                       ],
//                                                     ),
//                                                     const Spacer(),
//                                                     const Icon(
//                                                         Icons.arrow_forward_ios,
//                                                         color: Colors.black54),
//                                                   ],
//                                                 ),
//                                               ),
//                                               const Padding(
//                                                 padding: EdgeInsets.only(
//                                                     top: 6, bottom: 6),
//                                                 child: Divider(),
//                                               )
//                                             ],
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),
//             ],
//           ));
//     });
//   }
// }

import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/screens/live_location_tracking/track_all_users_same_screen/live_location_all_users_screen.dart';
import 'package:alphawash/view/screens/waypoints/add_waypoint_screen.dart';
import 'package:alphawash/view/screens/waypoints/edit/waypoint_tab_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class WayPointsScreen extends StatefulWidget {
  @override
  _WayPointsScreenState createState() => _WayPointsScreenState();
}

class _WayPointsScreenState extends State<WayPointsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _searchController;
  ScrollController scrollController = ScrollController();
  List<WaypointModel> filteredWaypointList = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredWaypointList =
        Provider.of<LocationProvider>(context, listen: false).waypoints;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterWaypoint(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredWaypointList =
            Provider.of<LocationProvider>(context, listen: false).waypoints;
      } else {
        filteredWaypointList =
            Provider.of<LocationProvider>(context, listen: false)
                .waypoints
                .where((item) =>
                    item.name!.toLowerCase().contains(query.toLowerCase()))
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
      return Scaffold(
          key: _scaffoldKey,
          floatingActionButton: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            mini: true,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              locationProvider.resetWaypointInfo();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddWaypointScreen()));
            },
            tooltip: 'Add',
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          // appBar: AppBar(
          //   title: const Text('Waypoints',
          //       style: TextStyle(
          //           color: Colors.white, fontWeight: FontWeight.normal)),
          //   centerTitle: true,
          //   backgroundColor: Theme.of(context).primaryColor,
          //   elevation: 0.5,
          //   leading: IconButton(
          //     icon: const Icon(Icons.arrow_back_ios),
          //     color: Colors.white,
          //     onPressed: () => Navigator.pop(context),
          //   ),
          // ),
          body: Column(
            children: [
              Container(
                  height: 280,
                  color: Colors.transparent,
                  child: Stack(children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        height: 250,
                        width: double.infinity,
                        child: Column(children: [
                          SizedBox(
                            height: 100,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12.0, top: 30),
                                child: Row(children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(
                                          Icons.arrow_back_ios_new_outlined,
                                          size: 16,
                                        )),
                                  ),
                                  Spacer(),
                                  Text('Way points',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18)),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LiveLocationAdminScreen())),
                                      icon: Icon(
                                        Icons.map_outlined,
                                        color: Colors.white,
                                        size: 28,
                                      )),
                                ])),
                          ),
                          Image.asset(Images.logo,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover)
                        ])),
                    Positioned(
                        bottom: 5,
                        right: MediaQuery.of(context).size.width / 15,
                        left: MediaQuery.of(context).size.width / 15,
                        child: Container(
                          width: 400,
                          height: 65,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(40)),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 22),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              width: 0,
                                              color: Colors.transparent)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              width: 0,
                                              color: Colors.transparent)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              width: 0,
                                              color: Colors.transparent)),
                                      isDense: true,
                                      prefixIcon: Icon(
                                        Icons.search_sharp,
                                        size: 25,
                                      ),
                                      hintText: 'search',
                                      fillColor: Colors.transparent,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(
                                              fontSize: 14,
                                              color: ColorResources.COLOR_BLACK,
                                              fontWeight: FontWeight.w400),
                                      filled: true,
                                    ),
                                    onChanged: (value) {
                                      filterWaypoint(value);
                                    },
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                ),
                                _searchController.text.isEmpty
                                    ? SizedBox()
                                    : Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: IconButton(
                                            onPressed: () {
                                              _searchController.clear();
                                              Provider.of<LocationProvider>(
                                                      context,
                                                      listen: false)
                                                  .getWaypointsList(context);
                                            },
                                            icon: Center(
                                              child: Icon(
                                                Icons.close,
                                                size: 16,
                                              ),
                                            )),
                                      ),
                              ],
                            ),
                          ),
                        ))
                  ])),
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
                                        itemCount: _searchController.text
                                                .toString()
                                                .isEmpty
                                            ? locationProvider.waypoints.length
                                            : filteredWaypointList.length,
                                        // itemCount:
                                        //     locationProvider.waypoints.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          WaypointModel _waypoint =
                                              _searchController.text
                                                      .toString()
                                                      .isEmpty
                                                  ? locationProvider
                                                      .waypoints[index]
                                                  : filteredWaypointList[index];
                                          // WaypointModel _waypoint =
                                          //     locationProvider.waypoints[index];
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
                                                child: Container(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Center(
                                                          child: Row(children: [
                                                        const SizedBox(
                                                            width: 8),
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
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                            Text(
                                                                '${_waypoint.area!.name}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black45,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        const Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color:
                                                                Colors.black54,
                                                            size: 16)
                                                      ]))),
                                                  height: 76,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
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
