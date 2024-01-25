import 'package:alphawash/view/screens/dashboard/dashboard_screen.dart';
import 'package:alphawash/view/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:alphawash/view/screens/auth/create_new_password_screen.dart';

class EmailVerificationScreen extends StatelessWidget {
  final String? emailAddress;
  final bool? forgotPassword;
  EmailVerificationScreen(
      {@required this.emailAddress, this.forgotPassword = false});

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      backgroundColor: Theme.of(context!).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Verify email',
            style: TextStyle(color: Theme.of(context).primaryColor)),
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
            physics: BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<CustomerAuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 55),
                      Center(
                        child:
                            Icon(Icons.email, size: 100, color: Colors.black54),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                            child: Text(
                          'Please enter 4 digit code \n $emailAddress',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 39, vertical: 35),
                        child: PinCodeTextField(
                          textStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline2!.color),
                          length: 4,
                          appContext: context,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight: 63,
                            fieldWidth: 55,
                            borderWidth: 1,
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: ColorResources.colorMap[200],
                            selectedFillColor: Colors.white,
                            inactiveFillColor: Colors.black12,
                            inactiveColor: ColorResources.colorMap[200],
                            activeColor: ColorResources.colorMap[400],
                            activeFillColor: Colors.black12,
                          ),
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: authProvider.updateVerificationCode,
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),
                      Center(
                          child: Text(
                        'I didn\'t receive the code',
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              color:
                                  Theme.of(context).textTheme.headline2!.color,
                            ),
                      )),
                      authProvider.checkEmailLoading
                          ? Center(
                              child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ))
                          : Center(
                              child: InkWell(
                                onTap: () {
                                  Provider.of<CustomerAuthProvider>(context,
                                          listen: false)
                                      .checkEmail(emailAddress!, 'yes')
                                      .then((value) {
                                    if (value.isSuccess) {
                                      showCustomSnackBar(
                                          'Resend code successful', context,
                                          isError: false);
                                    } else {
                                      showCustomSnackBar(
                                          value.message, context);
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  child: Text(
                                    'Resend code',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline2!
                                              .color,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 48),
                      !authProvider.verifyTokenLoading
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: CustomButton(
                                btnTxt: 'Verify',
                                onTap: () {
                                  authProvider
                                      .verifyToken(emailAddress!)
                                      .then((value) {
                                    if (value.isSuccess) {
                                      if (forgotPassword!) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        CreateNewPasswordScreen(
                                                            email:
                                                                emailAddress)));
                                      } else {
                                        authProvider
                                            .registration(context,
                                                authProvider.signUpModel!)
                                            .then((status) async {
                                          if (status.isSuccess) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        OnBoardingScreen()));
                                          }
                                        });
                                      }

                                      showCustomSnackBar('Success', context,
                                          isError: false);
                                    } else {
                                      showCustomSnackBar(
                                          value.message, context);
                                    }
                                  });
                                },
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)))
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
