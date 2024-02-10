import 'package:alphawash/data/helper/area_boundaries.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/base/marker_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class AllAreasMap extends StatefulWidget {
  @override
  _AllAreasMapState createState() => _AllAreasMapState();
}

class _AllAreasMapState extends State<AllAreasMap> {
  GoogleMapController? _controller;
  LatLng? initialPosition;

  List<Polygon> polygons = [];
  List<Marker> polygonMarkers = [];

  @override
  void initState() {
    super.initState();

    initialPosition = LatLng(33.46482215398303, -86.81724015623331);

    List<String> areas = [
      'pelham',
      'alabaster',
      'chelsea',
      'calera',
      'helena',
      'columbiana',
      'indian springs',
      'meadowbrook',
      'hoover',
      'vestavia hills',
      'mountain brook',
      'homewood',
      'birmingham'
    ];

    areas.forEach((area) async {
      List<LatLng> polygonPoints = AreaBoundaries.getPolygonPoints(area);
      polygons.add(Polygon(
        polygonId: PolygonId(area),
        points: polygonPoints,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeWidth: 3,
        strokeColor: Colors.blue,
      ));

      LatLng center = _calculatePolygonCenter(polygonPoints);

      BitmapDescriptor markerIcon =
          await MarkerText(text: area).toBitmapDescriptor(
        logicalSize: const Size(500, 500),
        // imageSize: const Size(300, 200),
      );

      polygonMarkers.add(Marker(
        markerId: MarkerId(area),
        position: center,
        icon: markerIcon,
        infoWindow: InfoWindow(
            title: area,
            onTap: () {
              print(area);
            }),
      ));
    });
  }

