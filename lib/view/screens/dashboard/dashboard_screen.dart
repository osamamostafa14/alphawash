import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/view/screens/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/view/screens/menu/menu_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int? pageIndex;
  DashboardScreen({@required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  List<Widget>? _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex!;

    _pageController = PageController(initialPage: widget.pageIndex!);

    _screens = [HomeScreen(), MenuScreen()];
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 30,
                  offset: const Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BottomNavigationBar(
                elevation: 20,
                backgroundColor: Colors.white,
                selectedItemColor: Theme.of(context!).primaryColor,
                unselectedItemColor: Colors.black54,
                showUnselectedLabels: true,
                currentIndex: _pageIndex,
                selectedFontSize:
                    Theme.of(context!).textTheme.bodyText1!.fontSize!,
                unselectedFontSize:
                    Theme.of(context).textTheme.bodyText1!.fontSize!,
                type: BottomNavigationBarType.fixed,
                items: [
                  _barItem(Icons.home, 'Home', 0),
                  _barItem(Icons.menu, 'Menu', 1),
                ],
                onTap: (int index) {
                  _setPage(index);
                },
              ),
            ),
          ),
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
        clipBehavior: Clip.none,
        children: [
          Icon(icon,
              color: index == _pageIndex
                  ? Theme.of(context!).primaryColor
                  : Colors.black54,
              size: 25),
        ],
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
      final bool _isLoggedIn =
          Provider.of<CustomerAuthProvider>(context, listen: false).isLoggedIn;
      if (_pageIndex == 1) {
        if (_isLoggedIn) {}
      }
    });
  }
}
