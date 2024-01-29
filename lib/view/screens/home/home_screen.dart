import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/base/home_button_widget.dart';
import 'package:alphawash/view/screens/live_location_tracking/live_location_List_Screen.dart';
import 'package:alphawash/view/screens/location/areas_list_screen.dart';
import 'package:alphawash/view/screens/report/task_updates_screen.dart';
import 'package:alphawash/view/screens/users/admin_tasks/admin_task_screen.dart';
import 'package:alphawash/view/screens/waypoints/edit/waypoint_tab_screen.dart';
import 'package:alphawash/view/screens/waypoints/waypoints_screen.dart';
import 'package:alphawash/view/screens/users/users_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/utill/dimensions.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  @override
  @override
  Widget build(BuildContext? context) {
    return Consumer2<CustomerAuthProvider, LocationProvider>(
      builder: (context, authProvider, locationProvider, child) {
        return Scaffold(
            drawer: Drawer(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: locationProvider.areasListLoading ||
                                locationProvider.areasList == null
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 200),
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor)),
                                ),
                              )
                            : locationProvider.areasList!.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 300),
                                    child: Center(
                                        child: Text('No saved areas yet')),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 70),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12),
                                        child: Text(
                                          "Areas",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 180, left: 12, bottom: 10),
                                        child: Divider(
                                            thickness: 2,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        itemCount:
                                            locationProvider.areasList!.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          AreaModel _area = locationProvider
                                              .areasList![index];
                                          return Column(
                                            children: [
                                              ExpansionTile(
                                                title: Text(
                                                  '${_area.name}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                children: [
                                                  if (locationProvider.waypoints
                                                      .any((waypoint) =>
                                                          waypoint.area!.name ==
                                                          _area.name))
                                                    ListView.builder(
                                                      itemCount:
                                                          locationProvider
                                                              .waypoints.length,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      itemBuilder:
                                                          (context, index) {
                                                        WaypointModel
                                                            _waypoints =
                                                            locationProvider
                                                                    .waypoints[
                                                                index];
                                                        return _area.name ==
                                                                _waypoints
                                                                    .area!.name
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            25,
                                                                        right:
                                                                            25),
                                                                child: Column(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        locationProvider
                                                                            .setSearchedArea(_waypoints.area!);
                                                                        locationProvider.initPinPoints(
                                                                            context,
                                                                            _waypoints,
                                                                            true);
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (BuildContext context) => WaypointTabScreen(waypoint: _waypoints)));
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                            '${_waypoints.name}',
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: 'Roboto',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 14.0,
                                                                              color: Colors.black54,
                                                                            ),
                                                                          ),
                                                                          const Spacer(),

                                                                          Text(
                                                                              'Show',
                                                                              style: TextStyle(color: Theme.of(context).primaryColor)),

                                                                          // Icon(Icons.arrow_forward_ios_rounded, size: 15)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            20)
                                                                  ],
                                                                ),
                                                              )
                                                            : SizedBox();
                                                      },
                                                    )
                                                  else
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'No waypoints in this area yet',
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
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
            ),
            key: _scaffoldKey,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                Provider.of<LocationProvider>(context, listen: false)
                    .getWaypointsList(context);
                Provider.of<LocationProvider>(context, listen: false)
                    .getAreasList(context);
                _scaffoldKey.currentState!.openDrawer();
              },
              tooltip: 'Area',
              child: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(Images.logo_2, height: 80),
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Provider.of<ProfileProvider>(context, listen: false)
                                .userInfoModel!
                                .image !=
                            null
                        ? FadeInImage.assetNetwork(
                            placeholder: Images.profile_icon,
                            image: '${Provider.of<SplashProvider>(
                              context,
                            ).baseUrls!.userImageUrl}/${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.image}',
                            height: 45,
                            width: 45,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 45,
                            width: 45,
                            child: Icon(Icons.person,
                                size: 30, color: Colors.black54)),
                  ),
                  //Text('Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                ],
              ),
              // centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF063261),
              elevation: 0.5,

              toolbarHeight: 100.0,
            ),
            body: SafeArea(
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: SizedBox(
                      width: 1170,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: HomeButton(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                UsersScreen()));
                                  },
                                  icon: Icons.supervised_user_circle,
                                  text: 'Users',
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: HomeButton(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AreasListScreen()));
                                  },
                                  icon: Icons.map,
                                  text: 'Areas',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: HomeButton(
                                  onTap: () {
                                    Provider.of<LocationProvider>(context,
                                            listen: false)
                                        .getWaypointsList(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                WayPointsScreen()));
                                  },
                                  icon: Icons.pin_drop_outlined,
                                  text: 'Waypoints',
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: HomeButton(
                                  onTap: () {
                                    final profile =
                                        Provider.of<ProfileProvider>(context,
                                            listen: false);
                                    print(profile.userInfoModel!.id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LiveLocationWorkerListScreen()),
                                    );
                                  },
                                  icon: Icons.location_searching_rounded,
                                  text: 'Track Workers',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: HomeButton(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AdminTasksScreen()));
                                  },
                                  icon: Icons.task,
                                  text: 'Tasks',
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: HomeButton(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TaskUpdatesScreen()),
                                    );
                                  },
                                  icon: Icons.analytics,
                                  text: 'Reports',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
