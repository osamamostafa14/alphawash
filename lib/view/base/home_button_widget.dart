import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? icon;
  final String? text;
  HomeButton({this.onTap, this.icon, this.text});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 110,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset:const Offset(0, 1), // changes position of shadow
            ),
          ],
          // border: Border.all(width: 1, color: borderColor!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black54),
            const SizedBox(height: 20),
            Text(text!, style: TextStyle(color: Colors.black87, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
