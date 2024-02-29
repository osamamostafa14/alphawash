import 'package:flutter/material.dart';
import 'package:alphawash/provider/location_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class LocationLoadingScreen extends StatefulWidget {
  @override
  State<LocationLoadingScreen> createState() => _LocationLoadingScreenState();
}


class _LocationLoadingScreenState extends State<LocationLoadingScreen> {

  @override
  void initState() {
    super.initState();
    _route();

  }
  void _route() {

  }

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          // if(locationProvider.info != null){
          //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext? context)=>
          //       RouteDirectionScreen()));
          // }
          return SafeArea(
              child: Center(child: Padding(
                padding: const EdgeInsets.only(top: 200),
                child: LoadingAnimationWidget.inkDrop(
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ),
              ))
          );
        }
      ),
    );
  }
}

