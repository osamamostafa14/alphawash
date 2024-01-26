import 'package:flutter/material.dart';

class MarkerWidget extends StatelessWidget {
  const MarkerWidget({
    super.key,
    required this.image,
  });
  final String image;
  @override
  Widget build(BuildContext context) {
    return
      Image(
        image: AssetImage(
          image,
        ),
        height: 150,
        width: 150,
        color: Theme.of(context).primaryColor,
      );
  }
}
