import 'package:flutter/material.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/utill/styles.dart';
import 'package:alphawash/view/screens/menu/widget/options_view.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  final Function? onTap;
  MenuScreen({ this.onTap});

  @override
  Widget build(BuildContext? context) {
    final bool _isLoggedIn = Provider.of<CustomerAuthProvider>(context!, listen: false).isLoggedIn;
    if(_isLoggedIn) {
      Provider.of<ProfileProvider>(context,listen: false).getUserInfo(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios),
        //   color: Colors.black54,
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body:
      Column(children: [
        Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) =>
          profileProvider.userInfoModel==null?
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
          ):
              Center(
            child: Container(
              width: 1170,
              decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, children: [

               // const SizedBox(height: 100),
              Container(
                  height: 80, width: 80,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorResources.COLOR_WHITE, width: 2)),
                  child: ClipOval(
                    child: _isLoggedIn ?
                    profileProvider.userInfoModel!.image!= null ?
                    FadeInImage.assetNetwork(
                      placeholder: Images.profile_icon,
                      image: '${Provider.of<SplashProvider>(context,).baseUrls!.userImageUrl}/${profileProvider.userInfoModel!.image}',
                      height: 80, width: 80, fit: BoxFit.cover,
                    ) : Image.asset(Images.profile_icon, height: 80, width: 80, fit: BoxFit.cover, color: Colors.black54)
                        :
                    Image.asset(Images.profile_icon, height: 80, width: 80, fit: BoxFit.cover, color: Colors.black54),
                  ),
                ),

                Column(children: [
                  SizedBox(height: 20),
                  _isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                    '${profileProvider.userInfoModel!.fullName ?? ''}',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).primaryColor),
                  ) : Container(height: 15, width: 150, color: Colors.white) : Text(
                    'Guest',
                    style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.COLOR_WHITE),
                  ),
                  const SizedBox(height: 10),
                  _isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                    '${profileProvider.userInfoModel!.email ?? ''}',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).textTheme.headline2!.color,
                      fontWeight: FontWeight.normal
                    ),
                  ) : Container(height: 15, width: 100, color: Colors.white) : Text(
                    '',
                    style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.COLOR_WHITE),
                  ),
                ]),

                const SizedBox(height: 10),

             //   Divider(color: ColorResources.OFF_WHITE),
              ]),
            ),
          ),
        ),


        Expanded(child: OptionsView(onTap: onTap)),
      ]),
    );
  }
}
