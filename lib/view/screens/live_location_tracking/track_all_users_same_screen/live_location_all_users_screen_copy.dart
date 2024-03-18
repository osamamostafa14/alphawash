
import 'dart:async';

import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class LiveLocationAdminScreen extends StatefulWidget {
  @override
  State<LiveLocationAdminScreen> createState() =>
      _LiveLocationAdminScreenState();
}

class _LiveLocationAdminScreenState extends State<LiveLocationAdminScreen> {
  late List<Marker> markers = [];
  final Completer<GoogleMapController> _controller = Completer();

  LatLng? myLocation;
  void showUserPopupMenu(BuildContext context) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('worker_locations_tracking')
        .get();
    final users = snapshot.docs
        .map((doc) => doc['name'] as String)
        .where((name) => name != null)
        .toList();

    final selectedUser = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(0, double.infinity, double.infinity, 0),
      items: users
          .map((name) => PopupMenuItem<String>(
        value: name,
        child: Text(name),
      ))
          .toList(),
    );

    if (selectedUser != null) {
      navigateToUserLocation(selectedUser, context);
    }
  }

  void navigateToUserLocation(String userName, BuildContext context) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('worker_locations_tracking')
        .where('name', isEqualTo: userName)
        .get();
    final documents = snapshot.docs;
    if (documents.isNotEmpty) {
      Provider.of<WorkerProvider>(context, listen: false)
          .getWorkersList(context);
      final document = documents.first;
      final data = document.data() as Map<String, dynamic>;
      final latitude = data['latitude'] as double;
      final longitude = data['longitude'] as double;
      final newPosition =
      CameraPosition(target: LatLng(latitude, longitude), zoom: 15);
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));

      initMarkers();
    }
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    myLocation = LatLng(position.latitude, position.longitude);
  }

  Future<void> initMarkers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('worker_locations_tracking')
        .get();

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final latitude = data['latitude'] as double;
      final longitude = data['longitude'] as double;

      final workerId = data['id'] as String;

      UserInfoModel? _user;
      bool check;
      try {
        _user = Provider.of<WorkerProvider>(context, listen: false)
            .workersList!
            .firstWhere(
              (worker) => worker.id == int.parse(workerId),
        );
        check = true;
        print('user image=> ${_user.image}');
      } catch (e) {
        check = false;
        print('no image found');
      }

      markers.add(Marker(
          markerId: MarkerId(doc.id),
          infoWindow: InfoWindow(title: data['name'] as String),
          position: LatLng(latitude, longitude),
          icon: await Container(
              height: 40,
              width: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                  ),
                  child: check == false
                      ? Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black),
                    width: 30,
                    child: Center(
                      child: Text(data['name'][0] as String,
                          style: TextStyle(
                              color: Colors.white, fontSize: 12)),
                    ),
                  )
                      : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                          placeholder: Images.profile_icon,
                          image:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.userImageUrl}/${_user!.image}',
                          height: 40,
                          width: 30,
                          fit: BoxFit.cover))))
              .toBitmapDescriptor(
              logicalSize: const Size(50, 200),
              imageSize: const Size(300, 200))));
    }
  }

  var _mapStyle;
  Future _loadMapStyles() async {
    _mapStyle = await rootBundle.loadString('assets/map/map_theme.json');
  }

  @override
  void initState() {
    super.initState();
    Provider.of<WorkerProvider>(context, listen: false).getWorkersList(context);
    _loadMapStyles();
    initMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          'Live location all users',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<void>(
          future: getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)));
            }

            if (myLocation != null) {
              markers.add(Marker(
                  markerId: MarkerId('myLocation'),
                  infoWindow: InfoWindow(title: 'My Location'),
                  position: myLocation!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed)));
            }

            return Stack(children: [
              GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: myLocation ?? LatLng(0.0, 0.0),
                    zoom: myLocation == null ? 0 : 18,
                  ),
                  markers: Set<Marker>.of(markers),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    controller.setMapStyle(_mapStyle);
                  }),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: MaterialButton(
                      height: 60,
                      minWidth: 60,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        showUserPopupMenu(context);
                      },
                      child: Icon(Icons.menu, color: Colors.white)))
            ]);
          }),
    );
  }
}
