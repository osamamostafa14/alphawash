import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/styles.dart';
import 'package:alphawash/view/base/custom_button.dart';

class PermissionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext? context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 300,
        child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Icon(Icons.add_location_alt_rounded, color: Theme.of(context!).primaryColor, size: 100),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            Text(
              'You denied location permissions', textAlign: TextAlign.justify,
              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            Row(children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                    minimumSize: Size(1, 50),
                  ),
                  child: Text('No'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(child:CustomButton(
                  btnTxt: 'Yes',
                  onTap: () async {
                    await Geolocator.openAppSettings();
                    Navigator.pop(context);
                  })),
            ]),

          ]),
        ),
      ),
    );
  }
}
