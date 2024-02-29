import 'dart:async';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/screens/users/add_user_screen.dart';
import 'package:alphawash/view/screens/users/widgets/user_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  ScrollController scrollController =  ScrollController();

  @override
  void initState() {
    Timer(const Duration(seconds: 0), () {
      if(Provider.of<WorkerProvider>(context, listen: false).workersList==null){
        Provider.of<WorkerProvider>(context, listen: false).getWorkersList(context);
      }

      Provider.of<LocationProvider>(context, listen: false).getAreasList(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                AddUserScreen()));
          },
          tooltip: 'Add',
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: const Text('Users', style: TextStyle(color: Colors.white)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () =>  Navigator.pop(context)
          ),
        ),

        body: Consumer<WorkerProvider>(
          builder: (context, workerProvider, child) {

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
                          child: workerProvider.workersListLoading || workerProvider.workersList == null?
                          Center(child: CircularProgressIndicator(valueColor:
                          AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))):
                          workerProvider.workersList!.isEmpty?
                          const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(child: Text('No saved users yet')),
                          ):
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                itemCount: workerProvider.workersList!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  UserInfoModel _user = workerProvider.workersList![index];
                                  return UserCardWidget(user: _user, scaffoldKey: _scaffoldKey);
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
