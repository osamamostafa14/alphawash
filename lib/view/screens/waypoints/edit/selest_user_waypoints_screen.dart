import 'dart:async';

import 'package:alphawash/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/utill/dimensions.dart';

import '../../../../data/model/response/base/api_response.dart';
import '../../../../data/model/response/user_info_model.dart';
import '../../../../data/model/response/waypoint_model.dart';
import '../../../../data/repository/worker_repo.dart';
import '../../../../provider/worker_provider.dart';

class SelectUserScreen extends StatefulWidget {
  final WaypointModel? waypoint;
  SelectUserScreen({@required this.waypoint});
  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
   //   print('${widget.waypoint!.pinPoints![0].}');

    });
    super.initState();
  }

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
      body: Consumer<WorkerProvider>(
        builder: (context, workerProvider, child) {
          return SafeArea(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        workerProvider.workersListLoading ||
                                workerProvider.workersList == null
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            : workerProvider.workersList!.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Center(
                                      child: Text('No saved users yet'),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount:
                                        workerProvider.workersList!.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      UserInfoModel _user =
                                          workerProvider.workersList![index];
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.37,
                                                child: Text(
                                                  '${_user!.fullName}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Checkbox(
                                                value: workerProvider
                                                    .isUserSelected(
                                                        _user.id ?? 0,
                                                        widget.waypoint?.id),
                                                onChanged:
                                                    (bool? newValue) async {
                                                  int? userId = _user.id;
                                                  int waypointId =
                                                      widget.waypoint?.id ?? 0;
                                                  workerProvider.toggleSelected(
                                                      userId, waypointId);
                                                  await workerProvider.SendselectUserWaypoint();

                                                    },
                                              ),
                                            ],
                                          ),
                                          Divider()
                                        ],
                                      );
                                    },
                                  ),
                      ],
                    ),
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
