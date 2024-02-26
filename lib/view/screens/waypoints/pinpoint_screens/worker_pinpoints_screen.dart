// import 'dart:async';
//
// import 'package:alphawash/data/model/response/waypoint_model.dart';
// import 'package:alphawash/provider/profile_provider.dart';
// import 'package:alphawash/provider/splash_provider.dart';
// import 'package:alphawash/provider/worker_provider.dart';
// import 'package:alphawash/utill/images.dart';
// import 'package:alphawash/view/base/custom_marker.dart';
// import 'package:alphawash/view/screens/waypoints/worker-tasks/worker_task_pinpoints_tabs.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:provider/provider.dart';
// import 'package:alphawash/data/model/response/worker_task_model.dart';
// import 'package:alphawash/provider/location_provider.dart';
// import 'package:widget_to_marker/widget_to_marker.dart';
//
// class WorkerPinpointsScreen extends StatefulWidget {
//   final WorkerWaypointModel? workerWaypoint;
//   WorkerPinpointsScreen({@required this.workerWaypoint});
//
//   @override
//   _WorkerPinpointsScreenState createState() => _WorkerPinpointsScreenState();
// }
//
// class _WorkerPinpointsScreenState extends State<WorkerPinpointsScreen> {
//   GoogleMapController? _controller;
//
//   // @override
//   // void initState() {
//   //   Timer(const Duration(seconds: 2), () {
//   //     Provider.of<WorkerProvider>(context, listen: false).workerTasks;
//   //   });
//   //   super.initState();
//   // }
//
//   Future<void> launchMap(String latitude, String longitude) async {
//     final url =
//         'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   Future<List<Marker>> _createMarkers() async {
//     List<Marker> markers = [];
//
//     if (widget.workerWaypoint != null &&
//         widget.workerWaypoint!.wayPoint != null &&
//         widget.workerWaypoint!.wayPoint!.pinPoints != null &&
//         widget.workerWaypoint!.wayPoint!.pinPoints!.isNotEmpty) {
//       markers = await Future.wait(
//           widget.workerWaypoint!.wayPoint!.pinPoints!.map((pinPoint) async {
//         LatLng point = LatLng(double.parse(pinPoint.latitude!),
//             double.parse(pinPoint.longitude!));
//
//         final icon = pinPoint.lastTask != null
//             ? await CustomMarker(
//                 image:
//                     '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.taskImageUrl}/${pinPoint.lastTask!.image}',
//               ).toBitmapDescriptor(
//                 logicalSize: const Size(300, 200),
//                 imageSize: const Size(300, 200))
//             : await BitmapDescriptor.defaultMarker;
//         return Marker(
//             markerId: MarkerId(pinPoint.id.toString()),
//             position: point,
//             icon: icon,
//             onTap: () {
//               print(pinPoint.id);
//               showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                         title: Column(children: [
//                       TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (BuildContext context) =>
//                                         WorkerTaskPinpointsTabs(
//                                             pinPoint: pinPoint)));
//                             // Navigator.pop(context);
//                           },
//                           child: Text('Add new task ?',
//                               style: TextStyle(
//                                   color: Theme.of(context).primaryColor,
//                                   fontSize: 15))),
//                       Divider(),
//                       TextButton(
//                           onPressed: () {
//                             launchMap(pinPoint.latitude!, pinPoint.longitude!);
//                             Navigator.pop(context);
//                           },
//                           child: Text('Go to this pinpoint ?',
//                               style: TextStyle(
//                                   color: Theme.of(context).primaryColor,
//                                   fontSize: 15)))
//                     ]));
//                   });
//             });
//       }));
//     }
//
//     return markers;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LocationProvider>(
//         builder: (context, locationProvider, child) {
//       return Scaffold(
//           appBar: AppBar(
//               title: Text('Worker Pins'),
//               backgroundColor: Theme.of(context).primaryColor,
//               elevation: 0,
//               centerTitle: true,
//               actions: [
//                 InkWell(
//                     onTap: () => locationProvider.setSatelliteMode(),
//                     child: Center(
//                         child: Padding(
//                             padding: const EdgeInsets.only(right: 10),
//                             child: Text(
//                                 locationProvider.satelliteMode
//                                     ? 'Normal Mode'
//                                     : 'Satellite Mode',
//                                 style: TextStyle(fontSize: 14)))))
//               ]),
//           body: Center(
//               child: Container(
//                   width: 1170,
//                   child: FutureBuilder(
//                       future: _createMarkers(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(
//                               child: CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                       Theme.of(context).primaryColor)));
//                         } else if (snapshot.hasError) {
//                           print("Error: ${snapshot.error}");
//                           return Text('Error: ${snapshot.error}');
//                         } else {
//                           List<Marker> markers = snapshot.data as List<Marker>;
//                           return GoogleMap(
//                               mapType: locationProvider.satelliteMode
//                                   ? MapType.satellite
//                                   : MapType.normal,
//                               initialCameraPosition: CameraPosition(
//                                   target: markers.isNotEmpty
//                                       ? markers[0].position
//                                       : LatLng(0, 0),
//                                   zoom: 15),
//                               markers: Set<Marker>.of(markers),
//                               onMapCreated: (GoogleMapController controller) =>
//                                   _controller = controller);
//                         }
//                       }))));
//     });
//   }
// }
import 'dart:async';

