import 'dart:async';

import 'package:alphawash/view/screens/waypoints/add_press_pin_screen.dart';
import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:alphawash/view/base/custom_text_field.dart';
import 'package:alphawash/view/screens/waypoints/add_pinpoint_screen.dart';
import 'package:alphawash/view/screens/waypoints/select_area_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/utill/dimensions.dart';

class EditWaypointScreen extends StatefulWidget {
  final WaypointModel? waypoint;
  EditWaypointScreen({@required this.waypoint});
  @override
  State<EditWaypointScreen> createState() => _EditWaypointScreenState();
}

class _EditWaypointScreenState extends State<EditWaypointScreen> {
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.waypoint!.name!;
    Timer(const Duration(seconds: 2), () {
      Provider.of<LocationProvider>(context, listen: false).updateAreaChangedValue(false);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color,
                                  fontSize: 15),
                            ),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: 'Name',
                              isShowBorder: true,
                              inputAction: TextInputAction.done,
                              inputType: TextInputType.text,
                              controller: _nameController,
                            ),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_LARGE),
                            Text(
                              'Area',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color,
                                  fontSize: 15),
                            ),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_SMALL),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        insetPadding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        content: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Text(
                                            'If you change the area, all the pinpoints will be deleted.',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: BorderSide(
                                                        color: Colors.black26),
                                                  ),
                                                  onPressed: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    locationProvider
                                                        .getAreasList(context);
                                                    locationProvider.markers
                                                        .clear();
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            SelectAreaScreen(),
                                                      ),
                                                    ).then((value) {
                                                      locationProvider.markers
                                                          .clear();
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Text("Yes"),
                                                  height: 40,
                                                  color: Colors.white,
                                                  elevation: 0,
                                                ),

                                                const SizedBox(width: 15),
                                                MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  height: 40,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  elevation: 0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.4),
                                        width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      Text(
                                        locationProvider.searchedArea != null
                                            ? '${locationProvider.searchedArea!.name}'
                                            : 'Select area',
                                        style: TextStyle(
                                            color:
                                                locationProvider.searchedArea !=
                                                        null
                                                    ? Colors.black87
                                                    : Colors.black45,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            fontFamily: 'Roboto'),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.search_outlined,
                                        color: Colors.black54,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_LARGE),
                            locationProvider.searchedArea != null
                                ? Text(
                                    'Pins',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .color,
                                        fontSize: 15),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_SMALL),
                            locationProvider.searchedArea != null
                                ? InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();

                                      if(locationProvider.areaChanged == false){
                                        locationProvider.initPinPoints(context, widget.waypoint!, true);
                                      }else{
                                        locationProvider.initNewPinPoints(context, false);
                                      }

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  locationProvider
                                                          .markers.isEmpty
                                                      ? AddPinPointScreen(
                                                          area: locationProvider
                                                              .searchedArea)
                                                      : AddAndPressPinPointScreen(
                                                          waypoint:
                                                              widget.waypoint,
                                                        )));
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0)),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.4),
                                              width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10),
                                            Text(
                                              locationProvider.markers.length >
                                                      0
                                                  ? '${locationProvider.markers.length} Pins Added'
                                                  : 'Add Pins +',
                                              style: TextStyle(
                                                  color: locationProvider
                                                          .markers.isNotEmpty
                                                      ? Colors.black87
                                                      : Colors.black45,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto'),
                                            ),
                                            const Spacer(),
                                            const Icon(
                                              Icons.location_pin,
                                              color: Colors.black54,
                                              size: 25,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_LARGE),
                            Text(
                              'Day',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color,
                                  fontSize: 15),
                            ),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_SMALL),
                            InkWell(
                                onTap: () {
                                  _showDaySelectionDialog(
                                      context, locationProvider);
                                },
                                child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0)),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.4),
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(children: [
                                          const SizedBox(width: 10),
                                          Text(locationProvider.selectedDay != 'Select the day'?
                                          locationProvider.selectedDay:
                                          widget.waypoint!.day!,
                                              style: TextStyle(
                                                  color: locationProvider
                                                              .selectedDay ==
                                                          "Select the day"
                                                      ? Colors.black45
                                                      : Colors.black87,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  fontFamily: 'Roboto')),
                                          const Spacer(),
                                          const Icon(Icons.view_day,
                                              color: Colors.black54, size: 25)
                                        ])))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              locationProvider.storeWaypointLoading
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)),
                    ))
                  : Padding(
                      padding:
                          const EdgeInsets.only(right: 8, left: 8, bottom: 5),
                      child: CustomButton(
                          btnTxt: 'Update',
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (_nameController!.text.trim().isEmpty) {
                              showCustomSnackBar(
                                  'Please fill name field', context);
                            } else if (locationProvider.searchedArea == null) {
                              showCustomSnackBar('Please select area', context);
                            } else if (locationProvider.markers.isEmpty) {
                              showCustomSnackBar(
                                  'Please add at least on pin point', context);
                            } else {
                              List<PinPointModel> _pinPoints = [];

                              locationProvider.markers.forEach((element) {
                                PinPointModel _pin = PinPointModel(
                                  latitude:
                                      element.position.latitude.toString(),
                                  longitude:
                                      element.position.longitude.toString(),
                                );
                                _pinPoints.add(_pin);
                              });

                              WaypointModel _wayPoint = WaypointModel(
                                  id: widget.waypoint!.id,
                                  areaId: locationProvider.searchedArea!.id,
                                  name: _nameController.text.trim(),
                                  pinPoints: _pinPoints,
                                  day: locationProvider.selectedDay != 'Select the day'? locationProvider.selectedDay : widget.waypoint!.day);
                              locationProvider
                                  .updateWayPointInfo(_wayPoint)
                                  .then((value) {
                                if (value.isSuccess) {
                                  showCustomSnackBar(
                                      'Waypoint updated successfully', context,
                                      isError: false);
                                  locationProvider.getWaypointsList(context);
                                } else {
                                  showCustomSnackBar(
                                      'Something went wrong', context);
                                }
                              });
                            }
                          }),
                    ),
              locationProvider.deleteWaypointLoading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: CustomButton(
                        btnTxt: 'Delete Waypoint',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                insetPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Text(
                                    'Are you sure you want to delete this waypoint?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                color: Colors.black26),
                                          ),
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();

                                            locationProvider
                                                .deleteWayPointInfo(
                                                    widget.waypoint!.id!)
                                                .then((value) {
                                              if (value.isSuccess) {
                                                Navigator.pop(context);
                                                showCustomSnackBar(
                                                  'Waypoint deleted successfully',
                                                  context,
                                                  isError: false,
                                                );
                                                locationProvider
                                                    .getWaypointsList(context);
                                                Navigator.pop(context);
                                              } else {
                                                Navigator.pop(context);
                                                showCustomSnackBar(
                                                  'Something went wrong',
                                                  context,
                                                );
                                              }
                                            });
                                          },
                                          child: Text("Yes"),
                                          height: 40,
                                          color: Colors.white,
                                          elevation: 0,
                                        ),
                                        const SizedBox(width: 15),
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "No",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          height: 40,
                                          color: Theme.of(context).primaryColor,
                                          elevation: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        backgroundColor: Colors.transparent,
                        textColor: Theme.of(context).primaryColor,
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  _showDaySelectionDialog(
      BuildContext context, LocationProvider locationProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              'Saturday',
              'Sunday',
              'Monday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday'
            ]
                .map((day) => _buildDayButton(context, day, locationProvider))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildDayButton(
      BuildContext context, String day, LocationProvider locationProvider) {
    return TextButton(
      onPressed: () {
        locationProvider.updateSelectedDay(day);
        Navigator.pop(context);
      },
      child: Text(day),
    );
  }
}
