import 'package:flutter/material.dart';

class MarkerImage extends StatelessWidget {
  const MarkerImage({
    super.key,
    required this.image,
  });
  final String image;
  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(
        image,
      ),
      height: 150,
      width: 150,
      color: Theme.of(context).primaryColor,
    );
  }
}

class MarkerText extends StatelessWidget {
  const MarkerText({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal:2,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
