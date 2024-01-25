import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/styles.dart';
import 'package:alphawash/view/screens/splash_screen.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext? context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 300,
        color: Theme.of(context!).scaffoldBackgroundColor,
        child: Consumer<CustomerAuthProvider>(builder: (context, auth, child) {
          return Column(mainAxisSize: MainAxisSize.min, children: [

            SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.contact_support, color:Colors.white,size: 50),
            ),

            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Text('Do you want to sign out?',
                  style: TextStyle(color: Theme.of(context).textTheme.headline2!.color, fontWeight: FontWeight.w500, fontSize: 15),
                  textAlign: TextAlign.center),
            ),

            Divider(height: 0, color: ColorResources.getHintColor(context)),

            !auth.isLoading ? Row(children: [

              Expanded(child: InkWell(
                onTap: () {
                  Provider.of<CustomerAuthProvider>(context, listen: false).clearSharedData().then((condition) async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> SplashScreen()));
                    });
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                  child: Text('Yes', style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
                ),
              )),

              Expanded(child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                  ),
                  child: Text('No', style: rubikBold.copyWith(color: Colors.white)),
                ),
              )),

            ]) : Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            ),
          ]);
        }),
      ),
    );
  }
}
