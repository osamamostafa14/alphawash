import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/screens/location/add_location_screen.dart';
import 'package:alphawash/view/screens/location/widget/area_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectAreaScreen extends StatefulWidget {

  @override
  _SelectAreaScreenState createState() => _SelectAreaScreenState();
}

class _SelectAreaScreenState extends State<SelectAreaScreen> {
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
          elevation: 0.2,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text('Select area', style: TextStyle(color: Colors.black87)),
          leading: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.black87,
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
                                padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
                                itemCount: locationProvider.areasList!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  AreaModel _area = locationProvider.areasList![index];
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          locationProvider.setSearchedArea(_area);
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 8),

                                            Text('${_area.name}',
                                                style: const TextStyle(color: Colors.black87,
                                                    fontSize: 16, fontWeight: FontWeight.w500)),

                                            const Spacer(),

                                          Text('Select', style: TextStyle(fontSize: 12, color: Colors.black45))

                                          //  const Icon(Icons.check, color: Colors.black54),

                                          ],
                                        ),
                                      ),

                                      const Padding(
                                        padding: EdgeInsets.only(top: 10, bottom: 6),
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