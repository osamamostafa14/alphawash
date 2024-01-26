// import 'package:alphawash/data/model/response/admin_task_model.dart';
// import 'package:alphawash/data/model/response/pin_point_model.dart';
// import 'package:alphawash/data/model/response/user_info_model.dart';
// import 'package:alphawash/data/model/response/waypoint_model.dart';
// import 'package:alphawash/provider/location_provider.dart';
// import 'package:alphawash/provider/worker_provider.dart';
// import 'package:alphawash/view/base/custom_button.dart';
// import 'package:alphawash/view/base/custom_snackbar.dart';
// import 'package:alphawash/view/base/custom_text_field.dart';
// import 'package:alphawash/view/screens/users/admin_tasks/select_waypoint_screen.dart';
// import 'package:alphawash/view/screens/users/admin_tasks/select_worker_screen.dart';
// import 'package:alphawash/view/screens/waypoints/pinpoint_screens/add_pinpoint_screen.dart';
// import 'package:alphawash/view/screens/waypoints/select_area_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:alphawash/provider/auth_provider.dart';
// import 'package:alphawash/utill/dimensions.dart';
//
// class AdminAddTaskScreen extends StatefulWidget {
//   @override
//   State<AdminAddTaskScreen> createState() => _AdminAddTaskScreenState();
// }
//
// class _AdminAddTaskScreenState extends State<AdminAddTaskScreen> {
//   TextEditingController? _taskDetailsController;
//
//   @override
//   void initState() {
//     super.initState();
//     _taskDetailsController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _taskDetailsController!.dispose();
//     super.dispose();
//   }
//
//   DateTime? selectedDateTime;
//
//   Future<void> _selectDateTime() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2022),
//       lastDate: DateTime(2025),
//     );
//
//     if (pickedDate != null) {
//       TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//
//       if (pickedTime != null) {
//         setState(() {
//           selectedDateTime = DateTime(
//             pickedDate.year,
//             pickedDate.month,
//             pickedDate.day,
//             pickedTime.hour,
//             pickedTime.minute,
//           );
//         });
//       }
//     }
//   }
//
//   String _formatTimeOfDay(TimeOfDay timeOfDay) {
//     final now = DateTime.now();
//     final dateTime = DateTime(
//         now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
//     return TimeOfDay.fromDateTime(dateTime).format(context);
//   }
//
//   @override
//   Widget build(BuildContext? context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: true,
//         title:
//             const Text('Add New Tasks', style: TextStyle(color: Colors.white)),
//         leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios),
//             color: Colors.white,
//             onPressed: () => Navigator.pop(context)),
//       ),
//       body: Consumer<LocationProvider>(
//         builder: (context, locationProvider, child) {
//           return Scrollbar(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//               physics: const BouncingScrollPhysics(),
//               child: Center(
//                 child: SizedBox(
//                   width: 1170,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Waypoint ',
//                         style: TextStyle(
//                             color: Theme.of(context).textTheme.headline1!.color,
//                             fontSize: 15),
//                       ),
//                       const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
//                       InkWell(
//                         onTap: () async {
//                           FocusScope.of(context).unfocus();
//                           locationProvider.getWaypointsList(context);
//                           WaypointModel? selectedWaypoint =
//                               await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (BuildContext context) =>
//                                   SelectWaypointScreen(),
//                             ),
//                           );
//                           if (selectedWaypoint != null) {
//                             int? id = selectedWaypoint.id;
//                             locationProvider.setSelectedWaypointId(id!);
//                           }
//                         },
//                         child: Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(10.0)),
//                             border: Border.all(
//                               color: Theme.of(context)
//                                   .primaryColor
//                                   .withOpacity(0.4),
//                               width: 1,
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 const SizedBox(width: 10),
//                                 Text(
//                                   locationProvider.waypoints.isNotEmpty
//                                       ? locationProvider.selectedWaypointName
//                                       : 'Select WayPoint',
//
//                                   style: TextStyle(
//                                     color:
//                                         locationProvider.selectedWaypointId !=
//                                                 null
//                                             ? Colors.black87
//                                             : Colors.black45,
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 16,
//                                     fontFamily: 'Roboto',
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 // const Icon(
//                                 //   Icons.person,
//                                 //   color: Colors.black54,
//                                 //   size: 25,
//                                 // ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
//                       Text(
//                         'Worker',
//                         style: TextStyle(
//                             color: Theme.of(context).textTheme.headline1!.color,
//                             fontSize: 15),
//                       ),
//                       const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
//                       InkWell(
//                         onTap: () async {
//                           FocusScope.of(context).unfocus();
//                           Provider.of<WorkerProvider>(context, listen: false)
//                               .selectedWorkerId;
//                           locationProvider.getWaypointsList(context);
//                           UserInfoModel? selectedWaypoint =
//                               await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (BuildContext context) =>
//                                   SelectWorkerScreen(),
//                             ),
//                           );
//                           if (selectedWaypoint != null) {
//                             int? id = Provider.of<WorkerProvider>(context,
//                                     listen: false)
//                                 .selectedWorkerId;
//
//                             locationProvider.setSelectedWaypointId(id);
//                           }
//                         },
//                         child: Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(10.0)),
//                             border: Border.all(
//                               color: Theme.of(context)
//                                   .primaryColor
//                                   .withOpacity(0.4),
//                               width: 1,
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 const SizedBox(width: 10),
//                                 Text(
//                                   Provider.of<WorkerProvider>(context,
//                                               listen: false)
//                                           .selectedWorkerName
//                                           .isNotEmpty
//                                       ? Provider.of<WorkerProvider>(context,
//                                               listen: false)
//                                           .selectedWorkerName
//                                       : 'Select Worker',
//                                   style: TextStyle(
//                                     color: Provider.of<WorkerProvider>(context,
//                                                     listen: false)
//                                                 .selectedWorkerId !=
//                                             null
//                                         ? Colors.black87
//                                         : Colors.black45,
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 16,
//                                     fontFamily: 'Roboto',
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 // const Icon(
//                                 //   Icons.person,
//                                 //   color: Colors.black54,
//                                 //   size: 25,
//                                 // ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       // InkWell(
//                       //   onTap: () {
//                       //     FocusScope.of(context).unfocus();
//                       //     Navigator.push(
//                       //         context,
//                       //         MaterialPageRoute(
//                       //             builder: (BuildContext context) =>
//                       //                 SelectWorkerScreen()));
//                       //   },
//                       //   child: Container(
//                       //     height: 50,
//                       //     decoration: BoxDecoration(
//                       //         color: Colors.white,
//                       //         borderRadius:
//                       //             const BorderRadius.all(Radius.circular(10.0)),
//                       //         border: Border.all(
//                       //             color: Theme.of(context)
//                       //                 .primaryColor
//                       //                 .withOpacity(0.4),
//                       //             width: 1)),
//                       //     child: Padding(
//                       //       padding: const EdgeInsets.all(8.0),
//                       //       child: Row(
//                       //         children: [
//                       //           const SizedBox(width: 10),
//                       //           Text(
//                       //             locationProvider.selectWorker != null
//                       //                 ? '${locationProvider.selectWorker!.fullName}'
//                       //                 : 'Select Worker',
//                       //             style: TextStyle(
//                       //                 color:
//                       //                     locationProvider.selectWorker != null
//                       //                         ? Colors.black87
//                       //                         : Colors.black45,
//                       //                 fontWeight: FontWeight.normal,
//                       //                 fontSize: 16,
//                       //                 fontFamily: 'Roboto'),
//                       //           ),
//                       //           const Spacer(),
//                       //           const Icon(
//                       //             Icons.person,
//                       //             color: Colors.black54,
//                       //             size: 25,
//                       //           ),
//                       //         ],
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                       const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
//                       Text(
//                         'Date & Time',
//                         style: TextStyle(
//                             color: Theme.of(context).textTheme.headline1!.color,
//                             fontSize: 15),
//                       ),
//                       const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
//                       InkWell(
//                           onTap: _selectDateTime,
//                           child: Container(
//                               height: 50,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(10.0)),
//                                   border: Border.all(
//                                       color: Theme.of(context)
//                                           .primaryColor
//                                           .withOpacity(0.4),
//                                       width: 1)),
//                               child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     children: [
//                                       selectedDateTime != null
//                                           ? Row(
//                                               children: [
//                                                 Text(
//                                                     '${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}',
//                                                     style: TextStyle(
//                                                         fontSize: 16)),
//                                                 SizedBox(width: 50),
//                                                 Text(
//                                                     '${_formatTimeOfDay(TimeOfDay.fromDateTime(selectedDateTime!))}',
//
//                                                     // 'Time: ${selectedDateTime!.hour}:${selectedDateTime!.minute}',
//                                                     style: TextStyle(
//                                                         fontSize: 16)),
//                                               ],
//                                             )
//                                           : Text(
//                                               'Select date & time',
//                                               style: TextStyle(
//                                                   color:
//                                                       selectedDateTime != null
//                                                           ? Colors.black87
//                                                           : Colors.black45,
//                                                   fontWeight: FontWeight.normal,
//                                                   fontSize: 16,
//                                                   fontFamily: 'Roboto'),
//                                             ),
//                                       const Spacer(),
//                                       const Icon(
//                                         Icons.date_range,
//                                         color: Colors.black54,
//                                         size: 25,
//                                       ),
//                                     ],
//                                   )))),
//                       const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
//                       Text(
//                         'Task Details',
//                         style: TextStyle(
//                             color: Theme.of(context).textTheme.headline1!.color,
//                             fontSize: 15),
//                       ),
//                       const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
//                       CustomTextField(
//                         hintText: 'Task Details (optional)',
//                         maxLines: 3,
//                         isShowBorder: true,
//                         inputAction: TextInputAction.done,
//                         inputType: TextInputType.text,
//                         controller: _taskDetailsController,
//                       ),
//                       const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
//                       locationProvider.storeTaskLoading
//                           ? Center(
//                               child: Padding(
//                               padding: const EdgeInsets.only(bottom: 20),
//                               child: CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                       Theme.of(context).primaryColor)),
//                             ))
//                           : CustomButton(
//                               btnTxt: 'Confirm',
//                               onTap: () {
//                                 FocusScope.of(context).unfocus();
//
//
//                                 print(locationProvider.selectedWaypointId);
//                                 print( Provider.of<WorkerProvider>(context,
//                                     listen: false)
//                                     .selectedWorkerId);
//
//                                 print(_taskDetailsController.toString());
//                                 print(selectedDateTime);
//                                 // locationProvider
//                                 //     .storeTask(
//                                 //     Provider.of<WorkerProvider>(context,
//                                 //         listen: false)
//                                 //         .selectedWorkerId,
//                                 //         locationProvider.selectedWaypointId,
//                                 //         selectedDateTime!,
//                                 //         taskDetails:
//                                 //             _taskDetailsController!.text.trim())
//                                 //     .then((value) {
//                                 //   if (value.isSuccess) {
//                                 //     showCustomSnackBar(
//                                 //         'New Task added successfully', context,
//                                 //         isError: false);
//                                 //     locationProvider.getTasksList(context);
//                                 //     Navigator.pop(context);
//                                 //   } else {
//                                 //     showCustomSnackBar(
//                                 //         'Something went wrong', context);
//                                 //   }
//                                 // });
//                               })
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:alphawash/view/base/custom_text_field.dart';
import 'package:alphawash/view/screens/users/admin_tasks/select_waypoint_screen.dart';
import 'package:alphawash/view/screens/users/admin_tasks/select_worker_screen.dart';
import 'package:alphawash/view/screens/waypoints/add_pinpoint_screen.dart';
import 'package:alphawash/view/screens/waypoints/select_area_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/utill/dimensions.dart';

