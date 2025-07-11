import 'dart:async';
import 'dart:async';

import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/base/border_button.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/screens/waypoints/edit/edit_waypoint_screen.dart';
import 'package:alphawash/view/screens/waypoints/pinpoint_info_bottom_sheet.dart';
import 'package:alphawash/view/screens/waypoints/pinpoint_screens/list_pinpoint_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../../../../data/model/response/waypoint_model.dart';

class AddAndPressPinPointScreen extends StatefulWidget {
  final WaypointModel? waypoint;

  AddAndPressPinPointScreen({
    @required this.waypoint,
  });

  @override
  _AddAndPressPinPointScreenState createState() =>
      _AddAndPressPinPointScreenState();
}

class _AddAndPressPinPointScreenState extends State<AddAndPressPinPointScreen> {
  GoogleMapController? _controller;

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      // Provider.of<WorkerProvider>(context, listen: false)
      //     .getOldTasks(context, 43!);

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WorkerProvider, LocationProvider>(
      builder: (context, workerProvider, locationProvider, child) {
        Set<Marker> markers = {};

        if (widget.waypoint != null &&
            widget.waypoint!.pinPoints != null &&
            widget.waypoint!.pinPoints!.isNotEmpty) {
          markers.addAll(widget.waypoint!.pinPoints!.map((pinPoint) {
            LatLng point = LatLng(
              double.parse(pinPoint.latitude!),
              double.parse(pinPoint.longitude!),
            );

            return Marker(
              markerId: MarkerId(pinPoint.id.toString()),
              position: point,
              onTap: () {
                print('bottom sheet');

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (con) {

                    return PinpointInfoBottomSheet(
                      pinPointModel: pinPoint,
                      locationProvider: locationProvider,

                    );
                  },
                );
              },

              // onTap: () {
              //   workerProvider.getOldTasks(context, pinPoint.id!);
              //   showModalBottomSheet(
              //     context: context,
              //     isScrollControlled: true,
              //     backgroundColor: Colors.transparent,
              //     builder: (con) {
              //       return PinpointInfoBottomSheet(
              //         pinPointModel: pinPoint,
              //         locationProvider: locationProvider, // Pass the locationProvider instance
              //       );
              //     },
              //   );
              //
              // },
            );
          }));
        }

        markers.addAll(locationProvider.markers);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Worker Pins',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            centerTitle: true,
            actions: [
              InkWell(
                onTap: () {
                  locationProvider.setSatelliteMode();
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      locationProvider.satelliteMode
                          ? 'Normal Mode'
                          : 'Satellite Mode',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              )
            ],
          ),
          body: Center(
            child: Container(
              width: 1170,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GoogleMap(
                    mapType: locationProvider.satelliteMode
                        ? MapType.satellite
                        : MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: markers.isNotEmpty
                          ? markers.first.position
                          : LatLng(0, 0),
                      zoom: 15,
                    ),
                    onTap: (LatLng tappedPoint) {
                      locationProvider.addMarker(context, tappedPoint, false);
                    },
                    markers: markers,
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
