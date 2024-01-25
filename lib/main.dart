import 'dart:async';
import 'package:alphawash/localization/app_localization.dart';
import 'package:alphawash/provider/ReportProvider.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/provider/localization_provider.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/onboarding_provider.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/provider/theme_provider.dart';
import 'package:alphawash/provider/worker/worker_area_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/theme/light_theme.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:alphawash/view/screens/notification/my_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'di_container.dart' as di;
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:alphawash/route/route.dart' as route;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  final applicationDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(applicationDocumentDir.path);
  await Hive.openBox('myBox');

  try {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails!.didNotificationLaunchApp ?? false) {

    }

    await MyNotification.initialize(flutterLocalNotificationsPlugin);
    // await MyNotification.showData(message);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    // MyNotification.
    print('initialize notify');
  }catch(e) {
    print('error notify');
    print('error notify: $e');
  }
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   // Handle foreground notification
  //   // You can choose to show the notification or handle it differently
  //   showCustomNotification(message);
  // });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CustomerAuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WorkerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ReportProvider>()),

      /// Worker
      ChangeNotifierProvider(create: (context) => di.sl<WorkerAreaProvider>()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {});
    // if(Provider.of<DriverAuthProvider>(context, listen: false).isLoggedIn){
    //   print('Main driver logged iIn');
    //   _timer = Timer.periodic(Duration(seconds: 30), (timer) {
    //     Provider.of<DriverOrdersProvider>(context, listen: false).updateDriverLocation(
    //         Provider.of<LocationProvider>(context, listen: false).currentLatitude.toString(),
    //         Provider.of<LocationProvider>(context, listen: false).currentLongitude.toString());
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child){
        List<Locale> _locals = [];
        AppConstants.languages.forEach((language) {
          _locals.add(Locale(language.languageCode!, language.countryCode));
        });
        return  MaterialApp(
          onGenerateRoute: route.controller,
          initialRoute: route.splashScreen,
          theme: light,
          title: 'Alphawash',
          debugShowCheckedModeBanner: false,
          navigatorKey: MyApp.navigatorKey,
          locale: Provider.of<LocalizationProvider>(context).locale,
          localizationsDelegates: [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: _locals,
        );
      },
    );
  }
}
