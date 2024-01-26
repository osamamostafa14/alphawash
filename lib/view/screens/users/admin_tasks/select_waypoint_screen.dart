import 'dart:async';
import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/utill/dimensions.dart';

class SelectWaypointScreen extends StatefulWidget {
  @override
  State<SelectWaypointScreen> createState() => _SelectWaypointScreenState();
}

class _SelectWaypointScreenState extends State<SelectWaypointScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      Provider.of<LocationProvider>(context, listen: false)
          .getWaypointsList(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text('Select WayPoint',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () => Navigator.pop(context)),
      ),
      key: _scaffoldKey,
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return SafeArea(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                physics: const BouncingScrollPhysics(),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(

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
                                          Row(
                                            children: [
                                              const SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('${_waypoint.name}',
                                                      style: const TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ],
                                              ),
                                              const Spacer(),
                                              Checkbox(
                                                value: _waypoint.id == locationProvider.selectedWaypointId,
                                                onChanged: (value) {
                                                  int? id = _waypoint.id;
                                                  locationProvider.setSelectedWaypointId(id!);
                                                  print(_waypoint.id);
                                                  Navigator.pop(context, _waypoint);
                                                },
                                              )
                                            ],
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
          );
        },
      ),
    );
  }
}
