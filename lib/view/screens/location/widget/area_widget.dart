import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/view/base/border_button.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:alphawash/view/screens/location/edit_area_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AreaWidget extends StatelessWidget {
  final AreaModel? area;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  AreaWidget({@required this.area, @required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {

    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {

        return  Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
          child: InkWell(
            onTap: () {
              locationProvider.setSelectedArea(area!);
              locationProvider.setAreaName(area!.name!);
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                  EditAreaScreen(area: area)));
            },
            child: Container(
              height: 80,
              decoration:  BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                boxShadow: [

                  BoxShadow(
                    offset: const Offset(0, -0.5),
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.05),
                  ),
                  BoxShadow(
                    offset: const Offset(-0.5, 0),
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                      const SizedBox(height: 10),

                        Text('${area!.name}',
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black87
                            )),

                        // Row(
                        //   children: [
                        //     const SizedBox(width: 20),
                        //
                        //     SizedBox(
                        //       width: MediaQuery.of(context).size.width * 0.37,
                        //       child: Text('${area!.name}',
                        //           maxLines: 2, overflow: TextOverflow.ellipsis,
                        //           style: const TextStyle(
                        //               fontFamily: 'Roboto',
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 16.0,
                        //               color: Colors.black87
                        //           )),
                        //     ),
                        //
                        //     const Spacer(),
                        //
                        //     InkWell(
                        //         onTap: () {
                        //           showDialog(
                        //             context: scaffoldKey!.currentContext!,
                        //             builder: (context) {
                        //               return AlertDialog(
                        //                 title: Text('Are you sure?',
                        //                     style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15)),
                        //                 content: const Text('Do you want to remove this area?',
                        //                     style: TextStyle(fontSize: 13)),
                        //                 actions: [
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(bottom: 10),
                        //                     child: Row(
                        //                       mainAxisAlignment: MainAxisAlignment.center,
                        //                       children: [
                        //                         BorderButton(
                        //                           onTap: () {
                        //                             Navigator.pop(context);
                        //                           },
                        //                           btnTxt: 'No',
                        //                           borderColor: Colors.black26,
                        //                         ),
                        //
                        //                         const SizedBox(width: 10),
                        //
                        //                         BorderButton(
                        //                           onTap: () {
                        //                             locationProvider.removeArea(area!.id!).then((value) {
                        //                               if(value.isSuccess){
                        //                                 locationProvider.getAreasList(context);
                        //                                 showCustomSnackBar('Area removed successfully', scaffoldKey!.currentContext!, isError:false);
                        //                                 Navigator.pop(context);
                        //                               }else{
                        //                                 showCustomSnackBar('Something went wrong', scaffoldKey!.currentContext!);
                        //                               }
                        //                             });
                        //                             Navigator.pop(context);
                        //                           },
                        //                           btnTxt: 'Yes',
                        //                           borderColor: Colors.black26,
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   )
                        //                 ],
                        //               );
                        //             },
                        //           );
                        //         },
                        //         child: const Icon(Icons.delete, color: Colors.black54)),
                        //
                        //     const SizedBox(width: 15)
                        //   ],
                        // ),

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
