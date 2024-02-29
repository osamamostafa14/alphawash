// import 'package:alphawash/provider/splash_provider.dart';
// import 'package:alphawash/provider/worker_provider.dart';
// import 'package:alphawash/utill/images.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:provider/provider.dart';
// import 'package:alphawash/data/model/response/worker_task_model.dart';
// import 'package:alphawash/provider/location_provider.dart';
// import 'package:alphawash/view/screens/waypoints/worker-tasks/worker_task_pinpoints_tabs.dart';
//
// import 'package:widget_to_marker/widget_to_marker.dart';
//
// class WorkerTasksPinpointsScreen extends StatefulWidget {
//   final WorkerTaskModel? tasks;
//   WorkerTasksPinpointsScreen({@required this.tasks});
//
//   @override
//   _WorkerTasksPinpointsScreenState createState() =>
//       _WorkerTasksPinpointsScreenState();
// }
//
// class _WorkerTasksPinpointsScreenState
//     extends State<WorkerTasksPinpointsScreen> {
//   GoogleMapController? _controller;
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
//     if (widget.tasks != null &&
//         widget.tasks!.wayPoint != null &&
//         widget.tasks!.wayPoint!.pinPoints != null &&
//         widget.tasks!.wayPoint!.pinPoints!.isNotEmpty) {
//       markers = await Future.wait(
//           widget.tasks!.wayPoint!.pinPoints!.map((pinPoint) async {
//         LatLng point = LatLng(
//           double.parse(pinPoint.latitude!),
//           double.parse(pinPoint.longitude!),
//         );
//
//         final icon = await TextOnImage(
//           text: '${Provider.of<SplashProvider>(
//             context,
//           ).baseUrls!.taskImageUrl}/${Provider.of<WorkerProvider>(
//             context,
//           ).tasks[0].image}',
//         ).toBitmapDescriptor(
//             logicalSize: const Size(200, 200), imageSize: const Size(150, 150));
//
//         return Marker(
//           markerId: MarkerId(pinPoint.id.toString()),
//           position: point,
//           icon: icon,
//           onTap: () {
//             print(pinPoint.id);
//             showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Column(children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (BuildContext context) =>
//                                 WorkerTaskPinpointsTabs(
//                               pinPoint: pinPoint,
//                               tasks: widget.tasks,
//                             ),
//                           ),
//                         );
//                         Navigator.pop(context);
//                       },
//                       child: Text('Add new task ?',
//                           style: TextStyle(
//                               color: Theme.of(context).primaryColor,
//                               fontSize: 15)),
//                     ),
//                     Divider(),
//                     TextButton(
//                       onPressed: () {
//                         launchMap(pinPoint.latitude!, pinPoint.longitude!);
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         'Go to this pinpoint ?',
//                         style: TextStyle(
//                           color: Theme.of(context).primaryColor,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ]),
//                 );
//               },
//             );
//           },
//         );
//       }));
//     }
//
//     return markers;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LocationProvider>(
//       builder: (context, locationProvider, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text('Worker Pins'),
//             backgroundColor: Theme.of(context).primaryColor,
//             elevation: 0,
//             centerTitle: true,
//             actions: [
//               InkWell(
//                 onTap: () {
//                   locationProvider.setSatelliteMode();
//                 },
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 10),
//                     child: Text(
//                         locationProvider.satelliteMode
//                             ? 'Normal Mode'
//                             : 'Satellite Mode',
//                         style: TextStyle(fontSize: 14)),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           body: Center(
//             child: Container(
//               width: 1170,
//               child: FutureBuilder(
//                 future: _createMarkers(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                         child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                                 Theme.of(context).primaryColor)));
//                   } else if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   } else {
//                     List<Marker> markers = snapshot.data as List<Marker>;
//                     return GoogleMap(
//                       mapType: locationProvider.satelliteMode
//                           ? MapType.satellite
//                           : MapType.normal,
//                       initialCameraPosition: CameraPosition(
//                         target: markers.isNotEmpty
//                             ? markers[0].position
//                             : LatLng(0, 0), // Provide a default position
//                         zoom: 15,
//                       ),
//                       markers: Set<Marker>.of(markers),
//                       onMapCreated: (GoogleMapController controller) {
//                         _controller = controller;
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class TextOnImage extends StatelessWidget {
//   const TextOnImage({
//     Key? key,
//     required this.text,
//   }) : super(key: key);
//
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: FadeInImage.assetNetwork(
//               height: 80,
//               width: 100,
//               placeholder: Images.placeholder,
//               image: text,
//               fit: BoxFit.cover,
//             )),
//         Icon(
//           Icons.location_on,
//           color: Colors.red,
//         )
//       ],
//     );
//   }
// }
import 'dart:async';

import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/screens/waypoints/worker-tasks/worker_task_pinpoints_tabs.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/data/model/response/worker_task_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class WorkerTasksPinpointsScreen extends StatefulWidget {
  final WorkerTaskModel? tasks;
  WorkerTasksPinpointsScreen({@required this.tasks});

  @override
  _WorkerTasksPinpointsScreenState createState() =>
      _WorkerTasksPinpointsScreenState();
}

class _WorkerTasksPinpointsScreenState
    extends State<WorkerTasksPinpointsScreen> {
  GoogleMapController? _controller;

  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
     setState(() {

     });
    });
  }

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

    if (widget.tasks != null &&
        widget.tasks!.wayPoint != null &&
        widget.tasks!.wayPoint!.pinPoints != null &&
        widget.tasks!.wayPoint!.pinPoints!.isNotEmpty) {
      markers = await Future.wait(
          widget.tasks!.wayPoint!.pinPoints!.map((pinPoint) async {
        LatLng point = LatLng(
          double.parse(pinPoint.latitude!),
          double.parse(pinPoint.longitude!),
        );
        // Provider.of<WorkerProvider>(context, listen: false)
        //     .getOldTasks(context, pinPointId!);
        // final oldTasks =
        //     await Provider.of<WorkerProvider>(context, listen: false).tasks;
        // final filteredTasks =
        //     oldTasks.where((task) => task.pinpointId == pinPoint.id).toList();

        final icon = pinPoint.lastTask !=null
            ? await TextOnImage(
                image:
                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.taskImageUrl}/${pinPoint.lastTask!.image}',
              ).toBitmapDescriptor(
                logicalSize: const Size(300 , 200),
                imageSize: const Size(300, 200),
              )
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
                  title: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  WorkerTaskPinpointsTabs(
                                pinPoint: pinPoint,
                                tasks: widget.tasks,
                              ),
                            ),
                          );
                          // Navigator.pop(context);
                        },
                        child: Text('Add new task ?',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15)),
                      ),
                      Divider(),
                      TextButton(
                        onPressed: () {
                          launchMap(pinPoint.latitude!, pinPoint.longitude!);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Go to this pinpoint ?',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      }));
    }

    return markers;
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
                        style: TextStyle(fontSize: 14)),
                  ),
                ),
              )
            ],
          ),
          body: Center(
            child: Container(
              width: 1170,
              child: FutureBuilder(
                future: _createMarkers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                        target: markers.isNotEmpty
                            ? markers[0].position
                            : LatLng(0, 0),
                        zoom: 15,
                      ),
                      markers: Set<Marker>.of(markers),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class TextOnImage extends StatelessWidget {
  const TextOnImage({
    Key? key,
    @required this.image,
  }) : super(key: key);

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage.assetNetwork(
          height: 120 , width: 110,
            placeholder: Images.placeholder,
            image: image!,
            fit: BoxFit.cover,
          ),
        ),
        Icon(
          Icons.location_on,
          color: Colors.red,size:80
        )
      ],
    );
  }
}
