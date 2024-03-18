import 'package:alphawash/provider/location_provider.dart';
import 'package:alphawash/view/screens/home/home_screen.dart';
import 'package:alphawash/view/screens/profile/profile_screen.dart';
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
  List<IconData> navIcons = [Icons.home, Icons.person, Icons.menu];
  List<String> navTitle = ['Home', 'Profile', 'Menu'];
  int selectedIndex = 0;

  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex!;

    _pageController = PageController(initialPage: widget.pageIndex!);

    _screens = [HomeScreen(), ProfileScreen(), MenuScreen()];
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
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _screens!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _screens![index];
              },
            ),
            Align(alignment: Alignment.bottomCenter, child: NavBar()),
          ],
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
      final bool _isLoggedIn =
          Provider.of<CustomerAuthProvider>(context, listen: false).isLoggedIn;
      if (_pageIndex == 2) {
        if (_isLoggedIn) {}
      }
    });
  }

  Widget NavBar() {
    return Container(
      height: 65,
      margin: EdgeInsets.only(right: 24, left: 24, bottom: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 20,
                spreadRadius: 10)
          ]),
      child: Row(
        children: navIcons.map((icon) {
          int index = navIcons.indexOf(icon);
          bool isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    _setPage(index);
                    selectedIndex = index;
                  },
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: 15, bottom: 0, left: 25, right: 25),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                      ),
                      Text(
                        navTitle[index],
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                      )
                    ],
                  ),
                )),
          );
        }).toList(),
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
