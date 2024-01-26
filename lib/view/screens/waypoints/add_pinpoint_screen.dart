import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AddPinPointScreen extends StatefulWidget {
  final AreaModel? area;
  AddPinPointScreen({@required this.area});
  @override
  _AddPinPointScreenState createState() => _AddPinPointScreenState();
}

class _AddPinPointScreenState extends State<AddPinPointScreen> {
  GoogleMapController? _controller;
  TextEditingController _locationController = TextEditingController();
  var box = Hive.box('myBox');
  LatLng? initialPosition;
  TextEditingController? _addressController;
  TextEditingController? _areaController;

  bool _mapVisible = true;

  @override
  void initState() {
    super.initState();

    _addressController = TextEditingController();
    _areaController = TextEditingController();

    initialPosition = LatLng(double.parse(widget.area!.latitude!),
        double.parse(widget.area!.longitude!));
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Future<bool> _onWillPop() async {
    _mapVisible = false;
    setState(() {});
    if (_mapVisible == false) {
      await Future.delayed(Duration(seconds: 1));
      // Now, navigate back
      Navigator.pop(context);
    }
    return _mapVisible;
  }

  @override
  Widget build(BuildContext? context) {
    if (Provider.of<LocationProvider>(context!).address != null) {
      _locationController.text =
          '${Provider.of<LocationProvider>(context).address!.name ?? ''}, '
          '${Provider.of<LocationProvider>(context).address!.subAdministrativeArea ?? ''}, '
          '${Provider.of<LocationProvider>(context).address!.isoCountryCode ?? ''}';
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              _onWillPop();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          centerTitle: true,
          title: Text('Add/Remove pins'),
        ),
        body: !_mapVisible
            ? Center(
                child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: LoadingAnimationWidget.inkDrop(
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ),
              ))
            : Center(
                child: Container(
                  width: 1170,
                  child: Consumer<LocationProvider>(
                    builder: (context, locationProvider, child) {
                      if (_addressController!.text.isEmpty) {
                        if (locationProvider.address!.administrativeArea !=
                            null) {
                          _addressController!.text = locationProvider.address !=
                                  null
                              ? '${locationProvider.address!.administrativeArea}, ${locationProvider.address!.subAdministrativeArea}, ${locationProvider.address!.subLocality}, ${locationProvider.address!.street}'
                              : '';
                        }
                      }

                      String? lat;
                      String? lng;
                      if (Provider.of<LocationProvider>(context, listen: false)
                              .searchedLocation !=
                          null) {
                        lat = Provider.of<LocationProvider>(context,
                                listen: false)
                            .latitude
                            .toString();
                        lng = Provider.of<LocationProvider>(context,
                                listen: false)
                            .longitude
                            .toString();
                      } else {
                        lat = Provider.of<LocationProvider>(context,
                                listen: false)
                            .position!
                            .latitude
                            .toString();
                        lng = Provider.of<LocationProvider>(context,
                                listen: false)
                            .position!
                            .longitude
                            .toString();
                      }

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _mapVisible == true
                              ? GoogleMap(
                            mapType: locationProvider.satelliteMode? MapType.satellite: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                    target: initialPosition!,
                                    zoom: 8,
                                  ),
                                  zoomControlsEnabled: true,
                                  compassEnabled: false,
                                  indoorViewEnabled: true,
                                  mapToolbarEnabled: true,
                                  onTap: (LatLng tappedPoint) {
                                    // Add a new marker at the tapped location
                                    locationProvider.addMarker(
                                        context, tappedPoint, false);
                                  },
                                  markers:
                                      Set<Marker>.of(locationProvider.markers),
                                  onCameraIdle: () {
                                    locationProvider.dragableAddress();
                                  },
                                  onCameraMove: ((_position) {
                                    locationProvider.updatePosition(_position);
                                  }),
                                  // markers: Set<Marker>.of(locationProvider.markers),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller = controller;
                                    if (_controller != null) {
                                      locationProvider.getWaypointLocation(
                                          mapController: _controller,
                                          latitude: initialPosition!.latitude,
                                          longitude:
                                              initialPosition!.longitude);
                                    }
                                  },
                                )
                              : const SizedBox(),

                          locationProvider.loading
                              ? Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor)))
                              : const SizedBox(),
                        ],
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
