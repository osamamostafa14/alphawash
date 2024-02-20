import 'dart:async';
import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/provider/worker/worker_area_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/screens/location/widget/area_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkerAreasScreen extends StatefulWidget {

  @override
  _WorkerAreasScreenState createState() => _WorkerAreasScreenState();
}

class _WorkerAreasScreenState extends State<WorkerAreasScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();

  ScrollController scrollController =  ScrollController();

  @override
  void initState() {
    Timer(const Duration(seconds: 0), () {
      Provider.of<WorkerAreaProvider>(context, listen: false).getAreasList(context);
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
          title: const Text('Areas', style: TextStyle(color: Colors.white)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () => Navigator.pop(context)
          ),
        ),

        body: Consumer<WorkerAreaProvider>(
          builder: (context, workerAreaProvider, child) {

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
                          child: workerAreaProvider.areasListLoading || workerAreaProvider.areasList == null?
                          Center(child: CircularProgressIndicator(valueColor:
                          AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))):
                          workerAreaProvider.areasList!.isEmpty?
                          const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(child: Text('No areas yet')),
                          ):
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                itemCount: workerAreaProvider.areasList!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  AreaModel _area = workerAreaProvider.areasList![index];
                                  return AreaWidget(area: _area, scaffoldKey: _scaffoldKey);
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


