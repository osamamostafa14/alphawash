import 'package:alphawash/data/model/response/user_area_model.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/screens/users/area/update_areas_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAreasScreen extends StatefulWidget {
  final UserInfoModel? user;
  UserAreasScreen({@required this.user});
  @override
  _UserAreasScreenState createState() => _UserAreasScreenState();
}

class _UserAreasScreenState extends State<UserAreasScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();

  ScrollController scrollController =  ScrollController();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                UpdateAreasScreen(user: widget.user)));
            Provider.of<LocationProvider>(context, listen: false).resetSearch();
          },
          tooltip: 'Add',
          child: const Icon(Icons.add),
        ),
        body: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {

            return Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Center(
                        child: SizedBox(
                          width: 1170,
                          child: locationProvider.userAreasLoading || locationProvider.workerAreasList == null?
                          Center(child: CircularProgressIndicator(valueColor:
                          AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))):
                          locationProvider.workerAreasList!.isEmpty?
                          const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(child: Text('No saved areas yet')),
                          ):
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                itemCount: locationProvider.workerAreasList!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  UserAreaModel _area = locationProvider.workerAreasList![index];
                                  return Column(
                                   children: [
                                     InkWell(
                                       onTap: () {
                                         locationProvider.updateUserAreasIds(_area.id!);
                                       },
                                       child: Row(
                                         children: [
                                           const SizedBox(width: 8),

                                           Text('${_area.area!.name}',
                                               style: const TextStyle(color: Colors.black87,
                                                   fontSize: 16, fontWeight: FontWeight.w500)),

                                           const Spacer(),

                                           const Icon(Icons.arrow_forward_ios, color: Colors.black54),

                                         ],
                                       ),
                                     ),

                                   const Padding(
                                       padding: EdgeInsets.only(top: 6, bottom: 6),
                                       child: Divider(),
                                     )
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
                ),

                const SizedBox(height: 15),

              ],
            );
          },
        )
    );
  }
}