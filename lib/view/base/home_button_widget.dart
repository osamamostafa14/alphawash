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
        height: 75,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).primaryColor.withOpacity(0.4)),
                child: Icon(
                  icon,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Text(text!, style: TextStyle(color: Colors.black87, fontSize: 16))
            ],
          ),
        ),
      ),

      // Container(
      //   height: 110,
      //   width: 200,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(10),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.withOpacity(0.2),
      //         spreadRadius: 1,
      //         blurRadius: 2,
      //         offset:const Offset(0, 1), // changes position of shadow
      //       ),
      //     ],
      //     // border: Border.all(width: 1, color: borderColor!),
      //   ),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Icon(icon, size: 40, color: Colors.black54),
      //       const SizedBox(height: 20),
      //       Text(text!, style: TextStyle(color: Colors.black87, fontSize: 16)),
      //     ],
      //   ),
      // ),
    );
  }
}
