// import 'dart:async';
//
// import 'package:alphawash/data/model/response/waypoint_model.dart';
// import 'package:alphawash/data/model/response/worker_task_model.dart';
// import 'package:alphawash/provider/location_provider.dart';
// import 'package:alphawash/provider/worker_provider.dart';
// import 'package:alphawash/utill/dimensions.dart';
// import 'package:alphawash/view/screens/waypoints/pinpoint_screens/worker_pinpoints_screen.dart';
// import 'package:alphawash/view/screens/waypoints/worker-tasks/worker_tasks_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// class WorkerTaskScreen extends StatefulWidget {
//   @override
//   _WorkerTaskScreenState createState() => _WorkerTaskScreenState();
// }
//
// class _WorkerTaskScreenState extends State<WorkerTaskScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   ScrollController scrollController = ScrollController();
//
//   @override
//   void initState() {
//     Timer(const Duration(seconds: 2), () {
//       Provider.of<WorkerProvider>(context, listen: false).workerTasks;
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WorkerProvider>(builder: (context, workerProvider, child) {
//       return Scaffold(
//           key: _scaffoldKey,
//           appBar: AppBar(
//             title: const Text('Your Tasks',
//                 style: TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.normal)),
//             centerTitle: true,
//             backgroundColor: Theme.of(context).primaryColor,
//             elevation: 0.5,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               color: Colors.white,
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                 child: Scrollbar(
//                   child: SingleChildScrollView(
//                     controller: scrollController,
//                     physics: const BouncingScrollPhysics(),
//                     padding:
//                         const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                     child: Center(
//                       child: SizedBox(
//                         width: 1170,
//                         child: workerProvider.workerTasksListLoading
//                             ? Center(
//                                 child: CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Theme.of(context).primaryColor)))
//                             : workerProvider.workerTasks.isEmpty
//                                 ? const Padding(
//                                     padding: EdgeInsets.only(top: 100),
//                                     child: Center(child: Text('No tasks yet')),
//                                   )
//                                 : Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       ListView.builder(
//                                         padding: const EdgeInsets.all(
//                                             Dimensions.PADDING_SIZE_SMALL),
//                                         itemCount:
//                                             workerProvider.workerTasks.length,
//                                         physics:
//                                             const NeverScrollableScrollPhysics(),
//                                         shrinkWrap: true,
//                                         itemBuilder: (context, index) {
//                                           WorkerTaskModel _tasks =
//                                               workerProvider.workerTasks[index];
//                                           return Column(
//                                             children: [
//                                               MaterialButton(
//                                                 onPressed: () {
//                                                   Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (BuildContext
//                                                                   context) =>
//                                                               WorkerTasksDetailsScreen(
//                                                                   tasks:
//                                                                       _tasks)));
//                                                 },
//                                                 shape: RoundedRectangleBorder(
//
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                     side: BorderSide(
//                                                         color: Theme.of(context).primaryColor.withOpacity(0.5),
//                                                         width: 0.3)),
//                                                 elevation: 0,
//                                                 color: Colors.white,
//
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8),
//                                                   child: Row(
//                                                     children: [
//                                                       Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                               '${_tasks.wayPoint!.name}',
//                                                               maxLines: 1,
//                                                               style: const TextStyle(
//                                                                   color: Colors
//                                                                       .black87,
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .ellipsis,
//                                                                   fontSize: 16,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500)),
//                                                           const SizedBox(height: 5),
//                                                           Text(
//                                                             '  Task Day: ${DateFormat('M/d/yyyy').format(_tasks.taskDate ?? DateTime.now())}',
//                                                             maxLines: 1,
//                                                             style:
//                                                                 const TextStyle(
//                                                               color: Colors
//                                                                   .black45,
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                               fontSize: 14,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       const Spacer(),
//                                                       const Icon(
//                                                           Icons
//                                                               .arrow_forward_ios,
//                                                           color:
//                                                               Colors.black54),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             const SizedBox(
//                                                 height: 15,
//                                               )
//                                               // Divider(),
//                                             ],
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),
//             ],
//           ));
//     });
//   }
// }
