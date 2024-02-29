import 'dart:async';
import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/screens/location/add_location_screen.dart';
import 'package:alphawash/view/screens/location/all_areas_map.dart';
import 'package:alphawash/view/screens/location/widget/area_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AreasListScreen extends StatefulWidget {
  @override
  _AreasListScreenState createState() => _AreasListScreenState();
}

class _AreasListScreenState extends State<AreasListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Timer(const Duration(seconds: 0), () {
      Provider.of<LocationProvider>(context, listen: false)
          .getAreasList(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: (){
        //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
        //         AddLocationScreen()));
        //     Provider.of<LocationProvider>(context, listen: false).resetSearch();
        //   },
        //   tooltip: 'Add',
        //   child: const Icon(Icons.add),
        // ),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: const Text('Map', style: TextStyle(color: Colors.white)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () => Navigator.pop(context)),
        ),
        body: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            return Column(
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AllAreasMap()));
                        },
                        child: Text('Show the full map',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15)),
                      ),
                    )),
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
                          child: locationProvider.areasListLoading ||
                                  locationProvider.areasList == null
                              ? Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor)))
                              : locationProvider.areasList!.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.only(top: 100),
                                      child: Center(
                                          child: Text('No saved areas yet')),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListView.builder(
                                          //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                          itemCount: locationProvider
                                              .areasList!.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            AreaModel _area = locationProvider
                                                .areasList![index];
                                            return AreaWidget(
                                                area: _area,
                                                scaffoldKey: _scaffoldKey);
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
        ));
  }
}
