// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:alphawash/provider/auth_provider.dart';
// import 'package:alphawash/provider/messages_provider.dart';
// import 'package:alphawash/utill/dimensions.dart';
// import 'package:alphawash/utill/images.dart';
// import 'package:alphawash/view/screens/messages/messages_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//   @override
//   Widget build(BuildContext? context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
//       appBar: AppBar(
//         title: Text('Catchy', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.normal)),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         elevation: 0.5,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 15),
//             child: GestureDetector(
//                 onTap: () async {
//
//                   Provider.of<MessagesProvider>(context, listen: false).clearOffset();
//                   Provider.of<MessagesProvider>(context, listen: false).getMessageList(
//                       context,
//                       '1',
//                           (
//                           bool isSuccess) async {
//                         if(isSuccess){
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (BuildContext? context) =>
//                                   MessagesScreen()));
//                         } else {
//                           showDialog(
//                               context: context,
//                               builder: (_) => AlertDialog(
//                                 title: Text('Error occured, try again later'),
//                               )
//                           );
//                         }
//                       });
//
//                 },
//                 child: Icon(Icons.message, color: Theme.of(context).primaryColor)),
//           )
//         ],
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Image.asset(Images.main_logo, color: Theme.of(context).primaryColor),
//         ),
//       ),
//       body: Consumer<CustomerAuthProvider>(
//         builder: (context, authProvider, child) => SafeArea(
//           child: Scrollbar(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//               physics: BouncingScrollPhysics(),
//               child: Center(
//                 child: SizedBox(
//                   width: 1170,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 100),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.rate_review_rounded, color: Theme.of(context).textTheme.headlineMedium!.color!),
//                           const SizedBox(width: 15),
//                           Text('Your account still under review', style: TextStyle(
//                               fontSize: 15,
//                               color: Theme.of(context).textTheme.headlineMedium!.color!, fontWeight: FontWeight.w500)),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
