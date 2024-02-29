import 'package:alphawash/data/helper/area_boundaries.dart';
import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/screens/location/autocomplete_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class EditAreaScreen extends StatefulWidget {
  final AreaModel? area;
  final bool? fromAutoCompleteSearch;
  EditAreaScreen({@required this.area, @required this.fromAutoCompleteSearch});

  @override
  _EditAreaScreenState createState() => _EditAreaScreenState();
}

class _EditAreaScreenState extends State<EditAreaScreen> {
  GoogleMapController? _controller;
  TextEditingController _locationController = TextEditingController();
  LatLng? initialPosition;
  TextEditingController? _addressController;
  TextEditingController? _areaController;

  bool _mapVisible = true;

  List<LatLng> polygonPoints = [];

  @override
  void initState() {
    super.initState();

    _addressController = TextEditingController();
    _areaController = TextEditingController();

    initialPosition = LatLng(
        double.parse(widget.area!.latitude!),
        double.parse(widget.area!.longitude!));

    _areaController!.text = Provider.of<LocationProvider>(context, listen: false).areaName!;

    polygonPoints = AreaBoundaries.getPolygonPoints(Provider.of<LocationProvider>(context, listen: false).areaName!);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }


  Future<bool> _onWillPop() async {
    _mapVisible = false;
    setState(() {});
    if(_mapVisible == false){
      await Future.delayed(Duration(seconds: 1));
      // Now, navigate back
      Navigator.pop(context);
    }
    return _mapVisible;
  }

