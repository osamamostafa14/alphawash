import 'dart:async';

import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/utill/dimensions.dart';

class SelectWorkerScreen extends StatefulWidget {
  // final WaypointModel? waypoint;
  // SelectUserScreen({@required this.waypoint});
  @override
  State<SelectWorkerScreen> createState() => _SelectWorkerScreenState();
}

class _SelectWorkerScreenState extends State<SelectWorkerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      Provider.of<WorkerProvider>(context, listen: false)
          .getWorkersList(context);
      Provider.of<LocationProvider>(context, listen: false)
          .getAreasList(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text('Select User', style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () => Navigator.pop(context)),
      ),
      key: _scaffoldKey,
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
                    child: workerProvider.workersListLoading ||
                            workerProvider.workersList == null
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor)))
                        : workerProvider.workersList!.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 100),
                                child:
                                    Center(child: Text('No saved users yet')),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
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
                                                value: _user.id ==
                                                    workerProvider
                                                        .selectedWorkerId,
                                                onChanged: (value) {
                                                  int? id = _user.id;
                                                  workerProvider
                                                      .setSelectedWorkerId(id!);
                                                  print(_user.id);
                                                  Navigator.pop(context, _user);
                                                },
                                              )
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
