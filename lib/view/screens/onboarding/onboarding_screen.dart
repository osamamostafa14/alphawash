import 'dart:async';

import 'package:alphawash/data/model/response/worker_task_model.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/provider/onboarding_provider.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/worker_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/base/border_button.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/screens/dashboard/dashboard_screen.dart';
import 'package:alphawash/view/worker-screens/bio/bio_screen.dart';
import 'package:alphawash/view/worker-screens/dashboard/worker_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      Provider.of<WorkerProvider>(context, listen: false).getReminder(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext? context) {
    List tips = [
      {
        'index': 0,
        'title_1': 'Welcome to AlphaWash Yard Sign Tracker!',
        'title_2':
            'Welcome to the AlphaWash community, where your efforts make a real difference. This app is designed to be your trusted partner in the field, ensuring every yard sign placed helps us grow together. Remember, this tool reflects your hard work and dedication—accuracy and honesty are key. Your accountability drives our success. Feel free to customize your profile now or later in the settings—make this journey your own.',
        'title_3': 'This app never lies',
        'title_4': '',
        'title_5': '',
        'title_6': '',
        'image': Images.logo_2,
      },
      {
        'index': 1,
        'title_1': 'Prioritizing Your Safety.',
        'title_2':
            'Your safety is our utmost concern. Please adhere to the following when placing yard signs:',
        'title_3':
            'Always park your vehicle in a safe location, away from traffic. Use flashers if parked on the road.',
        'title_4':
            'Be vigilant when walking near or across roads—your well-being is paramount.',
        'title_5':
            'Keep these precautions in mind to ensure not just your safety but also that of those around you. Together, we can create a safe working environment for everyone.',
        'title_6': '',
        'image': Images.logo_3,
      },
      {
        'index': 2,
        'title_1': 'Effective Sign Placement Strategies',
        'title_2':
            'Placing signs effectively is crucial for maximizing our visibility and impact. Here are some strategies:',
        'title_3':
            'Choose strategic locations like high grass areas or spots with pine straw or dirt, which are less likely to be disturbed',
        'title_4':
            'Strategic placement includes putting them in a taller grass area that doesnt get cut as often, or in pine straw or dirt. Be creative and strategic, make sure its very visible where cars will be stopped',
        'title_5':
            'Always respect private property and community standards. Avoid placing signs in unauthorized areas, including private yards without permission',
        'title_6':
            'This app is a reflection of your contributions and accountability. Let\'s use it to make every placement count.',
        'image': Images.logo_4,
      },
    ];
    return Scaffold(
      backgroundColor: ColorResources.BG_PRIMARY,
      body: Consumer2<OnBoardingProvider, WorkerProvider>(
          builder: (context, onBoardingList, workerProvider, child) {
        return SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: 1170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      onBoardingList.selectedIndex != tips.length - 1
                          ? Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                  onPressed: () {
                                    print('test 1');
                                    onBoardingList.changeSelectIndex(0);
                                    if (Provider.of<ProfileProvider>(context,
                                                listen: false)
                                            .userInfoModel!
                                            .userType ==
                                        'admin') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  DashboardScreen(
                                                      pageIndex: 0)));
                                    } else {
                                      workerProvider.reminder.isNotEmpty
                                          ? showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  insetPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                  child: SingleChildScrollView(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: Text(
                                                                  'You have ${workerProvider.reminder.length} pinpointed areas where you haven\'t taken any action.',
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      fontSize:
                                                                          15)),
                                                            ),
                                                            Divider(),
                                                            ListView.builder(
                                                              itemCount:
                                                                  workerProvider
                                                                      .reminder!
                                                                      .length,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                ReminderModel
                                                                    _reminder =
                                                                    workerProvider
                                                                            .reminder![
                                                                        index];
                                                                return Column(
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                          color: Colors.white),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(children: [
                                                                              Text("Pinpoint ID :", style: TextStyle(fontSize: 16)),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Text(_reminder.pinpointId.toString(), style: TextStyle(fontSize: 14)),
                                                                            ]),
                                                                            Row(children: [
                                                                              Text("Pinpoint Task Day :", style: TextStyle(fontSize: 16)),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Text(_reminder.dayOfTask.toString(), style: TextStyle(fontSize: 14)),
                                                                            ]),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  BorderButton(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (BuildContext context) => WorkerDashboardScreen(pageIndex: 0))).then(
                                                                          (value) =>
                                                                              Navigator.pop(context));
                                                                    },
                                                                    btnTxt:
                                                                        'Ok',
                                                                    borderColor:
                                                                        Colors
                                                                            .black26,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          WorkerDashboardScreen(
                                                              pageIndex: 0)));
                                      final provider =
                                          Provider.of<LocationProvider>(
                                        context,
                                        listen: false,
                                      );
                                      final profileProvider =
                                          Provider.of<ProfileProvider>(context,
                                              listen: false);
                                      provider.startLocationUpdate(
                                        profileProvider.userInfoModel!.id!
                                            .toString(),
                                        profileProvider
                                            .userInfoModel!.fullName!,
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Skip',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(color: Colors.white70),
                                  )),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 300,
                        child: PageView.builder(
                          itemCount: tips.length,
                          controller: _pageController,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(30),
                              child: Container(
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Image.asset(tips[index]['image']),
                                  )),
                            );
                          },
                          onPageChanged: (index) {
                            onBoardingList.changeSelectIndex(index);
                          },
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _pageIndicators(tips, context),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 50, bottom: 22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  onBoardingList.selectedIndex == 0
                                      ? tips[0]['title_1']
                                      : onBoardingList.selectedIndex == 1
                                          ? tips[1]['title_1']
                                          : tips[2]['title_1'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                          fontSize: 20.0, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                onBoardingList.selectedIndex == 0
                                    ? Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          tips[0]['title_2'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white70),
                                          textAlign: TextAlign.justify,
                                        ),
                                      )
                                    : const SizedBox(),
                                onBoardingList.selectedIndex == 0
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Text(
                                          tips[0]['title_3'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : const SizedBox(),
                                onBoardingList.selectedIndex == 0
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        BioScreen()));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Update Bio',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3!
                                                    .copyWith(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(width: 10),
                                              Icon(Icons.edit,
                                                  color: Colors.white70)
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                onBoardingList.selectedIndex == 1
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Text(
                                                    tips[1]['title_2'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3!
                                                        .copyWith(
                                                            fontSize:
                                                                15.0, // how to make text alignment right
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.white),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.circle,
                                                    color: Colors.white70,
                                                    size: 10),
                                                const SizedBox(width: 8),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Text(
                                                    tips[1]['title_3'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3!
                                                        .copyWith(
                                                            fontSize:
                                                                14.5, // how to make text alignment right
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.white70),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.circle,
                                                    color: Colors.white70,
                                                    size: 10),
                                                const SizedBox(width: 8),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Text(
                                                    tips[1]['title_4'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3!
                                                        .copyWith(
                                                            fontSize:
                                                                14.5, // how to make text alignment right
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.white70),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.circle,
                                                    color: Colors.white70,
                                                    size: 10),
                                                const SizedBox(width: 8),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Text(
                                                    tips[1]['title_5'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3!
                                                        .copyWith(
                                                            fontSize:
                                                                14.5, // how to make text alignment right
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.white70),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                onBoardingList.selectedIndex == 2
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Icon(Icons.circle,
                                                //     color: Colors.white70,
                                                //     size: 10),
                                                // const SizedBox(width: 8),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Text(
                                                    tips[2]['title_2'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3!
                                                        .copyWith(
                                                            fontSize:
                                                                16.0, // how to make text alignment right
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.white),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.circle,
                                                    color: Colors.white70,
                                                    size: 10),
                                                const SizedBox(width: 8),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Text(
                                                    tips[2]['title_3'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3!
                                                        .copyWith(
                                                            fontSize:
                                                                14.5, // how to make text alignment right
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.white70),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.circle,
                                                    color: Colors.white70,
                                                    size: 10),
                                                const SizedBox(width: 8),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Text(
                                                    tips[2]['title_4'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3!
                                                        .copyWith(
                                                            fontSize:
                                                                14.5, // how to make text alignment right
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.white70),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,

                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.circle,
                                                    color: Colors.white70,
                                                    size: 10),
                                                const SizedBox(width: 8),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Text(
                                                    tips[2]['title_5'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3!
                                                        .copyWith(
                                                            fontSize:
                                                                14.5, // how to make text alignment right
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.white70),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,

                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.circle,
                                                    color: Colors.white70,
                                                    size: 10),
                                                const SizedBox(width: 8),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Text(
                                                    tips[2]['title_6'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3!
                                                        .copyWith(
                                                            fontSize:
                                                                14.5, // how to make text alignment right
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.white70),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(
                                onBoardingList.selectedIndex == 2 ? 0 : 22),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                onBoardingList.selectedIndex == 0 ||
                                        onBoardingList.selectedIndex == 2
                                    ? SizedBox.shrink()
                                    : TextButton(
                                        onPressed: () {
                                          _pageController.previousPage(
                                              duration: Duration(seconds: 1),
                                              curve: Curves.ease);
                                        },
                                        child: Text(
                                          'Previous',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  color: ColorResources
                                                      .getGrayColor(context)),
                                        )),
                                onBoardingList.selectedIndex == 2
                                    ? SizedBox.shrink()
                                    : TextButton(
                                        onPressed: () {
                                          _pageController.nextPage(
                                              duration: Duration(seconds: 1),
                                              curve: Curves.ease);
                                        },
                                        child: Text(
                                          'Next',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(
                                                  color: ColorResources
                                                      .getGrayColor(context)),
                                        )),
                              ],
                            ),
                          ),
                          onBoardingList.selectedIndex == 2
                              ? Padding(
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_LARGE),
                                  child: CustomButton(
                                    backgroundColor: ColorResources.BG_SECONDRY,
                                    btnTxt: 'Let\'s start',
                                    onTap: () async {
                                      onBoardingList.changeSelectIndex(0);
                                      if (Provider.of<ProfileProvider>(context,
                                                  listen: false)
                                              .userInfoModel!
                                              .userType ==
                                          'admin') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        DashboardScreen(
                                                            pageIndex: 0)));
                                      } else {
                                        workerProvider.reminder.isNotEmpty
                                            ? showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    insetPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10.0),
                                                                child: Text(
                                                                    'You have ${workerProvider.reminder.length} pinpointed areas where you haven\'t taken any action.',
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        fontSize:
                                                                            15)),
                                                              ),
                                                              Divider(),
                                                              ListView.builder(
                                                                itemCount:
                                                                    workerProvider
                                                                        .reminder
                                                                        .length,
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  ReminderModel
                                                                      _reminder =
                                                                      workerProvider
                                                                              .reminder[
                                                                          index];
                                                                  return Column(
                                                                    children: [
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(
                                                                              10,
                                                                            ),
                                                                            color: Colors.white),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              10.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(children: [
                                                                                Text("Pinpoint ID:", style: TextStyle(fontSize: 16)),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Text(_reminder.pinpointId.toString(), style: TextStyle(fontSize: 14)),
                                                                              ]),
                                                                              Row(children: [
                                                                                Text("Pinpoint Task Day:", style: TextStyle(fontSize: 16)),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Text(_reminder.dayOfTask.toString(), style: TextStyle(fontSize: 14)),
                                                                              ]),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    BorderButton(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (BuildContext context) => WorkerDashboardScreen(pageIndex: 0))).then((value) =>
                                                                            Navigator.pop(context));
                                                                      },
                                                                      btnTxt:
                                                                          'Ok',
                                                                      borderColor:
                                                                          Colors
                                                                              .black26,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ]),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        WorkerDashboardScreen(
                                                            pageIndex: 0)));

                                        final provider =
                                            Provider.of<LocationProvider>(
                                          context,
                                          listen: false,
                                        );
                                        final profileProvider =
                                            Provider.of<ProfileProvider>(
                                                context,
                                                listen: false);
                                        provider.startLocationUpdate(
                                          profileProvider.userInfoModel!.id!
                                              .toString(),
                                          profileProvider
                                              .userInfoModel!.fullName!,
                                        );
                                      }
                                    },
                                  ))
                              : SizedBox.shrink()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  List<Widget> _pageIndicators(var onBoardingList, BuildContext? context) {
    List<Container> _indicators = [];

    for (int i = 0; i < onBoardingList.length; i++) {
      _indicators.add(
        Container(
          width: i == Provider.of<OnBoardingProvider>(context!).selectedIndex
              ? 16
              : 7,
          height: 7,
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: i == Provider.of<OnBoardingProvider>(context).selectedIndex
                ? ColorResources.BG_SECONDRY
                : Colors.white70,
            borderRadius:
                i == Provider.of<OnBoardingProvider>(context).selectedIndex
                    ? BorderRadius.circular(50)
                    : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return _indicators;
  }
}
