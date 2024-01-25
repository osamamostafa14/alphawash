import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class UserLocationPage extends StatelessWidget {
  final String userId;
  final String userName;

  UserLocationPage({required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text('id: $userId - name: $userName',
              style: TextStyle(color: Colors.white)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () => Navigator.pop(context)),
        ),
        body: UserLocationMap(userId));
  }
}

Widget UserLocationMap(String userId) {


  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('worker_locations_tracking')
        .doc(userId)
        .snapshots(),
    builder: (context, snapshot)  {
      if (!snapshot.hasData) {
        return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor)));
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
                print(userId);
              },
              markerId: MarkerId(userId),
              position: LatLng(latitude, longitude)),
        },
      );
    },
  );
}

class MarkerWidget extends StatelessWidget {
  const MarkerWidget({
    super.key,
    required this.image,
  });
  final String? image;
  @override
  Widget build(BuildContext context) {
    return
      Column(
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
