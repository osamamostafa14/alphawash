import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:alphawash/view/base/custom_text_field.dart';
import 'package:alphawash/view/screens/location/autocomplete_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AddLocationScreen extends StatefulWidget {
  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  GoogleMapController? _controller;
  TextEditingController _locationController = TextEditingController();
  var box = Hive.box('myBox');
  double? _searchedLatitude;
  double? _searchedLongitude;
  LatLng? initialPosition;
  TextEditingController? _addressController;
  TextEditingController? _areaController;
  String? _address;

  bool _mapVisible = true;

  var _mapStyle;
  Future _loadMapStyles() async {
    _mapStyle = await rootBundle.loadString('assets/map/map_theme.json');
  }

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    _addressController = TextEditingController();
    _areaController = TextEditingController();

    if (Provider.of<LocationProvider>(context, listen: false)
            .searchedLocation !=
        null) {
      initialPosition = LatLng(
          Provider.of<LocationProvider>(context, listen: false).latitude ?? 0.0,
          Provider.of<LocationProvider>(context, listen: false).longitude ??
              0.0);
    } else {
      initialPosition = LatLng(
          Provider.of<LocationProvider>(context, listen: false)
                  .position!
                  .latitude ??
              0.0,
          Provider.of<LocationProvider>(context, listen: false)
                  .position!
                  .longitude ??
              0.0);
    }
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
          title: Text('Add new area'),
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
                                  mapType: locationProvider.satelliteMode
                                      ? MapType.satellite
                                      : MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                    target: initialPosition!,
                                    zoom: 8,
                                  ),
                                  zoomControlsEnabled: false,
                                  compassEnabled: false,
                                  indoorViewEnabled: true,
                                  mapToolbarEnabled: true,

                                  onCameraIdle: () {
                                    locationProvider.dragableAddress();
                                  },
                                  onCameraMove: ((_position) => locationProvider
                                      .updatePosition(_position)),
                                  // markers: Set<Marker>.of(locationProvider.markers),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller = controller;
                                    if (_controller != null) {
                                      if (locationProvider.searchedLocation ==
                                          null) {
                                        locationProvider.getCurrentLocation(
                                            mapController: _controller);
                                      } else {
                                        locationProvider.getSearchedLocation(
                                            mapController: _controller);
                                        // locationProvider.getSavedLocation(mapController: _controller);
                                      }
                                    }
                                    controller.setMapStyle(_mapStyle);
                                  },
                                )
                              : const SizedBox(),
                          locationProvider.address != null
                              ? InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AutocompleteSearch(
                                                    newArea: true)));
                                  },
                                  child: Container(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    // padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 18.0),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_LARGE,
                                        vertical: 23.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.PADDING_SIZE_SMALL)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              locationProvider.address!.name !=
                                                      null
                                                  ? '${locationProvider.address!.street}, ${locationProvider.address!.administrativeArea}, ${locationProvider.address!.locality}, ${locationProvider.address!.subLocality}, ${locationProvider.address!.country}'
                                                  : '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                          Text(
                                              locationProvider
                                                          .searchedLocation !=
                                                      null
                                                  ? '(${locationProvider.searchedLocation})'
                                                  : '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.black54)),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    locationProvider.getCurrentLocation(
                                        mapController: _controller);
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.only(
                                        right: Dimensions.PADDING_SIZE_LARGE),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.PADDING_SIZE_SMALL),
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      Icons.my_location,
                                      color: Theme.of(context).primaryColor,
                                      size: 35,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        // Row(
                                        //   children: [
                                        //     Expanded(
                                        //       child: CustomTextField(
                                        //         hintText: 'Address',
                                        //         isShowBorder: true,
                                        //         controller: _addressController,
                                        //         inputType: TextInputType.emailAddress,
                                        //         inputAction: TextInputAction.done,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),

                                        const SizedBox(height: 7),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomTextField(
                                                hintText: 'Name of area',
                                                isShowBorder: true,
                                                controller: _areaController,
                                                inputType: TextInputType.text,
                                                inputAction:
                                                    TextInputAction.done,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 20),

                                        locationProvider.storeAreaLoading
                                            ? Center(
                                                child: CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Theme.of(context)
                                                                .primaryColor)))
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 38),
                                                child: CustomButton(
                                                  btnTxt: 'Confirm',
                                                  onTap:
                                                      locationProvider.loading
                                                          ? null
                                                          : () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                              if (_areaController!
                                                                  .text
                                                                  .isEmpty) {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext?
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'Hint!',
                                                                          style: TextStyle(
                                                                              color: Theme.of(context!).primaryColor,
                                                                              fontSize: 15)),
                                                                      content: const Text(
                                                                          'Please fill the area name',
                                                                          style:
                                                                              TextStyle(fontSize: 13)),
                                                                    );
                                                                  },
                                                                );
                                                              } else {
                                                                locationProvider
                                                                    .storeNewArea(
                                                                        _areaController!
                                                                            .text,
                                                                        '${locationProvider.searchedLocation}, ${locationProvider.address!.administrativeArea}, ${locationProvider.address!.subAdministrativeArea}, ${locationProvider.address!.subLocality}, ${locationProvider.address!.street}',
                                                                        locationProvider
                                                                            .position!
                                                                            .latitude
                                                                            .toString(),
                                                                        locationProvider
                                                                            .position!
                                                                            .longitude
                                                                            .toString())
                                                                    .then(
                                                                        (value) {
                                                                  if (value
                                                                      .isSuccess) {
                                                                    showCustomSnackBar(
                                                                        'Area added successfully',
                                                                        context,
                                                                        isError:
                                                                            false);
                                                                    locationProvider
                                                                        .getAreasList(
                                                                            context);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  } else {
                                                                    showCustomSnackBar(
                                                                        'Something went wrong',
                                                                        context);
                                                                  }
                                                                });
                                                              }
                                                            },
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height,
                              child: Image.asset(
                                Images.marker_icon,
                                width: 25,
                                height: 35,
                              )),
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
