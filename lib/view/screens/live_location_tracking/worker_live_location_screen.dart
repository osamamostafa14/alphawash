// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:geolocator/geolocator.dart';
// //
// // class LiveTrackingScreen extends StatefulWidget {
// //   @override
// //   _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
// // }
// //
// // class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
// //   Completer<GoogleMapController> _controller = Completer();
// //   late Marker _marker;
// //   late Position _currentPosition;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _getCurrentLocation();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text('Live Tracking'),
// //             Text(
// //               'Latitude: ${_currentPosition.latitude}, Longitude: ${_currentPosition.longitude}',
// //               style: TextStyle(fontSize: 12),
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: GoogleMap(
// //         mapType: locationProvider.satelliteMode? MapType.satellite: MapType.normal,
// //         initialCameraPosition: CameraPosition(
// //           target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
// //           zoom: 15.0,
// //         ),
// //         onMapCreated: (GoogleMapController controller) {
// //           _controller.complete(controller);
// //         },
// //         markers: {_marker},
// //       ),
// //     );
// //   }
// //
// //   // Function to get the current location
// //   _getCurrentLocation() async {
// //     Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);
// //     setState(() {
// //       _currentPosition = position;
// //       // Initialize marker with the current position
// //       _marker = Marker(
// //         markerId: MarkerId("worker"),
// //         position: LatLng(position.latitude, position.longitude),
// //       );
// //     });
// //     _startLocationUpdate();
// //   }
// //
// //   // Function to update the marker position every 5 seconds
// //   _startLocationUpdate() {
// //     Timer.periodic(Duration(seconds: 5), (timer) async {
// //       Position newPosition = await Geolocator.getCurrentPosition(
// //           desiredAccuracy: LocationAccuracy.high);
// //
// //       // Update marker position and animate the camera to the new position
// //       setState(() {
// //         _marker = _marker.copyWith(
// //           positionParam: LatLng(newPosition.latitude, newPosition.longitude),
// //         );
// //
// //         // Move camera to the new position
// //         _moveCamera(LatLng(newPosition.latitude, newPosition.longitude));
// //
// //         // Update the current position
// //         _currentPosition = newPosition;
// //
// //         // Print the updated latitude and longitude
// //         print('Latitude: ${newPosition.latitude}, Longitude: ${newPosition.longitude}');
// //       });
// //     });
// //   }
// //
// //   // Function to move the camera to a specific position
// //   Future<void> _moveCamera(LatLng position) async {
// //     final GoogleMapController controller = await _controller.future;
// //     controller.animateCamera(CameraUpdate.newLatLng(position));
// //   }
// // }
//
// import 'dart:async';
// import 'package:alphawash/data/model/response/user_info_model.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class LiveTrackingScreen extends StatefulWidget {
//   final UserInfoModel? user;
//
//   LiveTrackingScreen({required this.user});
//
//   @override
//   _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
// }
//
// class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
//   Completer<GoogleMapController> _controller = Completer();
//   late Marker _marker;
//   Position? _currentPosition;
//   late CollectionReference _workerLocations;
//
//   @override
//   void initState() {
//     super.initState();
//     _workerLocations =
//         FirebaseFirestore.instance.collection('worker_locations_tracking');
//     _getCurrentLocation();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: true,
//         title:
//             const Text('Live Tracking', style: TextStyle(color: Colors.white)),
//         leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios),
//             color: Colors.white,
//             onPressed: () => Navigator.pop(context)),
//       ),
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: CameraPosition(
//             target: _currentPosition != null
//                 ? LatLng(
//                     _currentPosition!.latitude, _currentPosition!.longitude)
//                 : LatLng(0, 0),
//             zoom: 15.0),
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//         markers: _currentPosition != null ? {_marker} : {},
//       ),
//     );
//   }
//
//   /// bgib elv current location
//   _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       setState(() {
//         _currentPosition = position;
//         _marker = Marker(
//           markerId: MarkerId("worker"),
//           position: LatLng(position.latitude, position.longitude),
//         );
//       });
//
//       _startLocationUpdate();
//     } on Exception catch (e) {
//       print('Error getting current location: $e');
//     }
//   }
//
//   /// kol 10 swany el location bi3ml update
//   _startLocationUpdate() {
//     Timer.periodic(Duration(seconds: 10), (timer) async {
//       Position newPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       setState(() {
//         _marker = _marker.copyWith(
//             positionParam: LatLng(newPosition.latitude, newPosition.longitude));
//
//         _moveCamera(LatLng(newPosition.latitude, newPosition.longitude));
//
//         _currentPosition = newPosition;
//
//         print(
//             'Latitude: ${newPosition.latitude}, Longitude: ${newPosition.longitude}');
//
//         _updateOnFireStore(
//           widget.user!.id.toString(),
//           widget.user!.fullName.toString(),
//           newPosition.latitude,
//           newPosition.longitude,
//         );
//       });
//     });
//   }
//
//   /// el camera position bt3ml update
//   Future<void> _moveCamera(LatLng position) async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newLatLng(position));
//   }
//
//   /// bib3t el data el gdida kol shoia ll firebase
//   void _updateOnFireStore(
//     String userId,
//     String userName,
//     double latitude,
//     double longitude,
//   ) {
//     _workerLocations.doc(userId).set({
//       'name': userName,
//       'latitude': latitude,
//       'longitude': longitude,
//       'timestamp': FieldValue.serverTimestamp(),
//     }).then((value) {
//       print('Worker location updated in Firestore');
//     }).catchError((error) {
//       print('Error updating worker location: $error');
//     });
//   }
// }