import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/base/custom_marker.dart';
import 'package:alphawash/view/screens/waypoints/worker-tasks/worker_task_pinpoints_tabs.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/data/model/response/worker_task_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class WorkerPinpointsScreen extends StatefulWidget {
  final WorkerWaypointModel? workerWaypoint;
  WorkerPinpointsScreen({@required this.workerWaypoint});

  @override
  _WorkerPinpointsScreenState createState() => _WorkerPinpointsScreenState();
}

class _WorkerPinpointsScreenState extends State<WorkerPinpointsScreen> {
  GoogleMapController? _controller;

  Future<void> launchMap(String latitude, String longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<Marker>> _createMarkers() async {
    List<Marker> markers = [];

    if (widget.workerWaypoint != null &&
        widget.workerWaypoint!.wayPoint != null &&
        widget.workerWaypoint!.wayPoint!.pinPoints != null &&
        widget.workerWaypoint!.wayPoint!.pinPoints!.isNotEmpty) {
      markers = await Future.wait(
          widget.workerWaypoint!.wayPoint!.pinPoints!.map((pinPoint) async {
        LatLng point = LatLng(double.parse(pinPoint.latitude!),
            double.parse(pinPoint.longitude!));

        final icon = pinPoint.lastTask != null
            ? await CustomMarker(
                image:
                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.taskImageUrl}/${pinPoint.lastTask!.image}',
              ).toBitmapDescriptor(
                logicalSize: const Size(300, 200),
                imageSize: const Size(300, 200))
            : await BitmapDescriptor.defaultMarker;
        return Marker(
            markerId: MarkerId(pinPoint.id.toString()),
            position: point,
            icon: icon,
            onTap: () {
              print(pinPoint.id);
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Column(children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        WorkerTaskPinpointsTabs(
                                            pinPoint: pinPoint)));
                            // Navigator.pop(context);
                          },
                          child: Text('Add new task ?',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15))),
                      Divider(),
                      TextButton(
                          onPressed: () {
                            launchMap(pinPoint.latitude!, pinPoint.longitude!);
                            Navigator.pop(context);
                          },
                          child: Text('Go to this pinpoint ?',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15)))
                    ]));
                  });
            });
      }));
    }

    return markers;
  }

  LatLngBounds _editZoom(List<Marker> markers) {
    double minLat = markers[0].position.latitude;
    double maxLat = markers[0].position.latitude;
    double minLng = markers[0].position.longitude;
    double maxLng = markers[0].position.longitude;

    for (Marker marker in markers) {
      if (marker.position.latitude < minLat) {
        minLat = marker.position.latitude;
      }
      if (marker.position.latitude > maxLat) {
        maxLat = marker.position.latitude;
      }
      if (marker.position.longitude < minLng) {
        minLng = marker.position.longitude;
      }
      if (marker.position.longitude > maxLng) {
        maxLng = marker.position.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
      return Scaffold(
          appBar: AppBar(
              title: Text('Worker Pins'),
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              centerTitle: true,
              actions: [
                InkWell(
                    onTap: () => locationProvider.setSatelliteMode(),
                    child: Center(
                        child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                                locationProvider.satelliteMode
                                    ? 'Normal Mode'
                                    : 'Satellite Mode',
                                style: TextStyle(fontSize: 14)))))
              ]),
          body: Center(
              child: Container(
                  width: 1170,
                  child: FutureBuilder(
                      future: _createMarkers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)));
                        } else if (snapshot.hasError) {
                          print("Error: ${snapshot.error}");
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Marker> markers = snapshot.data as List<Marker>;
                          return GoogleMap(
                            mapType: locationProvider.satelliteMode
                                ? MapType.satellite
                                : MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(0, 0),
                              zoom: 15,
                            ),
                            markers: Set<Marker>.of(markers),
                            onMapCreated: (GoogleMapController controller) {
                              _controller = controller;

                              if (markers.isNotEmpty) {
                                LatLngBounds bounds = _editZoom(markers);

                                _controller!.animateCamera(
                                  CameraUpdate.newLatLngBounds(bounds, 50),
                                );
                              }
                            },
                          );
                        }
                      }))));
    });
  }
}
