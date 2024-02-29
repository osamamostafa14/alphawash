import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/view/screens/home/home_screen.dart';
import 'package:alphawash/view/worker-screens/home/worker_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/view/screens/menu/menu_screen.dart';

class WorkerDashboardScreen extends StatefulWidget {
  final int? pageIndex;
  WorkerDashboardScreen({@required this.pageIndex});

  @override
  _WorkerDashboardScreenState createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  List<Widget>? _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex!;

    _pageController = PageController(initialPage: widget.pageIndex!);

    _screens = [
      WorkerHomeScreen(),
      MenuScreen()
    ];
  }


  @override
  Widget build(BuildContext? context) {

    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context!).primaryColor,
          selectedItemColor: ColorResources.BG_SECONDRY,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          selectedFontSize: Theme.of(context).textTheme.bodyText1!.fontSize!,
          unselectedFontSize: Theme.of(context).textTheme.bodyText1!.fontSize!,
          type: BottomNavigationBarType.fixed,

          items: [
            _barItem(Icons.home, 'Home', 0),
            _barItem(Icons.menu, 'Menu', 1),
          ],
          onTap: (int index) {
            _setPage(index);
          },
        ),

        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens!.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens![index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none, children: [
        Icon(icon, color: index == _pageIndex ? ColorResources.BG_SECONDRY : Colors.white, size: 25),
      ],
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
      final bool _isLoggedIn = Provider.of<CustomerAuthProvider>(context, listen: false).isLoggedIn;
      if (_pageIndex == 1) {
        if(_isLoggedIn){

        }
      }
    });
  }
}


