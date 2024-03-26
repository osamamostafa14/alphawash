import 'dart:async';
import 'package:alphawash/view/screens/live_location_tracking/track_admin_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/view/screens/live_location_tracking/worker_location_card_widget.dart';
import 'package:alphawash/utill/dimensions.dart';

class LiveLocationWorkerListScreen extends StatefulWidget {
  @override
  _LiveLocationWorkerListScreenState createState() =>
      _LiveLocationWorkerListScreenState();
}

class _LiveLocationWorkerListScreenState
    extends State<LiveLocationWorkerListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      Provider.of<WorkerProvider>(context, listen: false)
          .getWorkersList(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title:
            const Text('Users Location', style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () => Navigator.pop(context)),
      ),
      body: Consumer<WorkerProvider>(
        builder: (context, workerProvider, child) {
          return Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('worker_locations_tracking')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      );
                    }

                    List<String> workerNames = snapshot.data!.docs
                        .map((doc) =>
                            (doc.data() as Map<String, dynamic>)['name']
                                .toString())
                        .toList();
                    return Scrollbar(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding:
                            const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: Center(
                          child: workerProvider.workersList == null
                              ? Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor)))
                              : SizedBox(
                                  width: 1170,
                                  child: workerProvider.workersList!.isEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.only(top: 100),
                                          child: Center(
                                              child:
                                                  Text('No saved users yet')),
                                        )
                                      : Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, left: 8, right: 8),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            TrackAdminLocationScreen()));
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons
                                                          .location_on_outlined),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        'My Location',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 17),
                                                      ),
                                                      Spacer(),
                                                      Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                          color:
                                                              Colors.black54),
                                                    ],
                                                  ),
                                                  const Divider()
                                                ],
                                              ),
                                            ),
                                          ),
                                          ListView.builder(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            itemCount: workerProvider
                                                .workersList!.length,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              UserInfoModel _user =
                                                  workerProvider
                                                      .workersList![index];
                                              bool hasLocation = workerNames
                                                  .contains(_user.fullName);
                                              return WorkerLocationCardWidget(
                                                user: _user,
                                                hasLocation: hasLocation,
                                                scaffoldKey: _scaffoldKey,
                                              );
                                            },
                                          ),
                                        ]),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }
}
