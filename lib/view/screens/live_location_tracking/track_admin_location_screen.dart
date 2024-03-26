import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class TrackAdminLocationScreen extends StatefulWidget {
  @override
  State<TrackAdminLocationScreen> createState() =>
      _TrackAdminLocationScreenState();
}

class _TrackAdminLocationScreenState extends State<TrackAdminLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          'My Location',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('worker_locations_tracking')
            .doc('58') // Use targetUserId here
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          }

          Map<String, dynamic> locationData =
              snapshot.data!.data() as Map<String, dynamic>;
          double latitude = locationData['latitude'];
          double longitude = locationData['longitude'];

          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 15.0,
            ),
            markers: {
              Marker(
                onTap: () {
                  print('58');
                  print("lat : $latitude ---- long : $longitude");
                },
                markerId: MarkerId('58'),
                position: LatLng(latitude, longitude),
              ),
            },
          );
        },
      ),
    );
  }
}

class MarkerWidget extends StatelessWidget {
  const MarkerWidget({
    super.key,
    required this.image,
  });
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: AssetImage(
            image!,
          ),
          height: 100,
          width: 100,
        ),
        Icon(Icons.location_pin, color: Colors.red)
      ],
    );
  }
}

// law el admin 3auz ishof el location bta3o kman

// import 'package:alphawash/provider/profile_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
//
// class UserLocationPage extends StatefulWidget {
//   final String userId;
//   final String userName;
//
//   UserLocationPage({required this.userId, required this.userName});
//
//   @override
//   State<UserLocationPage> createState() => _UserLocationPageState();
// }
//
// class _UserLocationPageState extends State<UserLocationPage> {
//   late GoogleMapController mapController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: true,
//         title: Text(
//           'id: ${widget.userId} - name: ${widget.userName}',
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           color: Colors.white,
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('worker_locations_tracking')
//             .doc(widget.userId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//                 child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                         Theme.of(context).primaryColor)));
//           }
//
//           Map<String, dynamic> locationData =
//           snapshot.data!.data() as Map<String, dynamic>;
//           double latitude = locationData['latitude'];
//           double longitude = locationData['longitude'];
//
//           return GoogleMap(
//             mapType: MapType.normal,
//             initialCameraPosition: CameraPosition(
//               target: LatLng(latitude, longitude),
//               zoom: 15.0,
//             ),
//             markers: {
//               Marker(
//                 markerId: MarkerId(widget.userId),
//                 position: LatLng(latitude, longitude),
//               ),
//             },
//             onMapCreated: (controller) {
//               mapController = controller;
//             },
//           );
//         },
//       ),
//       floatingActionButton:
//       Provider.of<ProfileProvider>(context).userInfoModel!.userType ==
//           'admin'
//           ? FloatingActionButton(
//         onPressed: () {
//           _navigateToLocation('58');
//         },
//         child: Icon(Icons.location_on),
//       )
//           : null,
//     );
//   }
//
//   void _navigateToLocation(String locationId) {
//     FirebaseFirestore.instance
//         .collection('worker_locations_tracking')
//         .doc(locationId)
//         .get()
//         .then((snapshot) {
//       if (snapshot.exists) {
//         Map<String, dynamic> locationData =
//         snapshot.data() as Map<String, dynamic>;
//         double latitude = locationData['latitude'];
//         double longitude = locationData['longitude'];
//
//         mapController.animateCamera(
//           CameraUpdate.newLatLng(LatLng(latitude, longitude)),
//         );
//       }
//     });
//   }
// }
//
// class MarkerWidget extends StatelessWidget {
//   const MarkerWidget({
//     super.key,
//     required this.image,
//   });
//   final String? image;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Image(
//           image: AssetImage(
//             image!,
//           ),
//           height: 100,
//           width: 100,
//         ),
//         Icon(Icons.location_pin, color: Colors.red)
//       ],
//     );
//   }
// }
