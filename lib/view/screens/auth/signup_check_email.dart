import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/data/helper/email_checker.dart';
import 'package:alphawash/localization/language_constrants.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:alphawash/view/base/custom_text_field.dart';
import 'package:alphawash/view/screens/auth/login_screen.dart';
import 'package:alphawash/view/screens/auth/signup_screen.dart';
import 'package:alphawash/view/screens/forgot_password/verification_screen.dart';

class SignUpCheckEmail extends StatefulWidget {
  @override
  _SignUpCheckEmailState createState() => _SignUpCheckEmailState();
}

class _SignUpCheckEmailState extends State<SignUpCheckEmail> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<CustomerAuthProvider>(context, listen: false).clearVerificationMessage();
  }

  @override
  Widget build(BuildContext? context) {

    return Scaffold(
      backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Check email', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Container(
                width: 1170,
                child: Consumer<CustomerAuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),

                      Center(
                          child: Text(
                            "Check Email",
                            style: TextStyle(color: Theme.of(context).textTheme.headline2!.color, fontSize: 24),
                          )),
                      SizedBox(height: 35),
                      Text(
                        'Email',
                        style: TextStyle(color: Theme.of(context).textTheme.headline2!.color, fontSize: 15),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        hintText: 'example@gmail.com',
                        isShowBorder: true,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authProvider.verificationMessage.length > 0
                              ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                              : SizedBox.shrink(),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authProvider.checkEmailMessage ?? "",
                              style: Theme.of(context).textTheme.headline2!.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      // for continue button
                      SizedBox(height: 12),
                      !authProvider.checkEmailLoading
                          ? CustomButton(
                        btnTxt: 'Continue',
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          String _email = _emailController.text.trim();
                          if (_email.isEmpty) {
                            showCustomSnackBar('Enter email address', context);
                          }else if (EmailChecker.isNotValid(_email)) {
                            showCustomSnackBar('Enter valid email address', context);
                          }else {
                            authProvider.checkEmail(_email, 'no').then((value) async {
                              if (value.isSuccess) {
                                authProvider.updateEmail(_email);
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext? context)=> VerificationScreen(emailAddress: _emailController.text, fromSignUp: true)));
                                // if (value.message == 'active') {
                                //   // Navigator.pushNamed(context, Routes.getVerifyRoute('sign-up', _email));
                                //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext? context)=> VerificationScreen(emailAddress: _emailController.text, fromSignUp: true)));
                                // } else {
                                //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> SignupScreen(email: _emailController.text)));
                                // }
                              }
                            });
                          }
                        },
                      )
                          : Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          )),

                      // for create an account
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account',
                                style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 15, color: Theme.of(context).textTheme.headline2!.color),
                              ),

                              const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                              Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                !.copyWith(fontSize: 15, color: Theme.of(context).textTheme.headline2!.color, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
