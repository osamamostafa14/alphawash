// import 'dart:io';
//
// import 'package:alphawash/data/model/response/pin_point_model.dart';
// import 'package:alphawash/data/model/response/worker_task_model.dart';
// import 'package:alphawash/provider/profile_provider.dart';
// import 'package:alphawash/provider/worker_provider.dart';
// import 'package:alphawash/view/base/border_button.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:hive/hive.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:alphawash/utill/dimensions.dart';
// import '../../../../utill/app_constants.dart';
// import '../../../../utill/images.dart';
// import '../../../base/custom_snackbar.dart';
//
// class AddPinpointTaskScreen extends StatefulWidget {
//   PinPointModel? pinPoint;
//   //final WorkerTaskModel? tasks;
// final bool? admin ;
//  final int? user;
//
//   AddPinpointTaskScreen(
//       {@required this.user, @required this.pinPoint, this.admin});
//   @override
//   State<AddPinpointTaskScreen> createState() => _AddPinpointTaskScreenState();
// }
//
// class _AddPinpointTaskScreenState extends State<AddPinpointTaskScreen> {
//   TextEditingController? _detailsController;
//   File? file;
//   PickedFile? data;
//   final picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     _detailsController = TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     _detailsController!.dispose();
//     super.dispose();
//   }
//
//   void _choose() async {
//     final pickedFile = await picker.getImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//       maxHeight: 500,
//       maxWidth: 500,
//     );
//     setState(() {
//       if (pickedFile != null) {
//         file = File(pickedFile.path);
//         Provider.of<WorkerProvider>(context, listen: false).setTaskImage(file!);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Future<void> _checkDistanceAndSaveTask() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     double pinPointLatitude = double.parse(widget.pinPoint!.latitude!);
//     double pinPointLongitude = double.parse(widget.pinPoint!.longitude!);
//     //bkarn el current location  bl pin location
//     double distance = Geolocator.distanceBetween(
//       position.latitude,
//       position.longitude,
//       pinPointLatitude,
//       pinPointLongitude,
//     );
//     if (distance > 25) {
//       FocusScope.of(context).unfocus();
//       WorkerProvider workerProvider =
//           Provider.of<WorkerProvider>(context, listen: false);
//       int? userId = widget.user;
//       // int pinPointId = 43;
//       var box = Hive.box('myBox');
//       String token = box.get(AppConstants.TOKEN);
//       String details = _detailsController!.text.trim();
//
//       if (workerProvider.taskImageFile != null && details.isNotEmpty) {
//         await workerProvider.addPinPointTask(
//             token, userId!, widget.pinPoint!.id!, details).then((value) {
//           showCustomSnackBar('Task updated successfully!', context, isError: false);
//         }); // check here
//       } else {
//         if (workerProvider.taskImageFile == null) {
//           showCustomSnackBar('Please select an image!', context, isError: true);
//         }
//         if (details.isEmpty) {
//           showCustomSnackBar('Text field is required!', context, isError: true);
//         }
//       }
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Warning',
//                 style: TextStyle(
//                     color: Theme.of(context).primaryColor, fontSize: 15)),
//             content: Text('You must be within 25 meters of the task location.',
//                 style: TextStyle(fontSize: 13)),
//             actions: [
//               Padding(
//                 padding: EdgeInsets.only(bottom: 10),
//                 child: BorderButton(
//                     onTap: () => Navigator.pop(context),
//                     btnTxt: 'ok',
//                     borderColor: Colors.black26),
//               )
//             ],
//           );
//         },
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext? context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
//       body: Consumer<WorkerProvider>(builder: (context, workerProvider, child) {
//         return Provider.of<ProfileProvider>(context)
//                     .userInfoModel!
//                     .workerPermissions!
//                     .addPinpoints ==
//                 1 ||
//
//             widget.admin==true ||   Provider.of<ProfileProvider>(context, listen: false)
//             .userInfoModel
//             ?.userType ==
//             'admin'    ? Center(
//                 child: Scrollbar(
//                   child: SingleChildScrollView(
//                     padding:
//                         const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//                     physics: const BouncingScrollPhysics(),
//                     child: Center(
//                       child: SizedBox(
//                         width: 1170,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//
//                             file != null?
//                             InkWell(
//                               onTap: () {
//                                 _choose();
//                               },
//                               child:
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                               child:
//                               Image.file(file!,
//                                   width: 400,
//                                   height: 300,
//                                   fit: BoxFit.fill))
//
//                             )
//                                 : Align(
//                               alignment: Alignment.center,
//                                   child: InkWell(
//                               onTap: () {
//                                   _choose();
//                               },
//                               child: Container(
//                                   height: 36,
//                                   width: 300,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     border: Border.all(
//                                         color: Colors.black38,
//                                         width: 1),
//
//                                   ),
//                                   child: const Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text("No Selected Image Yet", style: TextStyle(color: Colors.black54)),
//                                       SizedBox(width: 10),
//                                       Icon(Icons.image, color: Colors.black54, size: 22)
//                                     ],
//                                   ),
//                               ),
//                             ),
//                                 ),
//
//
//                             // MaterialButton(
//                             //   shape: RoundedRectangleBorder(
//                             //     side: const BorderSide(color: Colors.black26),
//                             //     borderRadius: BorderRadius.circular(10),
//                             //   ),
//                             //   minWidth: double.infinity,
//                             //   height: 40,
//                             //   onPressed: () => _choose(),
//                             //   child: file != null
//                             //       ? Image.file(file!, fit: BoxFit.cover)
//                             //       : data != null
//                             //           ? Image.network(
//                             //               data!.path,
//                             //               fit: BoxFit.cover,
//                             //             )
//                             //           : const Row(
//                             //     mainAxisAlignment: MainAxisAlignment.center,
//                             //             children: [
//                             //               Text("No Selected Image Yet", style: TextStyle(color: Colors.black54)),
//                             //                SizedBox(width: 10),
//                             //               Icon(Icons.image, color: Colors.black54, size: 22)
//                             //             ],
//                             //           ),
//                             // ),
//                             const SizedBox(height: 20),
//                             Text(
//                               'Details : ',
//                               style: TextStyle(
//                                   color: Theme.of(context)
//                                       .textTheme
//                                       .headline2!
//                                       .color,
//                                   fontSize: 15),
//                             ),
//                             const SizedBox(
//                                 height: Dimensions.PADDING_SIZE_SMALL),
//                             TextField(
//                               controller: _detailsController,
//                               maxLines: 3,
//                               decoration: InputDecoration(
//                                 hintText: 'Write here....',
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   borderSide: const BorderSide(
//                                     color: Colors.black38,
//                                     width: 1.0,
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   borderSide: const BorderSide(
//                                     color: Colors.black,
//                                     width: 1.0,
//                                   ),
//                                 ),
//                                 errorBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   borderSide: const BorderSide(
//                                     color: Colors.black,
//                                     width: 1.0,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             workerProvider.isLoading
//                                 ? Center(
//                                     child: CircularProgressIndicator(
//                                         valueColor: AlwaysStoppedAnimation<
//                                                 Color>(
//                                             Theme.of(context).primaryColor)))
//                                 : MaterialButton(
//                                     minWidth: double.infinity,
//                                     height: 45,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     color: Theme.of(context).primaryColor,
//                                     onPressed: () =>
//                                         _checkDistanceAndSaveTask(),
//                                     child: const Text(
//                                       "Save Task",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             : Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Center(
//                   child: Text(
//                     " You don't have any permission to add tasks.  ",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         color: Theme.of(context).textTheme.headline2!.color,
//                         fontSize: 16),
//                   ),
//                 ),
//               );
//       }),
//     );
//   }
// }
import 'dart:io';

import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/data/model/response/worker_task_model.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/view/base/border_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import '../../../../utill/app_constants.dart';
import '../../../../utill/images.dart';
import '../../../base/custom_snackbar.dart';

class AddPinpointTaskScreen extends StatefulWidget {
  PinPointModel? pinPoint;
  //final WorkerTaskModel? tasks;
  final bool? admin;
  final int? user;

  AddPinpointTaskScreen(
      {@required this.user, @required this.pinPoint, this.admin});
  @override
  State<AddPinpointTaskScreen> createState() => _AddPinpointTaskScreenState();
}

class _AddPinpointTaskScreenState extends State<AddPinpointTaskScreen> {
  TextEditingController? _detailsController;
  File? file;
  PickedFile? data;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _detailsController = TextEditingController();
  }

  @override
  void dispose() {
    _detailsController!.dispose();
    super.dispose();
  }

  void _choose() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 500,
      maxWidth: 500,
    );
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        Provider.of<WorkerProvider>(context, listen: false).setTaskImage(file!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _checkDistanceAndSaveTask() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double pinPointLatitude = double.parse(widget.pinPoint!.latitude!);
    double pinPointLongitude = double.parse(widget.pinPoint!.longitude!);
    //bkarn el current location  bl pin location
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      pinPointLatitude,
      pinPointLongitude,
    );
    if (distance > 25) {
      FocusScope.of(context).unfocus();
      WorkerProvider workerProvider =
          Provider.of<WorkerProvider>(context, listen: false);
      int? userId = widget.user;
      // int pinPointId = 43;
      var box = Hive.box('myBox');
      String token = box.get(AppConstants.TOKEN);
      String details = _detailsController!.text.trim();

      if (workerProvider.taskImageFile != null && details.isNotEmpty) {
        await workerProvider
            .addPinPointTask(token, userId!, widget.pinPoint!.id!, details)
            .then((value) {
          showCustomSnackBar('Task updated successfully!', context,
              isError: false);
        }); // check here
      } else {
        if (workerProvider.taskImageFile == null) {
          showCustomSnackBar('Please select an image!', context, isError: true);
        }
        if (details.isEmpty) {
          showCustomSnackBar('Text field is required!', context, isError: true);
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Warning',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15)),
            content: Text('You must be within 25 meters of the task location.',
                style: TextStyle(fontSize: 13)),
            actions: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: BorderButton(
                    onTap: () => Navigator.pop(context),
                    btnTxt: 'ok',
                    borderColor: Colors.black26),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
      body: Consumer<WorkerProvider>(builder: (context, workerProvider, child) {
        bool hasPermissions = false;
        if (Provider.of<ProfileProvider>(context).userInfoModel!.userType ==
            'admin') {
          hasPermissions = true;
        } else {
          if (Provider.of<ProfileProvider>(context)
                  .userInfoModel!
                  .workerPermissions !=
              null) {
            if (Provider.of<ProfileProvider>(context)
                    .userInfoModel!
                    .workerPermissions!
                    .addPinpoints ==
                1) {
              hasPermissions = true;
            } else {
              hasPermissions = false;
            }
          }
        }
        return hasPermissions == true
            ? Center(
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
                            file != null
                                ? InkWell(
                                    onTap: () {
                                      _choose();
                                    },
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(file!,
                                            width: 400,
                                            height: 300,
                                            fit: BoxFit.fill)))
                                : Align(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        _choose();
                                      },
                                      child: Container(
                                        height: 36,
                                        width: 300,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                              color: Colors.black38, width: 1),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("No Selected Image Yet",
                                                style: TextStyle(
                                                    color: Colors.black54)),
                                            SizedBox(width: 10),
                                            Icon(Icons.image,
                                                color: Colors.black54, size: 22)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                            // MaterialButton(
                            //   shape: RoundedRectangleBorder(
                            //     side: const BorderSide(color: Colors.black26),
                            //     borderRadius: BorderRadius.circular(10),
                            //   ),
                            //   minWidth: double.infinity,
                            //   height: 40,
                            //   onPressed: () => _choose(),
                            //   child: file != null
                            //       ? Image.file(file!, fit: BoxFit.cover)
                            //       : data != null
                            //           ? Image.network(
                            //               data!.path,
                            //               fit: BoxFit.cover,
                            //             )
                            //           : const Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //             children: [
                            //               Text("No Selected Image Yet", style: TextStyle(color: Colors.black54)),
                            //                SizedBox(width: 10),
                            //               Icon(Icons.image, color: Colors.black54, size: 22)
                            //             ],
                            //           ),
                            // ),
                            const SizedBox(height: 20),
                            Text(
                              'Details : ',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color,
                                  fontSize: 15),
                            ),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_SMALL),
                            TextField(
                              controller: _detailsController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Write here....',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.black38,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            workerProvider.isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Theme.of(context).primaryColor)))
                                : MaterialButton(
                                    minWidth: double.infinity,
                                    height: 45,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () =>
                                        _checkDistanceAndSaveTask(),
                                    child: const Text(
                                      "Save Task",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    " You don't have any permission to add tasks.  ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline2!.color,
                        fontSize: 16),
                  ),
                ),
              );
      }),
    );
  }
}
