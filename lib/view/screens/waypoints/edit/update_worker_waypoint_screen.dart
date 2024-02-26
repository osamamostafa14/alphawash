// import 'package:alphawash/data/model/response/pin_point_model.dart';
// import 'package:alphawash/data/model/response/waypoint_model.dart';
// import 'package:alphawash/provider/location_provider.dart';
// import 'package:alphawash/view/base/custom_button.dart';
// import 'package:alphawash/view/base/custom_snackbar.dart';
// import 'package:alphawash/view/base/custom_text_field.dart';
// import 'package:alphawash/view/screens/waypoints/add_pinpoint_screen.dart';
// import 'package:alphawash/view/screens/waypoints/select_area_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:alphawash/utill/dimensions.dart';
//
// class UpdateWorkerWaypointDataScreen extends StatefulWidget {
//   final WaypointModel? waypoint;
//   UpdateWorkerWaypointDataScreen({@required this.waypoint});
//   @override
//   State<UpdateWorkerWaypointDataScreen> createState() =>
//       _UpdateWorkerWaypointDataScreenState();
// }
//
// class _UpdateWorkerWaypointDataScreenState
//     extends State<UpdateWorkerWaypointDataScreen> {
//   TextEditingController? _nameController;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//     _nameController!.text = widget.waypoint!.name!;
//   }
//
//   @override
//   void dispose() {
//     _nameController!.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext? context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
//       body: Consumer<LocationProvider>(
//         builder: (context, locationProvider, child) {
//           return Column(
//             children: [
//               Expanded(
//                 child: Scrollbar(
//                   child: SingleChildScrollView(
//                       padding:
//                           const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//                       physics: const BouncingScrollPhysics(),
//                       child: Center(
//                         child: SizedBox(
//                           width: 1170,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Name',
//                                   style: TextStyle(
//                                       color: Theme.of(context)
//                                           .textTheme
//                                           .headline2!
//                                           .color,
//                                       fontSize: 15)),
//                               const SizedBox(
//                                   height: Dimensions.PADDING_SIZE_SMALL),
//                               CustomTextField(
//                                 hintText: 'Name',
//                                 isShowBorder: true,
//                                 inputAction: TextInputAction.done,
//                                 inputType: TextInputType.text,
//                                 controller: _nameController,
//                               ),
//                               const SizedBox(
//                                   height: Dimensions.PADDING_SIZE_LARGE),
//                               Text(
//                                 'Area',
//                                 style: TextStyle(
//                                     color: Theme.of(context)
//                                         .textTheme
//                                         .headline2!
//                                         .color,
//                                     fontSize: 15),
//                               ),
//                               const SizedBox(
//                                   height: Dimensions.PADDING_SIZE_SMALL),
//                               InkWell(
//                                   onTap: () {
//                                     FocusScope.of(context).unfocus();
//                                     locationProvider.getAreasList(context);
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (BuildContext context) =>
//                                                 SelectAreaScreen()));
//                                   },
//                                   child: Container(
//                                       height: 50,
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: const BorderRadius.all(
//                                               Radius.circular(10.0)),
//                                           border: Border.all(
//                                               color: Theme.of(context)
//                                                   .primaryColor
//                                                   .withOpacity(0.4),
//                                               width: 1)),
//                                       child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Row(children: [
//                                             const SizedBox(width: 10),
//                                             Text(
//                                               locationProvider.searchedArea !=
//                                                       null
//                                                   ? '${locationProvider.searchedArea!.name}'
//                                                   : 'Select area',
//                                               style: TextStyle(
//                                                   color: locationProvider
//                                                               .searchedArea !=
//                                                           null
//                                                       ? Colors.black87
//                                                       : Colors.black45,
//                                                   fontWeight: FontWeight.normal,
//                                                   fontSize: 14,
//                                                   fontFamily: 'Roboto'),
//                                             ),
//                                             const Spacer(),
//                                             const Icon(Icons.search_outlined,
//                                                 color: Colors.black54, size: 25)
//                                           ])))),
//                               const SizedBox(
//                                   height: Dimensions.PADDING_SIZE_LARGE),
//                               locationProvider.searchedArea != null
//                                   ? Text(
//                                       'Pins',
//                                       style: TextStyle(
//                                           color: Theme.of(context)
//                                               .textTheme
//                                               .headline2!
//                                               .color,
//                                           fontSize: 15),
//                                     )
//                                   : const SizedBox(),
//                               const SizedBox(
//                                   height: Dimensions.PADDING_SIZE_SMALL),
//                               locationProvider.searchedArea != null
//                                   ? InkWell(
//                                       onTap: () {
//                                         FocusScope.of(context).unfocus();
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (BuildContext
//                                                         context) =>
//                                                     AddPinPointScreen(
//                                                         area: locationProvider
//                                                             .searchedArea)));
//                                       },
//                                       child: Container(
//                                         height: 50,
//                                         decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius:
//                                                 const BorderRadius.all(
//                                                     Radius.circular(10.0)),
//                                             border: Border.all(
//                                                 color: Theme.of(context)
//                                                     .primaryColor
//                                                     .withOpacity(0.4),
//                                                 width: 1)),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Row(
//                                             children: [
//                                               const SizedBox(width: 10),
//                                               Text(
//                                                 locationProvider
//                                                             .markers.length >
//                                                         0
//                                                     ? '${locationProvider.markers.length} Pins Added'
//                                                     : 'Add Pins +',
//                                                 style: TextStyle(
//                                                     color: locationProvider
//                                                             .markers.isNotEmpty
//                                                         ? Colors.black87
//                                                         : Colors.black45,
//                                                     fontWeight:
//                                                         FontWeight.normal,
//                                                     fontSize: 14,
//                                                     fontFamily: 'Roboto'),
//                                               ),
//                                               const Spacer(),
//                                               const Icon(
//                                                 Icons.location_pin,
//                                                 color: Colors.black54,
//                                                 size: 25,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   : const SizedBox(),
//                               const SizedBox(
//                                   height: Dimensions.PADDING_SIZE_LARGE),
//                             ],
//                           ),
//                         ),
//                       )),
//                 ),
//               ),
//               locationProvider.storeWaypointLoading
//                   ? Center(
//                       child: Padding(
//                       padding: const EdgeInsets.only(bottom: 20),
//                       child: CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                               Theme.of(context).primaryColor)),
//                     ))
//                   : Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: CustomButton(
//                           btnTxt: 'Update',
//                           onTap: () {
//                             FocusScope.of(context).unfocus();
//                             if (_nameController!.text.trim().isEmpty) {
//                               showCustomSnackBar(
//                                   'Please fill name field', context);
//                             } else if (locationProvider.searchedArea == null) {
//                               showCustomSnackBar('Please select area', context);
//                             } else if (locationProvider.markers.isEmpty) {
//                               showCustomSnackBar(
//                                   'Please add at least on pin point', context);
//                             } else {
//                               List<PinPointModel> _pinPoints = [];
//                               locationProvider.markers.forEach((element) {
//                                 PinPointModel _pin = PinPointModel(
//                                   latitude:
//                                       element.position.latitude.toString(),
//                                   longitude:
//                                       element.position.longitude.toString(),
//                                 );
//                                 _pinPoints.add(_pin);
//                               });
//                               WaypointModel _wayPoint = WaypointModel(
//                                   id: widget.waypoint!.id,
//                                   areaId: locationProvider.searchedArea!.id,
//                                   name: _nameController!.text.trim(),
//                                   pinPoints: _pinPoints);
//                               locationProvider
//                                   .updateWorkerWayPointInfo(_wayPoint)
//                                   .then((value) {
//                                 if (value.isSuccess) {
//                                   showCustomSnackBar(
//                                       'Waypoint updated successfully', context,
//                                       isError: false);
//                                   locationProvider
//                                       .getWorkerWaypointsList(context);
//                                 } else {
//                                   showCustomSnackBar(
//                                       'Something went wrong', context);
//                                 }
//                               });
//                             }
//                           }),
//                     )
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
