import 'package:alphawash/view/base/border_button.dart';
import 'package:alphawash/view/screens/live_location_tracking/live_location_admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class WorkerLocationCardWidget extends StatelessWidget {
  final UserInfoModel? user;
  final bool hasLocation;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  WorkerLocationCardWidget(
      {required this.user,
      required this.hasLocation,
      required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (hasLocation) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserLocationPage(
                  userId: user!.id.toString(),
                  userName: user!.fullName.toString(),
                  // userImage: user!.image!,
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Sorry'),
                  content: Text('Location Data Not Available'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: BorderButton(
                          onTap: () => Navigator.pop(context),
                          btnTxt: 'ok',
                          borderColor: Colors.red),
                    )
                  ],
                );
              },
            );
            print('false ');
            print(user!.id.toString());
          }
        },
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined),
                const SizedBox(width: 5),
                Text(
                  '${user!.fullName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 17),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.black54),
              ],
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
