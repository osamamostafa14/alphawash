import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateAreasScreen extends StatefulWidget {
  final UserInfoModel? user;
  UpdateAreasScreen({@required this.user});
  @override
  _UpdateAreasScreenState createState() => _UpdateAreasScreenState();
}

class _UpdateAreasScreenState extends State<UpdateAreasScreen> {
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

        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: const Text('Areas', style: TextStyle(color: Colors.white)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () => Navigator.pop(context)
          ),
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
                          child: locationProvider.areasListLoading || locationProvider.areasList == null?
                          Center(child: CircularProgressIndicator(valueColor:
                          AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))):
                          locationProvider.areasList!.isEmpty?
                          const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(child: Text('No saved areas yet')),
                          ):
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                itemCount: locationProvider.areasList!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  AreaModel _area = locationProvider.areasList![index];
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          locationProvider.updateUserAreasIds(_area.id!);
                                        },
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 8),

                                            Text('${_area.name}',
                                                style: const TextStyle(color: Colors.black87, fontSize: 16)),

                                            const Spacer(),

                                            Icon(
                                                locationProvider.userAreasIds.contains(_area.id)?
                                                Icons.check_box: Icons.check_box_outline_blank)
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

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(btnTxt: 'Update',
                      onTap: (){
                        locationProvider.updateUserAreas(locationProvider.userAreasIds, widget.user!.id!).then((value) {
                          if(value.isSuccess){
                            Provider.of<LocationProvider>(context, listen: false).getWorkerAreasList(context, widget.user!.id!);
                            showCustomSnackBar('Areas updated!', context, isError: false);
                            Navigator.pop(context);
                          }else{
                            showCustomSnackBar('Something went wrong', context);
                          }
                        });
                      }),
                ),

                const SizedBox(height: 15),

              ],
            );
          },
        )
    );
  }
}