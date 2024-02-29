import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:alphawash/data/model/response/response_model.dart';
import 'package:alphawash/provider/localization_provider.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:alphawash/view/screens/dashboard/dashboard_screen.dart';
import 'package:alphawash/view/screens/onboarding/onboarding_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:alphawash/view/screens/location/permission_dialog.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:alphawash/view/screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult>? _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    // _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   if(!_firstTime) {
    //     bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
    //     isNotConnected ? SizedBox() : _globalKey.currentState!.hideCurrentSnackBar();
    //     _globalKey.currentState!.showSnackBar(SnackBar(
    //       backgroundColor: isNotConnected ? Colors.red : Colors.green,
    //       duration: Duration(seconds: isNotConnected ? 6000 : 3),
    //       content: Text(
    //         isNotConnected ? 'No connection' : 'Connected',
    //         textAlign: TextAlign.center,
    //       ),
    //     ));
    //     if(!isNotConnected) {
    //       _route();
    //     }
    //   }
    //
    //
    //   _firstTime = false;
    // });

     _route();

  }


  @override
  void dispose() {
    super.dispose();

  //  _onConnectivityChanged!.cancel();
  }

  void _route() {
    var box = Hive.box('myBox');
    var _firstOpen = box.get('first_open');
    final String defaultLocale = Platform.localeName;
    List<String> parts = defaultLocale.split('_');
    String userLanguageCode = parts[0];


    try {

      Provider.of<SplashProvider>(context, listen: false).initConfig(_globalKey, context).then((bool isSuccess) async {
        if (isSuccess) {

            Provider.of<CustomerAuthProvider>(context, listen: false).checkLoggedIn();
            var box = Hive.box('myBox');
            String userType = box.get(AppConstants.USER_TYPE) ?? '';
            LocationPermission permission = await Geolocator.checkPermission();
            if(permission == LocationPermission.denied) {
              permission = await Geolocator.requestPermission();
            }
            if(permission == LocationPermission.denied) {
              showCustomSnackBar('You have to allow location permission to get our services', context);
            }else if(permission == LocationPermission.deniedForever) {
              showDialog(context: context, barrierDismissible: false, builder: (context) => PermissionDialog());
            }else {
              Provider.of<LocationProvider>(context, listen: false).getCurrentLocation2().then((value) {

                  box.put('first_open', false);

                  Provider.of<SplashProvider>(context, listen: false).saveLanguage(userLanguageCode).then((value) {
                    Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                      userLanguageCode,
                      'US',
                    ));
                    Provider.of<CustomerAuthProvider>(context, listen: false).checkLoggedIn().then((value) async {
                      if(Provider.of<CustomerAuthProvider>(context, listen: false).isLoggedIn){

                        ResponseModel _response = await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
                        if(_response.isSuccess){

                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
                          //     DashboardScreen(pageIndex: 0)));

                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
                              OnBoardingScreen()));

                        }else{
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
                        }

                      }else {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
                      }
                    });
                  });

              });
            }
        }
      });
    } catch(e) {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(Images.blue_logo, height: 150),
            ),
          ],
        ),
      ),
    );
  }
}
