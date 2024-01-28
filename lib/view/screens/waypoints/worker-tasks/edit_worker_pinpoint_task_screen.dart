import 'dart:convert';
import 'dart:io';

import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/data/model/response/worker_task_model.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:alphawash/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditPinPointTasksDetailsScreen extends StatefulWidget {
  final String imageUrl;
  final String details;
  //final WorkerTaskModel? tasks;
  final PinPointsTaskModel? task;

  EditPinPointTasksDetailsScreen(
      {required this.imageUrl, required this.details, required this.task});

  @override
  State<EditPinPointTasksDetailsScreen> createState() =>
      _EditPinPointTasksDetailsScreenState();
}

class _EditPinPointTasksDetailsScreenState
    extends State<EditPinPointTasksDetailsScreen> {
  TextEditingController? _detailsController;
  File? file;
  PickedFile? data;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _detailsController = TextEditingController();
    _detailsController!.text = widget.details;
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
    FocusScope.of(context).unfocus();
    WorkerProvider workerProvider =
        Provider.of<WorkerProvider>(context, listen: false);

    var box = Hive.box('myBox');
    String token = box.get(AppConstants.TOKEN);
    String details = _detailsController!.text.trim();

    if (workerProvider.taskImageFile != null && details.isNotEmpty) {
      print('task id : ${widget.task!.id!}');
      print('details : $details');
      print('${workerProvider.taskImageFile}');
      print('token : $token');
      await workerProvider.updatePinPointTask(token, widget.task!.id!, details);
      showCustomSnackBar('success update', context, isError: false);
    } else {
      if (workerProvider.taskImageFile == null) {
        showCustomSnackBar('Please select an image!', context, isError: true);
      }
      if (details.isEmpty) {
        showCustomSnackBar('Text field is required!', context, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          centerTitle: true,
          title: Text('Task Details', style: TextStyle(color: Colors.white)),
        ),
        body:
            Consumer<WorkerProvider>(builder: (context, workerProvider, child) {
          bool hasPermissions = false;
          if (Provider.of<ProfileProvider>(context).userInfoModel!.userType ==
              'admin') {
            hasPermissions = true;
          } else {
            if (Provider.of<ProfileProvider>(context , listen: false)
                    .userInfoModel!
                    .workerPermissions !=
                null) {
              if (Provider.of<ProfileProvider>(context , listen: false)
                      .userInfoModel!
                      .workerPermissions!
                      .showPinpoints ==
                  1) {
                hasPermissions = true;
              } else {
                hasPermissions = false;
              }
            }
          }
          return Center(
              child: Scrollbar(
                child: SingleChildScrollView(
                    padding:
                    const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('Your Image Task : ',
                              //     style: TextStyle(
                              //         color: Theme.of(context)
                              //             .textTheme
                              //             .headline1!
                              //             .color,
                              //         fontSize: 15)),
                              const SizedBox(
                                  height: Dimensions.PADDING_SIZE_SMALL),
                              InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    Provider.of<ProfileProvider>(context,
                                        listen: false)
                                        .userInfoModel!
                                        .workerPermissions
                                        ?.editPinpoints ==
                                        0 ||
                                        Provider.of<ProfileProvider>(context , listen: false)
                                            .userInfoModel!
                                            .userType ==
                                            'admin'
                                        ? print("no permission")
                                        : _choose();
                                  },
                                  child: file != null
                                      ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(file!,
                                          fit: BoxFit.cover))
                                      : data != null
                                      ? ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      child: Image.network(data!.path,
                                          fit: BoxFit.cover))
                                      : ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      child: Image.network(
                                          '${Provider.of<SplashProvider>(
                                            context,
                                          ).baseUrls!.taskImageUrl}/${widget.imageUrl}',
                                          width: double.infinity,
                                          height: 300,
                                          fit: BoxFit.cover))),
                              const SizedBox(
                                  height: Dimensions.PADDING_SIZE_LARGE),
                              CustomTextField(
                                  hintText: 'Details of task',
                                  isShowBorder: true,
                                  maxLines: 3,
                                  dontEdit: Provider.of<ProfileProvider>(context,
                                      listen: false)
                                      .userInfoModel!
                                      .workerPermissions
                                      ?.editPinpoints ==
                                      0 ||
                                      Provider.of<ProfileProvider>(context  , listen: false)
                                          .userInfoModel!
                                          .userType ==
                                          'admin'
                                      ? true
                                      : false,
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.text,
                                  controller: _detailsController),
                              SizedBox(
                                height: 20,
                              ),
                              Provider.of<ProfileProvider>(context, listen: false)
                                  .userInfoModel!
                                  .workerPermissions
                                  ?.editPinpoints ==
                                  0 ||
                                  Provider.of<ProfileProvider>(context  ,listen: false )
                                      .userInfoModel!
                                      .userType ==
                                      'admin'
                                  ? Align(
                                alignment: Alignment.center,
                                child: Text(
                                    'You don\'t have permissions to edit pinpoint task!',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                              )
                                  : workerProvider.isLoading
                                  ? Center(
                                  child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                          Theme.of(context)
                                              .primaryColor)))
                                  : MaterialButton(
                                minWidth: double.infinity,
                                height: 50,
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  _checkDistanceAndSaveTask()
                                      .then((value) {
                                    workerProvider.getOldTasks(context,
                                        widget.task!.pinpointId!);
                                  });
                                },
                                child: Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10)),
                              )
                            ]))),
              ));
          // return hasPermissions == true
          //     ? Center(
          //         child: Scrollbar(
          //         child: SingleChildScrollView(
          //             padding:
          //                 const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          //             physics: const BouncingScrollPhysics(),
          //             child: Center(
          //                 child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                   // Text('Your Image Task : ',
          //                   //     style: TextStyle(
          //                   //         color: Theme.of(context)
          //                   //             .textTheme
          //                   //             .headline1!
          //                   //             .color,
          //                   //         fontSize: 15)),
          //                   const SizedBox(
          //                       height: Dimensions.PADDING_SIZE_SMALL),
          //                   InkWell(
          //                       borderRadius: BorderRadius.circular(10),
          //                       onTap: () {
          //                         Provider.of<ProfileProvider>(context,
          //                                             listen: false)
          //                                         .userInfoModel!
          //                                         .workerPermissions
          //                                         ?.editPinpoints ==
          //                                     0 ||
          //                                 Provider.of<ProfileProvider>(context)
          //                                         .userInfoModel!
          //                                         .userType ==
          //                                     'admin'
          //                             ? print("no permission")
          //                             : _choose();
          //                       },
          //                       child: file != null
          //                           ? ClipRRect(
          //                               borderRadius: BorderRadius.circular(10),
          //                               child: Image.file(file!,
          //                                   fit: BoxFit.cover))
          //                           : data != null
          //                               ? ClipRRect(
          //                                   borderRadius:
          //                                       BorderRadius.circular(10),
          //                                   child: Image.network(data!.path,
          //                                       fit: BoxFit.cover))
          //                               : ClipRRect(
          //                                   borderRadius:
          //                                       BorderRadius.circular(10),
          //                                   child: Image.network(
          //                                       '${Provider.of<SplashProvider>(
          //                                         context,
          //                                       ).baseUrls!.taskImageUrl}/${widget.imageUrl}',
          //                                       width: double.infinity,
          //                                       height: 300,
          //                                       fit: BoxFit.cover))),
          //                   const SizedBox(
          //                       height: Dimensions.PADDING_SIZE_LARGE),
          //                   CustomTextField(
          //                       hintText: 'Details of task',
          //                       isShowBorder: true,
          //                       maxLines: 3,
          //                       dontEdit: Provider.of<ProfileProvider>(context,
          //                                           listen: false)
          //                                       .userInfoModel!
          //                                       .workerPermissions
          //                                       ?.editPinpoints ==
          //                                   0 ||
          //                               Provider.of<ProfileProvider>(context)
          //                                       .userInfoModel!
          //                                       .userType ==
          //                                   'admin'
          //                           ? true
          //                           : false,
          //                       inputAction: TextInputAction.done,
          //                       inputType: TextInputType.text,
          //                       controller: _detailsController),
          //                   SizedBox(
          //                     height: 20,
          //                   ),
          //                   Provider.of<ProfileProvider>(context, listen: false)
          //                                   .userInfoModel!
          //                                   .workerPermissions
          //                                   ?.editPinpoints ==
          //                               0 ||
          //                           Provider.of<ProfileProvider>(context)
          //                                   .userInfoModel!
          //                                   .userType ==
          //                               'admin'
          //                       ? Align(
          //                           alignment: Alignment.center,
          //                           child: Text(
          //                               'You don\'t have permissions to edit pinpoint task!',
          //                               style: TextStyle(
          //                                   color: Colors.black87,
          //                                   fontWeight: FontWeight.w500,
          //                                   fontSize: 14)),
          //                         )
          //                       : workerProvider.isLoading
          //                           ? Center(
          //                               child: CircularProgressIndicator(
          //                                   valueColor:
          //                                       AlwaysStoppedAnimation<Color>(
          //                                           Theme.of(context)
          //                                               .primaryColor)))
          //                           : MaterialButton(
          //                               minWidth: double.infinity,
          //                               height: 50,
          //                               color: Theme.of(context).primaryColor,
          //                               onPressed: () {
          //                                 _checkDistanceAndSaveTask()
          //                                     .then((value) {
          //                                   workerProvider.getOldTasks(context,
          //                                       widget.task!.pinpointId!);
          //                                 });
          //                               },
          //                               child: Text(
          //                                 "Update",
          //                                 style: TextStyle(color: Colors.white),
          //                               ),
          //                               shape: RoundedRectangleBorder(
          //                                   borderRadius:
          //                                       BorderRadius.circular(10)),
          //                             )
          //                 ]))),
          //       ))
          //     : Center(
          //         child: Scrollbar(
          //             child: SingleChildScrollView(
          //                 padding: const EdgeInsets.all(
          //                     Dimensions.PADDING_SIZE_LARGE),
          //                 physics: const BouncingScrollPhysics(),
          //                 child: Center(
          //                     child: Column(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                       Text('Task Image:',
          //                           style: TextStyle(
          //                               color: Theme.of(context)
          //                                   .textTheme
          //                                   .headline1!
          //                                   .color,
          //                               fontSize: 15)),
          //                       const SizedBox(
          //                           height: Dimensions.PADDING_SIZE_SMALL),
          //                       ClipRRect(
          //                         borderRadius: BorderRadius.circular(10),
          //                         child: Image.network(
          //                             '${Provider.of<SplashProvider>(
          //                               context,
          //                             ).baseUrls!.taskImageUrl}/${widget.imageUrl}',
          //                             width: double.infinity,
          //                             height: 300,
          //                             fit: BoxFit.cover),
          //                       ),
          //                       const SizedBox(
          //                           height: Dimensions.PADDING_SIZE_LARGE),
          //                       Text('Task details:',
          //                           style: TextStyle(
          //                               color: Theme.of(context)
          //                                   .textTheme
          //                                   .headline1!
          //                                   .color,
          //                               fontSize: 15)),
          //                       const SizedBox(
          //                           height: Dimensions.PADDING_SIZE_SMALL),
          //                       Container(
          //                         width: double.infinity,
          //                         decoration: BoxDecoration(
          //                             borderRadius: BorderRadius.circular(10),
          //                             border: Border.all(color: Colors.black)),
          //                         child: Padding(
          //                           padding: const EdgeInsets.all(15.0),
          //                           child: Text(
          //                             _detailsController!.text,
          //                             textAlign: TextAlign.justify,
          //                             style: const TextStyle(fontSize: 14),
          //                           ),
          //                         ),
          //                       ),
          //                       const SizedBox(
          //                         height: 20,
          //                       ),
          //                     ])))));
        }));
  }
}
