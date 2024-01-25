import 'package:alphawash/data/model/response/response_model.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/view/screens/auth/signup_check_email.dart';
import 'package:alphawash/view/screens/dashboard/dashboard_screen.dart';
import 'package:alphawash/view/screens/onboarding/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alphawash/data/helper/email_checker.dart';
import 'package:alphawash/provider/auth_provider.dart';

import 'package:provider/provider.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:alphawash/view/base/custom_text_field.dart';
import 'package:alphawash/view/screens/auth/check_email_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController!.text = Provider.of<CustomerAuthProvider>(context, listen: false).getUserNumber() ?? '';
    _passwordController!.text = Provider.of<CustomerAuthProvider>(context, listen: false).getUserPassword() ?? '';
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child:
        Consumer<CustomerAuthProvider>(
          builder: (context, authProvider, child){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(Images.blue_logo, height: 200),
                const SizedBox(height: 10),
                Text('Login', style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                )),

                Center(
                  child:Scrollbar(
                    child: SingleChildScrollView(
                      // padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                      physics: const BouncingScrollPhysics(),
                      child: Center(
                        child: SizedBox(
                            width: 1170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text('Enter Username',
                                          style: TextStyle(color: Colors.white, fontSize: 16)),
                                    )),
                                const SizedBox(height: 10),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20),
                                      child:  CustomTextField(
                                        hintText: 'example@gmail.com',
                                        isShowBorder: true,
                                        inputType: TextInputType.emailAddress,
                                        inputAction: TextInputAction.next,
                                        focusNode: _emailFocus,
                                        controller: _emailController,
                                        isIcon: true,
                                        isShowPrefixIcon: true,
                                        prefixIconUrl: Images.message_icon,
                                      ),
                                    )),
                                const SizedBox(height: 25),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text('Password', style: TextStyle(color: Colors.white, fontSize: 16)),
                                    )),
                                const SizedBox(height: 10),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20),
                                      child:  CustomTextField(
                                        hintText: '***********',
                                        isShowBorder: true,
                                        isPassword: true,
                                        inputAction: TextInputAction.done,
                                        focusNode: _passwordFocus,
                                        controller: _passwordController,
                                        isIcon: true,
                                        isShowPrefixIcon: true,
                                        isShowSuffixIcon: true,
                                        prefixIconUrl: Images.lock_icon,

                                      ),
                                    )),

                                // const SizedBox(height: 8),
                                //
                                // InkWell(
                                //   onTap: () {
                                //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> CheckEmailScreen()));
                                //   },
                                //   child: Align(
                                //     alignment: Alignment.topRight,
                                //     child: Padding(
                                //       padding: const EdgeInsets.only(right: 20),
                                //       child: Text('Forgot Password',
                                //           style: TextStyle(color: Colors.white,
                                //               fontSize: 14, fontWeight: FontWeight.normal)),
                                //     ),
                                //   ),
                                // ),

                                const SizedBox(height: 10),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 20),
                                    authProvider.loginErrorMessage.length > 0
                                        ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                        : SizedBox.shrink(),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        authProvider.loginErrorMessage ?? "",
                                        style: Theme.of(context).textTheme.headline2!.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                SizedBox(height: authProvider.loginErrorMessage.length > 0? 10 : 0),

                                authProvider.isLoading?
                                Center(
                                    child: CircularProgressIndicator(
                                      valueColor: new AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )):
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: CustomButton(btnTxt: 'Sign In',
                                      backgroundColor: ColorResources.BG_SECONDRY,
                                      onTap: () async {
                                        String _email = _emailController!.text.trim();
                                        String _password = _passwordController!.text.trim();
                                        if (_email.isEmpty) {
                                          showCustomSnackBar('Enter email address', context);
                                        }
                                        // else if (EmailChecker.isNotValid(_email)) {
                                        //   showCustomSnackBar('Enter valid email', context);
                                        // }
                                        else if (_password.isEmpty) {
                                          showCustomSnackBar('Enter password', context);
                                        }else if (_password.length < 6) {
                                          showCustomSnackBar('Password should be more than 6 character', context);
                                        }else {
                                          ResponseModel _response = await
                                          authProvider.login( context , _email, _password);
                                          // final authServices = Provider.of<
                                          //         CustomerAuthProvider>(
                                          //     context,
                                          //     listen: false);
                                          //
                                          // try {
                                          //   await authServices
                                          //       .signInWithEmailAndPass(context ,
                                          //           _email, _password);
                                          // } catch (e) {
                                          //   ScaffoldMessenger.of(context)
                                          //       .showSnackBar(SnackBar(
                                          //           content:
                                          //               Text(e.toString())));
                                          // }
                                          if(_response.isSuccess){
                                            Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context).then((value) {
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
                                                  OnBoardingScreen()));
                                            });
                                          }else{
                                            showCustomSnackBar('Unauthorized', context);
                                          }
                                        }
                                      }),
                                ),

                                const SizedBox(height: 25),

                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          })
      ),
    );
  }
}