  @override
  Widget build(BuildContext? context) {
    if (Provider.of<LocationProvider>(context!).address != null) {
      _locationController.text = '${Provider.of<LocationProvider>(context).address!.name ?? ''}, '
          '${Provider.of<LocationProvider>(context).address!.subAdministrativeArea ?? ''}, '
          '${Provider.of<LocationProvider>(context).address!.isoCountryCode ?? ''}';
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child:
      Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {

          if(_addressController!.text.isEmpty){
            if(locationProvider.address!.administrativeArea != null){
              _addressController!.text =
              locationProvider.address!=null?
              '${locationProvider.address!.administrativeArea}, ${locationProvider.address!.subAdministrativeArea}, ${locationProvider.address!.subLocality}, ${locationProvider.address!.street}'
                  : '';
            }
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  _onWillPop();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
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
              // title: Text('Update area'),
            ),
            body:
            !_mapVisible? Center(child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: LoadingAnimationWidget.inkDrop(
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            )):
            Center(
              child: Container(
                width: 1170,
                child: Stack(
                  clipBehavior: Clip.none, children: [
                  _mapVisible == true?
                  GoogleMap(
                    mapType: locationProvider.satelliteMode? MapType.satellite: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: initialPosition!,
                      zoom: 15,
                    ),
                    zoomControlsEnabled: true,
                    compassEnabled: false,
                    indoorViewEnabled: true,
                    mapToolbarEnabled: true,
                    polygons: {
                      Polygon(
                          polygonId: const PolygonId("1"),
                          points: polygonPoints,
                          fillColor: Colors.blue.withOpacity(0.2),
                          strokeWidth: 2,
                          strokeColor: Colors.blue
                      )
                    },

                    onCameraIdle: () {
                      locationProvider.dragableAddress();
                    },
                    onCameraMove: ((_position) => locationProvider.updatePosition(_position)),
                    // markers: Set<Marker>.of(locationProvider.markers),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;

                      if(widget.fromAutoCompleteSearch == true){
                        locationProvider.getSearchedLocation(mapController: _controller);
                      }else{
                        locationProvider.getSavedLocation(
                            _controller,
                            double.parse(widget.area!.latitude!),
                            double.parse(widget.area!.longitude!)
                        );
                      }

                      // if (_controller != null) {
                      //   if(locationProvider.searchedLocation==null){
                      //     locationProvider.getCurrentLocation(mapController: _controller);
                      //   }else{
                      //     locationProvider.getSearchedLocation(mapController: _controller);
                      //     // locationProvider.getSavedLocation(mapController: _controller);
                      //   }
                      // }
                    },
                  ) : const SizedBox(),
                  locationProvider.address != null?
                  InkWell(
                    onTap: () {
                      // locationProvider.setSelectedArea(widget.area!);
                      // locationProvider.setAreaName(_areaController!.text);
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
                      //     AutocompleteSearch(newArea: false)));
                    },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      // padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 18.0),
                      margin: const EdgeInsets.symmetric(horizontal: 65, vertical: 23.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Text(
                            //     locationProvider.address!.name != null
                            //         ? '${locationProvider.address!.street}, ${locationProvider.address!.administrativeArea}, ${locationProvider.address!.locality}, ${locationProvider.address!.subLocality}, ${locationProvider.address!.country}'
                            //         : '',
                            //     maxLines: 1,
                            //     overflow: TextOverflow.ellipsis),

                            Text(
                                '${_areaController!.text}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ):SizedBox.shrink(),
                  //
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   left: 0,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: [
                  //       InkWell(
                  //         onTap: () {
                  //           locationProvider.resetSearch();
                  //           locationProvider.getCurrentLocation(mapController: _controller);
                  //         },
                  //         child: Container(
                  //           width: 50,
                  //           height: 50,
                  //           margin: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                  //             color: Colors.white,
                  //           ),
                  //           child: Icon(
                  //             Icons.my_location,
                  //             color: Theme.of(context).primaryColor,
                  //             size: 35,
                  //           ),
                  //         ),
                  //       ),
                  //
                  //       const SizedBox(height: 20),
                  //
                  //       Container(
                  //         decoration: BoxDecoration(
                  //             color: Colors.white
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Column(
                  //             children: [
                  //               // Row(
                  //               //   children: [
                  //               //     Expanded(
                  //               //       child: CustomTextField(
                  //               //         hintText: 'Address',
                  //               //         isShowBorder: true,
                  //               //         controller: _addressController,
                  //               //         inputType: TextInputType.emailAddress,
                  //               //         inputAction: TextInputAction.done,
                  //               //       ),
                  //               //     ),
                  //               //   ],
                  //               // ),
                  //
                  //               const SizedBox(height: 7),
                  //
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: CustomTextField(
                  //                       hintText: 'Name of area',
                  //                       isShowBorder: true,
                  //                       controller: _areaController,
                  //                       inputType: TextInputType.text,
                  //                       inputAction: TextInputAction.done,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //
                  //               const SizedBox(height: 20),
                  //
                  //               locationProvider.storeAreaLoading?
                  //               Padding(
                  //                 padding: const EdgeInsets.only(bottom: 20),
                  //                 child: Center(child: CircularProgressIndicator(
                  //                     valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                  //               ):
                  //               Padding(
                  //                 padding: const EdgeInsets.only(bottom: 38),
                  //                 child: CustomButton(
                  //                   btnTxt: 'Update',
                  //                   onTap: locationProvider.loading ? null : () {
                  //                     FocusScope.of(context).unfocus();
                  //                     if(_areaController!.text.isEmpty){
                  //                       showDialog(
                  //                         context: context,
                  //                         builder: (BuildContext? context) {
                  //                           return AlertDialog(
                  //                             title: Text('Hint!',
                  //                                 style: TextStyle(color: Theme.of(context!).primaryColor, fontSize: 15)),
                  //                             content: const Text('Please fill the area name', style: TextStyle(fontSize: 13)),
                  //                           );
                  //                         },
                  //                       );
                  //                     }else {
                  //                       locationProvider.updateArea(
                  //                           widget.area!.id!,
                  //                           _areaController!.text,
                  //                           '${locationProvider.searchedLocation}, ${locationProvider.address!.administrativeArea}, ${locationProvider.address!.subAdministrativeArea}, ${locationProvider.address!.subLocality}, ${locationProvider.address!.street}',
                  //                           locationProvider.position!.latitude.toString(),
                  //                           locationProvider.position!.longitude.toString()).then((value) {
                  //                         if(value.isSuccess){
                  //                           showCustomSnackBar('Area updated successfully', context, isError: false);
                  //                           locationProvider.getAreasList(context);
                  //                           Navigator.of(context).pop();
                  //                         }else{
                  //                           showCustomSnackBar('Something went wrong', context);
                  //                         }
                  //                       });
                  //                     }
                  //                   },
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      child: Image.asset(
                        Images.marker_icon,
                        width: 25,
                        height: 35,
                      )),
                  locationProvider.loading ? Center(child: CircularProgressIndicator(valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) : const SizedBox(),
                ],
                ),
              ),
            ),
          );
        }),

    );
  }
}

