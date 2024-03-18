import 'package:alphawash/utill/images.dart';
import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  const CustomMarker({Key? key, @required this.image}) : super(key: key);
  final String? image;

  @override
  Widget build(BuildContext context) {
    return image != 'no_image'
        ? Column(children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: FadeInImage.assetNetwork(
                            height: 110,
                            width: 110,
                            placeholder: Images.placeholder,
                            image: image!,
                            fit: BoxFit.cover)))),
            Icon(Icons.location_on, color: Colors.white, size: 50)
          ])
        : Icon(Icons.location_on, color: Colors.red, size: 130);
  }
}