class AdminAddTaskScreen extends StatefulWidget {
  @override
  State<AdminAddTaskScreen> createState() => _AdminAddTaskScreenState();
}

class _AdminAddTaskScreenState extends State<AdminAddTaskScreen> {
  TextEditingController? _taskDetailsController;

  @override
  void initState() {
    super.initState();
    _taskDetailsController = TextEditingController();
  }

  @override
  void dispose() {
    _taskDetailsController!.dispose();
    super.dispose();
  }

  DateTime? selectedDateTime;

  Future<void> _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return TimeOfDay.fromDateTime(dateTime).format(context);
  }

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title:
            const Text('Add New Tasks', style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () => Navigator.pop(context)),
      ),
      body: Consumer2<LocationProvider, WorkerProvider>(
        builder: (context, locationProvider, workerProvider, child) {
          return Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: 1170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Waypoint ',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                            fontSize: 15),
                      ),
                      const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
                      InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          locationProvider.getWaypointsList(context);
                          WaypointModel? selectedWaypoint =
                              await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SelectWaypointScreen(),
                            ),
                          );
                          if (selectedWaypoint != null) {
                            int? id = selectedWaypoint.id;
                            locationProvider.setSelectedWaypointId(id!);
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Text(
                                  locationProvider.waypoints.isNotEmpty
                                      ? locationProvider.selectedWaypointName
                                      : 'Select WayPoint',
                                  style: TextStyle(
                                    color: locationProvider
                                            .selectedWaypointName.isNotEmpty
                                        ? Colors.black87
                                        : Colors.black45,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const Spacer(),
                                // const Icon(
                                //   Icons.person,
                                //   color: Colors.black54,
                                //   size: 25,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
                      Text(
                        'Worker',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                            fontSize: 15),
                      ),
                      const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
                      InkWell(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          workerProvider.selectedWorkerId;
                          workerProvider.getWorkersList(context);
                          UserInfoModel? selectedWorker = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SelectWorkerScreen(),
                            ),
                          );
                          if (selectedWorker != null) {
                            int? id = workerProvider.selectedWorkerId;

                            workerProvider.setSelectedWorkerId(id);
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Text(
                                  workerProvider.selectedWorkerName.isNotEmpty
                                      ? workerProvider.selectedWorkerName
                                      : 'Select Worker',
                                  style: TextStyle(
                                      color: workerProvider
                                              .selectedWorkerName.isNotEmpty
                                          ? Colors.black87
                                          : Colors.black45,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      fontFamily: 'Roboto'),
                                ),
                                const Spacer(),
                                // const Icon(
                                //   Icons.person,
                                //   color: Colors.black54,
                                //   size: 25,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
                      Text(
                        'Date & Time',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                            fontSize: 15),
                      ),
                      const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
                      InkWell(
                          onTap: _selectDateTime,
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
                                      selectedDateTime != null
                                          ? Row(
                                              children: [
                                                Text(
                                                    '${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                SizedBox(width: 50),
                                                Text(
                                                    '${_formatTimeOfDay(TimeOfDay.fromDateTime(selectedDateTime!))}',

                                                    // 'Time: ${selectedDateTime!.hour}:${selectedDateTime!.minute}',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            )
                                          : Text(
                                              'Select date & time',
                                              style: TextStyle(
                                                  color:
                                                      selectedDateTime != null
                                                          ? Colors.black87
                                                          : Colors.black45,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  fontFamily: 'Roboto'),
                                            ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.date_range,
                                        color: Colors.black54,
                                        size: 25,
                                      ),
                                    ],
                                  )))),
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      Text(
                        'Task Details',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                            fontSize: 15),
                      ),
                      const SizedBox(height: Dimensions.FONT_SIZE_EXTRA_SMALL),
                      CustomTextField(
                        hintText: 'Task Details (optional)',
                        maxLines: 3,
                        isShowBorder: true,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.text,
                        controller: _taskDetailsController,
                      ),
                      const SizedBox(height: 30),
                      locationProvider.storeTaskLoading
                          ? Center(
                              child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)),
                            ))
                          : CustomButton(
                              btnTxt: 'Confirm',
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                if (locationProvider
                                    .selectedWaypointName.isEmpty) {
                                  showCustomSnackBar(
                                      'Please select waypoint', context);
                                } else if (selectedDateTime == null) {
                                  showCustomSnackBar(
                                      'Please select date', context);
                                } else if (workerProvider
                                    .selectedWorkerName.isEmpty) {
                                  showCustomSnackBar(
                                      'Please select worker', context);
                                }
                                print(
                                    'wayPoint ID:  ${locationProvider.selectedWaypointId}');
                                print(
                                    'Worker ID : ${workerProvider.selectedWorkerId}');

                                print(_taskDetailsController!.text.trim());
                                print(' date : ${selectedDateTime.toString()}');
                                locationProvider.tasksListIsLoading;

                                locationProvider
                                    .storeTask(
                                        workerProvider.selectedWorkerId,
                                        locationProvider.selectedWaypointId,
                                        selectedDateTime!,
                                        _taskDetailsController!.text.trim())
                                    .then((value) {
                                  if (value.isSuccess) {
                                    showCustomSnackBar(
                                        'New Task added successfully', context,
                                        isError: false);

                                    Navigator.pop(context);
                                  } else {
                                    showCustomSnackBar(
                                        'Something went wrong', context);
                                  }
                                });
                              })
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
