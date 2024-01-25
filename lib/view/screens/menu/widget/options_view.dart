import 'package:flutter/material.dart';
import 'package:alphawash/view/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/view/screens/auth/login_screen.dart';
import 'package:alphawash/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:alphawash/view/screens/terms/terms_screen.dart';

class OptionsView extends StatelessWidget {
  final Function? onTap;
  OptionsView({@required this.onTap});

  @override
  Widget build(BuildContext? context) {
    final bool _isLoggedIn =
        Provider.of<CustomerAuthProvider>(context!, listen: false).isLoggedIn;

    //Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
     UserInfoModel? _userInfo;
    if(_isLoggedIn){
       _userInfo =
          Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
    }

    return
      Consumer<ProfileProvider>(
        builder: (context, profileProvider, child){

          return Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: 1170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      const SizedBox(height: 15),

                      ListTile(
                        onTap: () {
                          Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext? context)=>
                              ProfileScreen()));
                        },
                        leading: Icon(Icons.person, color: Theme.of(context).textTheme.headline2!.color!.withOpacity(0.8)),
                        title: Text(
                            'Profile',
                            style:  Theme.of(context).textTheme.bodyText1!.copyWith(color:
                            Theme.of(context).textTheme.headline2!.color!.withOpacity(0.8)
                            )),
                      ),


                      ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext? context)=>
                              TermsScreen()));
                        },
                        leading: Icon(Icons.local_police_rounded, color: Theme.of(context).textTheme.headline2!.color!.withOpacity(0.8)),
                        title: Text(
                            'Terms & conditions',
                            style:  Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).textTheme.headline2!.color!.withOpacity(0.8)
                            )),
                      ),

                      ListTile(
                        onTap: () {
                          if (_isLoggedIn) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => SignOutConfirmationDialog());
                          } else {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext? context)=> LoginScreen()));
                          }
                        },
                        leading: Icon(Icons.logout, color: Theme.of(context).textTheme.headline2!.color!.withOpacity(0.8)),
                        title: Text(
                            _isLoggedIn? 'Logout' : 'Login',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).textTheme.headline2!.color!.withOpacity(0.8)
                            )),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
