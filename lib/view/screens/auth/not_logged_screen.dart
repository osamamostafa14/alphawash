// import 'package:flutter/material.dart';
// import 'package:alphawash/utill/dimensions.dart';
//
// class NotLoggedInScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext? context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//         child: Container(
//           //  color: Colors.white,
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//
//             /*  Image.asset(
//             Images.guest_login,
//             width: MediaQuery.of(context).size.height*0.25,
//             height: MediaQuery.of(context).size.height*0.25,
//           ),
//
//          */
//             SizedBox(height: MediaQuery.of(context!).size.height*0.03),
//
//             Text(
//               'Guest Mode',
//               style: TextStyle(
//                   color: Colors.black87,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: MediaQuery.of(context!).size.height*0.02),
//
//             Text(
//               ,
//               style: rubikRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height*0.03),
//
//             SizedBox(
//               width: 100,
//               height: 40,
//               child: CustomButton(btnTxt: getTranslated('login', context), onTap: () {
//                 Navigator.pushNamed(context, Routes.getLoginRoute());
//               }),
//             ),
//
//           ]),
//         ),
//
//       ),
//     );
//   }
// }
