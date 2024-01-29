import 'package:alphawash/utill/images.dart';
import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  const CustomMarker({Key? key, @required this.image}) : super(key: key);
  final String? image;

  @override
  Widget build(BuildContext context) {
    return
      image!= 'no_image'?
      Column(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage.assetNetwork(
                height: 120,
                width: 110,
                placeholder: Images.placeholder,
                image: image!,
                fit: BoxFit.cover)),
        Icon(Icons.location_on, color: Colors.red, size:  80)
      ]): Icon(Icons.location_on, color: Colors.red, size:  130);
  }
}
