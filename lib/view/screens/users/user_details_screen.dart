import 'dart:async';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/styles.dart';
import 'package:alphawash/view/screens/users/area/user_areas_screen.dart';
import 'package:alphawash/view/screens/users/worker_permissions_screen.dart';
import 'package:alphawash/view/screens/users/user_personal_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserInfoModel? user;
  UserDetailsScreen({@required this.user});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);

    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        onTabTapped(_tabController!.index);
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      Provider.of<LocationProvider>(context, listen: false)
          .getAreasList(context);
      Provider.of<LocationProvider>(context, listen: false)
          .getWorkerAreasList(context, widget.user!.id!);
    });
  }

  void onTabTapped(int tabIndex) {
    if (tabIndex == 0) {
      _tabIndex = 0;
    } else if (tabIndex == 1) {
      _tabIndex = 1;
      Provider.of<WorkerProvider>(context, listen: false)
          .initWorkerPermissions(widget.user!.workerPermissions!);
    } else if (tabIndex == 2) {
      _tabIndex = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.pop(context)),
            centerTitle: true),
        body: Column(children: [
          Container(
              width: 1170,
              color: Colors.white,
              child: TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).textTheme.bodyText1!.color,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3,
                  unselectedLabelStyle: rubikRegular.copyWith(
                      color: ColorResources.COLOR_HINT,
                      fontSize: Dimensions.FONT_SIZE_SMALL),
                  labelStyle: rubikMedium.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL),
                  tabs: const [
                    Tab(text: 'Profile'),
                    Tab(text: 'Permissions'),
                    Tab(text: 'Areas')
                  ])),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
            UserPersonalInfo(user: widget.user),
            WorkerPermissionScreen(user: widget.user),
            UserAreasScreen(user: widget.user)
          ]))
        ]));
  }
}
