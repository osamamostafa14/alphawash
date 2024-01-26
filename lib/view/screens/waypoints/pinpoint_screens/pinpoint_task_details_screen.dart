import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PinPointTasksDetailsScreen extends StatelessWidget {
  final String imageUrl;
  final String details;

  PinPointTasksDetailsScreen({required this.imageUrl, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          centerTitle: true,
          title: Text('Task Details', style: TextStyle(color: Colors.white)),
        ),
        body: Center(
            child: Scrollbar(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: const BouncingScrollPhysics(),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                      'Your Image Task : ',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color,
                          fontSize: 15),
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          '${Provider.of<SplashProvider>(
                            context,
                          ).baseUrls!.taskImageUrl}/${imageUrl}',
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Text(
                      'Details of task : ',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color,
                          fontSize: 15),
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(10),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            )),
                        width: double.infinity,
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(details,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                )))),

                  ]))),
        )));
  }
}
