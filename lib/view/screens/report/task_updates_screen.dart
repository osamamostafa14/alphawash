import 'dart:async';
import 'package:alphawash/data/helper/date_converter.dart';
import 'package:alphawash/data/model/response/task_report_model.dart';
import 'package:alphawash/provider/ReportProvider.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/screens/report/report_filter_widget.dart';
import 'package:alphawash/view/screens/report/updates_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/utill/dimensions.dart';

class TaskUpdatesScreen extends StatefulWidget {
  @override
  State<TaskUpdatesScreen> createState() => _TaskUpdatesScreenState();
}

class _TaskUpdatesScreenState extends State<TaskUpdatesScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 0), () {
      Provider.of<ReportProvider>(context, listen: false).clearOffset();
      Provider.of<ReportProvider>(context, listen: false)
          .getTaskUpdates(context, '1', 'all', '', '', 'all');
    });
    super.initState();
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext? context) {
    return Scaffold(
        backgroundColor: ColorResources.COLOR_BACKGROUND,
        
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context!).primaryColor,
          centerTitle: true,
          title: const Text('Reports', style: TextStyle(color: Colors.white)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () => Navigator.pop(context)),
        ),
        body: Consumer<ReportProvider>(
            builder: (context, reportProvider, child) {
              int? tasksLength;
              int? totalSize;
              if (reportProvider.taskUpdatesList != null) {
                tasksLength = reportProvider.taskUpdatesList?.length ?? 0;
                totalSize = reportProvider.totalSize ?? 0;
              }

              return Column(children: [

                const SizedBox(height: 20),
                reportProvider.isLoading? const SizedBox():
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
                  child: Row(
                    children: [

                      Expanded(
                        child: Container(
                          height: 65,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFf9bb8a), Color(0xFFf99597)], // specify your gradient colors
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius:  BorderRadius.all(Radius.circular(4.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text('All', style:
                                TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14)),

                                const SizedBox(height: 5),

                                Text('${reportProvider.totalPinpointTasks} Sign', style:
                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Container(
                          height: 65,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF40e4e3), Color(0xFF4ca7f6)], // specify your gradient colors
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                          ),
                          child:  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Updated', style:
                                TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14)),

                                const SizedBox(height: 5),

                                Text('${reportProvider.updatedTasksCount} updated signs', style:
                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                reportProvider.isLoading? const SizedBox():
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
                  child: Row(
                    children: [

                      Expanded(
                        child: Container(
                          height: 65,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFea89f4), Color(0xFF9880f8)], // specify your gradient colors
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius:  BorderRadius.all(Radius.circular(4.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('New', style:
                                TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14)),

                                const SizedBox(height: 5),

                                Text('${reportProvider.newTasksCount} new placed signs', style:
                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Container(
                          height: 65,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF40e4e3), Color(0xFF4ca7f6)], // specify your gradient colors
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          ),
                          child:  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Not updated', style:
                                TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14)),

                                const SizedBox(height: 5),

                                Text('${reportProvider.tasksWithoutUpdates.length} signs', style:
                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                        onTap: () {
                          reportProvider.setFilterVisibility();
                        },
                        child: Container(
                          width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: reportProvider.showFilter? Theme.of(context).primaryColor: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                               border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Image.asset(Images.filter_icon, height: 18,
                                  color:  reportProvider.showFilter? Colors.white: Theme.of(context).primaryColor),
                            ))),
                  ),
                ),

                reportProvider.showFilter?
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                        'Date:',
                        style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ): const SizedBox(),

                reportProvider.showFilter?
                ReportFilterWidget(): const SizedBox(),

                reportProvider.showFilter?
                const SizedBox(height: 10): const SizedBox(),

                reportProvider.showFilter?
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                        'Type:',
                        style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ): const SizedBox(),

                reportProvider.showFilter?
                Align(
                    alignment: Alignment.centerLeft,
                    child: UpdatesTypeWidget()): const SizedBox(),

                Expanded(
                    child: Scrollbar(
                        child: SingleChildScrollView(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            child: Center(
                                child: SizedBox(
                                    width: 1170,
                                    child: reportProvider.isLoading
                                        ? Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              Theme.of(context)
                                                  .primaryColor)),
                                    )
                                        : reportProvider.taskUpdatesList == null
                                        ? const Center(child: Text(''))
                                        : reportProvider.taskUpdatesList!.isNotEmpty
                                        ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              ListView.builder(
                                                padding:
                                                const EdgeInsets.only(top: 15, bottom: 15),
                                                itemCount: reportProvider.taskUpdatesList!.length,
                                                physics:
                                                const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  TaskUpdateModel _taskUpdate = reportProvider.taskUpdatesList![index];
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.all(5),
                                                        child: InkWell(
                                                          onTap: () {

                                                          },
                                                          child:  Row(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.circular(50),
                                                                child: _taskUpdate.pinpointTask!.user!.image !=
                                                                    null
                                                                    ? FadeInImage.assetNetwork(
                                                                  placeholder: Images.profile_icon,
                                                                  image: '${Provider.of<SplashProvider>(
                                                                    context,
                                                                  ).baseUrls!.userImageUrl}/${_taskUpdate.pinpointTask!.user!.image}',
                                                                  height: 40,
                                                                  width: 40,
                                                                  fit: BoxFit.cover,
                                                                )
                                                                    :  Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    child: const Icon(Icons.person,
                                                                        size: 30, color: Colors.black54)),
                                                              ),
                                                              const SizedBox(width: 18),
                                                              SizedBox(
                                                                width: 140,
                                                                child: Text(
                                                                    '${_taskUpdate.pinpointTask!.user!.fullName}',
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: const TextStyle(color: Colors.black87, fontSize: 15)),
                                                              ),

                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                      '${DateConverter.isoStringToLocalTimeOnly(_taskUpdate.createdAt!)}',
                                                                      style: const TextStyle(color: Colors.black54, fontSize: 12)),

                                                                  const SizedBox(height: 4),

                                                                  Text(
                                                                      '${DateConverter.monthYear(_taskUpdate.createdAt!)}',
                                                                      style: const TextStyle(color: Colors.black54, fontSize: 13)),
                                                                ],
                                                              ),

                                                              const Spacer(),
                                                              Container(
                                                                height: 23,
                                                                width: 55,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(50),
                                                                  color: _taskUpdate.type=='new'? Colors.redAccent: Colors.lightBlue
                                                                ),
                                                                child: Center(child: Text('${_taskUpdate.type}', style: TextStyle(color: Colors.white))),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets.all(0),
                                                        child: Divider(),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              reportProvider
                                                  .bottomIsLoading
                                                  ? Padding(
                                                padding:
                                                const EdgeInsets.only(top: 10),
                                                child: Center(
                                                    child: CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<
                                                            Color>(Theme.of(
                                                            context)
                                                            .primaryColor))),
                                              )
                                                  : tasksLength! <
                                                  totalSize!
                                                  ? Center(
                                                  child:
                                                  GestureDetector(
                                                      onTap:
                                                          () {
                                                        String
                                                        offset =
                                                            reportProvider.taskUpdatesOffset ?? '';
                                                        int offsetInt =
                                                            int.parse(offset) + 1;
                                                        reportProvider.showBottomTasksLoader();

                                                        Provider.of<ReportProvider>(context, listen: false)
                                                            .getTaskUpdates(context, offsetInt.toString(), reportProvider.selectedFilterType.toLowerCase(), '', '', reportProvider.updatesType);

                                                      },
                                                      child: Text(
                                                          'Load more',
                                                          style:
                                                          TextStyle(color: Theme.of(context).primaryColor))))
                                                  : const SizedBox()
                                            ]),
                                          ),
                                        )
                                        : Center(
                                        child:
                                        Text('No updates yet'))))))),
                const SizedBox(height: 15)
              ]);
            }));
  }
}