  LatLng _calculatePolygonCenter(List<LatLng> polygonPoints) {
    double latitude = 0;
    double longitude = 0;

    for (LatLng point in polygonPoints) {
      latitude += point.latitude;
      longitude += point.longitude;
    }

    latitude /= polygonPoints.length;
    longitude /= polygonPoints.length;

    return LatLng(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: initialPosition!,
          zoom: 9.5,
        ),
        zoomControlsEnabled: true,
        compassEnabled: false,
        indoorViewEnabled: true,
        mapToolbarEnabled: true,
        polygons: Set<Polygon>.of(polygons),
        markers: Set<Marker>.of(polygonMarkers),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
// class AllAreasMap extends StatefulWidget {
//
//   @override
//   _AllAreasMapState createState() => _AllAreasMapState();
// }
//
// class _AllAreasMapState extends State<AllAreasMap> {
//   GoogleMapController? _controller;
//   TextEditingController _locationController = TextEditingController();
//   LatLng? initialPosition;
//
//   bool _mapVisible = true;
//
//
//   List<Polygon> polygons = [];
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     initialPosition =LatLng(33.46482215398303, -86.81724015623331);
//
//     List<String> _areas = ['pelham', 'alabaster', 'chelsea', 'calera', 'helena', 'columbiana', 'indian springs', 'meadowbrook', 'hoover', 'vestavia hills', 'mountain brook', 'homewood', 'birmingham'];
//
//    // polygonPoints.addAll(AreaBoundaries.getPolygonPoints(Provider.of<LocationProvider>(context, listen: false).areaName!));
//
//     _areas.forEach((area) {
//       List<LatLng> polygonPoints = [];
//       polygonPoints = AreaBoundaries.getPolygonPoints(area);
//        polygons.add(Polygon (
//            polygonId: PolygonId("1"),
//            points: polygonPoints,
//            fillColor: Colors.blue.withOpacity(0.2),
//            strokeWidth: 3,
//            strokeColor: Colors.blue
//        ));
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller!.dispose();
//   }
//
//
//   Future<bool> _onWillPop() async {
//     _mapVisible = false;
//     setState(() {});
//     if(_mapVisible == false){
//       await Future.delayed(Duration(seconds: 1));
//       // Now, navigate back
//       Navigator.pop(context);
//     }
//     return _mapVisible;
//   }
//
//
//
//   @override
//   Widget build(BuildContext? context) {
//     if (Provider.of<LocationProvider>(context!).address != null) {
//       _locationController.text = '${Provider.of<LocationProvider>(context).address!.name ?? ''}, '
//           '${Provider.of<LocationProvider>(context).address!.subAdministrativeArea ?? ''}, '
//           '${Provider.of<LocationProvider>(context).address!.isoCountryCode ?? ''}';
//     }
//
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child:
//       Consumer<LocationProvider>(
//         builder: (context, locationProvider, child) {
//           return Scaffold(
//             appBar: AppBar(
//               backgroundColor: Theme.of(context).primaryColor,
//               elevation: 0,
//               leading: IconButton(
//                 onPressed: () {
//
//                   _onWillPop();
//                 },
//                 icon: Icon(Icons.arrow_back, color: Colors.white),
//               ),
//               centerTitle: true,
//               actions: [
//                 InkWell(
//                   onTap: () {
//                     locationProvider.setSatelliteMode();
//                   },
//                   child: Center(child: Padding(
//                     padding: const EdgeInsets.only(right: 10),
//                     child: Text(locationProvider.satelliteMode? 'Normal Mode': 'Satellite Mode', style: TextStyle(fontSize: 14)),
//                   )),
//                 )
//               ],
//               // title: Text('Update area'),
//             ),
//             body:
//             !_mapVisible? Center(child: Padding(
//               padding: const EdgeInsets.only(top: 50),
//               child: LoadingAnimationWidget.inkDrop(
//                 color: Theme.of(context).primaryColor,
//                 size: 30,
//               ),
//             )):
//             Center(
//               child: Container(
//                 width: 1170,
//                 child: Stack(
//                   clipBehavior: Clip.none, children: [
//                   _mapVisible == true?
//                   GoogleMap(
//                     mapType: locationProvider.satelliteMode? MapType.satellite: MapType.normal,
//                     initialCameraPosition: CameraPosition(
//                       target: initialPosition!,
//                       zoom: 9.5, // how to increase zoom, when i change this value nothing happen
//                     ),
//                     zoomControlsEnabled: true,
//                     compassEnabled: false,
//                     indoorViewEnabled: true,
//                     mapToolbarEnabled: true,
//                     polygons: polygons.toSet(),
//                     onTap: (LatLng tappedPoint) {
//                       // Add a new marker at the tapped location
//                       locationProvider.addMarker(context, tappedPoint, false);
//                     },
//                     onCameraIdle: () {
//                       locationProvider.dragableAddress();
//                     },
//                     onCameraMove: ((_position) => locationProvider.updatePosition(_position)),
//                     // markers: Set<Marker>.of(locationProvider.markers),
//                     onMapCreated: (GoogleMapController controller) {
//                       _controller = controller;
//
//                       // if(widget.fromAutoCompleteSearch == true){
//                       //   locationProvider.getSearchedLocation(mapController: _controller);
//                       // }else{
//                       //   locationProvider.getSavedLocation(
//                       //       _controller,
//                       //       double.parse(widget.area!.latitude!),
//                       //       double.parse(widget.area!.longitude!)
//                       //   );
//                       // }
//
//                       // if (_controller != null) {
//                       //   if(locationProvider.searchedLocation==null){
//                       //     locationProvider.getCurrentLocation(mapController: _controller);
//                       //   }else{
//                       //     locationProvider.getSearchedLocation(mapController: _controller);
//                       //     // locationProvider.getSavedLocation(mapController: _controller);
//                       //   }
//                       // }
//                     },
//                   ) : const SizedBox(),
//
//
//                   Positioned(
//                     bottom: 0,
//                     right: 100,
//                     left: 0,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             locationProvider.resetTapped();
//                           },
//                           child: Container(
//                             width: 50,
//                             height: 50,
//                             margin: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
//                               color: Colors.white,
//                             ),
//                             child: Icon(
//                               Icons.my_location,
//                               color: Theme.of(context).primaryColor,
//                               size: 35,
//                             ),
//                           ),
//                         ),
//
//                       ],
//                     ),
//                   ),
//
//                 ],
//                 ),
//               ),
//             ),
//           );
//         }),
//
//     );
//   }
// }
