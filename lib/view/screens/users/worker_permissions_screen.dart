import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/provider/profile_provider.dart';

import 'package:alphawash/utill/dimensions.dart';

import 'package:flutter/material.dart';

class WorkerPermissionScreen extends StatefulWidget {
  final UserInfoModel? user;
  WorkerPermissionScreen({@required this.user});

  @override
  _WorkerPermissionScreenState createState() => _WorkerPermissionScreenState();
}

class _WorkerPermissionScreenState extends State<WorkerPermissionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<WorkerProvider>(
        builder: (context, workerProvider, child) {
          return Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              title: const Text('Map'),
                              value: workerProvider.workerPermission?.area == 1
                                  ? true
                                  : false,
                              onChanged: (bool? value) async {
                                print("value : ${value}");
                                workerProvider.updateWorkerPermissions(
                                    value == true ? 1 : 0, "area");
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Divider(),
                            ),
                            CheckboxListTile(
                              title: const Text('Waypoints'),
                              value:
                                  workerProvider.workerPermission?.waypoints ==
                                          1
                                      ? true
                                      : false,
                              onChanged: (bool? value) async {
                                workerProvider.updateWorkerPermissions(
                                    value == true ? 1 : 0, "waypoints");
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Divider(),
                            ),
                            CheckboxListTile(
                              title: const Text('Add Pinpoint Task'),
                              value: workerProvider
                                          .workerPermission?.addPinpoints ==
                                      1
                                  ? true
                                  : false,
                              onChanged: (bool? value) async {
                                workerProvider.updateWorkerPermissions(
                                    value == true ? 1 : 0, "add_pinpoint_task");
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Divider(),
                            ),
                            CheckboxListTile(
                              title: const Text('Show Pinpoints Tasks'),
                              value: workerProvider
                                          .workerPermission?.showPinpoints ==
                                      1
                                  ? true
                                  : false,
                              onChanged: (bool? value) async {
                                workerProvider.updateWorkerPermissions(
                                    value == true ? 1 : 0,
                                    "show_pinpoint_tasks");
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Divider(),
                            ),
                            CheckboxListTile(
                              title: const Text('Edit Pinpoint task'),
                              value: workerProvider
                                          .workerPermission?.editPinpoints ==
                                      1
                                  ? true
                                  : false,
                              onChanged: (bool? value) async {
                                workerProvider.updateWorkerPermissions(
                                    value == true ? 1 : 0,
                                    "edit_pinpoint_task");
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Divider(),
                            ),
                            CheckboxListTile(
                              title: const Text('Tasks'),
                              value: workerProvider.workerPermission?.tasks == 1
                                  ? true
                                  : false,
                              onChanged: (bool? value) async {
                                workerProvider.updateWorkerPermissions(
                                    value == true ? 1 : 0, "tasks");
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Divider(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              workerProvider.workerPermissionsLoading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 60),
                      child: CustomButton(
                          btnTxt: 'Update',
                          onTap: () async {

                            FocusScope.of(context).unfocus();
                            int areas =
                                workerProvider.workerPermission!.area!;
                            print('areas=> ${areas}');
                            int waypoints =
                                workerProvider.workerPermission!.waypoints!;
                            int addPinpointTask =
                                workerProvider.workerPermission!.addPinpoints!;
                            int showPinpointTasks = workerProvider
                                        .workerPermission!.showPinpoints!;
                            int editPinpointTask = workerProvider
                                        .workerPermission!.editPinpoints!;
                            int tasks =
                                workerProvider.workerPermission!.tasks!;
                            await workerProvider.workerPermissions(
                              areas,
                              waypoints,
                              addPinpointTask,
                              showPinpointTasks,
                              editPinpointTask,
                              tasks,
                              widget.user!.id!.toInt(),
                            );
                            // await workerProvider
                            //     .workerPermissions(widget.user!.id!.toInt());

                            showCustomSnackBar(
                                'Checked Permission Done', context,
                                isError: false);
                          })),
            ],
          );
        },
      ),
    );
  }
}
