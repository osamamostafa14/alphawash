import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/view/base/border_button.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:alphawash/view/screens/users/user_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class UserCardWidget extends StatelessWidget {
  final UserInfoModel? user;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  UserCardWidget({@required this.user, @required this.scaffoldKey});
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkerProvider>(
      builder: (context, workerProvider, child) {
        // void showSnackBar(bool error) {
        //   if(error == true){
        //     showCustomSnackBar('Worker removed successfully', context, isError:false);
        //   }else{
        //     showCustomSnackBar('Something went wrong', context);
        //   }
        // }

        // void showSnackBar(bool error, GlobalKey<ScaffoldMessengerState> globalKey) {
        //   globalKey.currentState!.showSnackBar(SnackBar(
        //     backgroundColor: error ? Colors.red : Colors.green,
        //     duration: Duration(seconds: 3),
        //     content: Text(
        //       error ? 'Something went wrong' : 'Worker removed successfully',
        //       textAlign: TextAlign.center,
        //     ),
        //   ));
        // }

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          UserDetailsScreen(user: user)));
            },
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.05),
                  ),
                  BoxShadow(
                    offset: const Offset(2, 0),
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.05),
                  ),
                  BoxShadow(
                    offset: const Offset(0, -2),
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.05),
                  ),
                  BoxShadow(
                    offset: const Offset(-2, 0),
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                    child: user!.image != null
                        ? CachedNetworkImage(
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            imageUrl:
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.userImageUrl}/${user!.image}',
                            cacheKey:
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.userImageUrl}/${user!.image}',
                            // placeholder: Image.asset('assets/images/placeholder.png'),
                          )
                        : Container(
                            height: 80,
                            width: 80,
                            child: Icon(Icons.person,
                                size: 30, color: Colors.black54)),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.37,
                              child: Text('${user!.fullName}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.black87)),
                            ),
                            const Spacer(),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                    context: scaffoldKey!.currentContext!,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Are you sure?',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 15)),
                                        content: Text(
                                            'Do you want to remove this worker?',
                                            style: TextStyle(fontSize: 13)),
                                        actions: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                BorderButton(
                                                  onTap: () {
                                                    print("");
                                                    Navigator.pop(context);
                                                  },
                                                  btnTxt: 'No',
                                                  borderColor: Colors.black26,
                                                ),
                                                const SizedBox(width: 10),
                                                BorderButton(
                                                  onTap: () {
                                                    print("");
                                                    workerProvider
                                                        .removeWorker(user!.id!)
                                                        .then((value) {
                                                      if (value.isSuccess) {
                                                        workerProvider
                                                            .getWorkersList(
                                                                context);

                                                        showCustomSnackBar(
                                                            'Worker removed successfully',
                                                            scaffoldKey!
                                                                .currentContext!,
                                                            isError: false);
                                                        Navigator.pop(context);
                                                      } else {
                                                        showCustomSnackBar(
                                                            'Something went wrong',
                                                            scaffoldKey!
                                                                .currentContext!);
                                                      }
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  btnTxt: 'Yes',
                                                  borderColor: Colors.black26,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(Icons.delete,
                                    color: Colors.black54)),
                            const SizedBox(width: 15)
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
