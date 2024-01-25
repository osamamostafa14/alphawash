import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/view/screens/waypoints/pinpoint_screens/pinpoints_tasks_tabs.dart';
import 'package:flutter/material.dart';
import 'package:alphawash/view/base/border_button.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

import '../../../../data/model/response/waypoint_model.dart';

class WorkerPinpointsScreen extends StatefulWidget {
  final WorkerWaypointModel? workerWaypoint;
  WorkerPinpointsScreen({@required this.workerWaypoint});

  @override
  _WorkerPinpointsScreenState createState() => _WorkerPinpointsScreenState();
}

class _WorkerPinpointsScreenState extends State<WorkerPinpointsScreen> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return
      Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Worker Pins'),
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
                centerTitle: true,
                actions: [
                  InkWell(
                    onTap: () {
                      locationProvider.setSatelliteMode();
                    },
                    child: Center(child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(locationProvider.satelliteMode? 'Normal Mode': 'Satellite Mode', style: TextStyle(fontSize: 14)),
                    )),
                  )
                ],
              ),
              body: Center(
                child: Container(
                  width: 1170,
                  child: Consumer<LocationProvider>(
                    builder: (context, locationProvider, child) {
                      List<Marker> markers = [];

                      if (widget.workerWaypoint != null &&
                          widget.workerWaypoint!.wayPoint != null &&
                          widget.workerWaypoint!.wayPoint!.pinPoints != null &&
                          widget.workerWaypoint!.wayPoint!.pinPoints!.isNotEmpty) {
                        markers =
                            widget.workerWaypoint!.wayPoint!.pinPoints!.map((pinPoint) {
                              LatLng point = LatLng(
                                double.parse(pinPoint.latitude!),
                                double.parse(pinPoint.longitude!),
                              );

                              return Marker(
                                markerId: MarkerId(pinPoint.id.toString()),
                                position: point,
                                onTap: () {
                                  print(pinPoint.id);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PinpointsTasksScreen(pinPoint: pinPoint)));
                                },
                              );
                            }).toList();
                      }

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GoogleMap(
                            mapType: locationProvider.satelliteMode? MapType.satellite: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: markers.isNotEmpty
                                  ? markers[0].position
                                  : LatLng(0, 0), // Provide a default position
                              zoom: 15,
                            ),
                            markers: Set<Marker>.of(markers),
                            onMapCreated: (GoogleMapController controller) {
                              _controller = controller;
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          });

  }
}
