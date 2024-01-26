import 'dart:io';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alphawash/data/helper/email_checker.dart';
import 'package:alphawash/data/model/response/signup_model.dart';
import 'package:alphawash/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:alphawash/view/base/custom_text_field.dart';
import 'package:alphawash/view/screens/auth/login_screen.dart';

class SignupScreen extends StatefulWidget {
  final String? email;
  SignupScreen({this.email});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  FocusNode _fullNameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _phoneNumberFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _confirmPasswordFocus = FocusNode();

  TextEditingController? _fullNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _phoneCodeController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;

  GlobalKey<FormState>? _formKeyLogin;

  File? file;
  PickedFile? data;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneCodeController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    if(Provider.of<CustomerAuthProvider>(context, listen: false).signUpModel!=null){
      _fullNameController!.text = Provider.of<CustomerAuthProvider>(context, listen: false).signUpModel!.fullName!;
      _emailController!.text = Provider.of<CustomerAuthProvider>(context, listen: false).signUpModel!.email!;
      _passwordController!.text = Provider.of<CustomerAuthProvider>(context, listen: false).signUpModel!.password!;
      _confirmPasswordController!.text = Provider.of<CustomerAuthProvider>(context, listen: false).signUpModel!.password!;
      _phoneCodeController!.text = Provider.of<CustomerAuthProvider>(context, listen: false).signUpModel!.phone!;
    }

    _phoneCodeController!.text = '+1';
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _fullNameController!.dispose();
    _phoneNumberController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
          child:
          Consumer<CustomerAuthProvider>(
              builder: (context, authProvider, child){
                return  Center(
                  child:Scrollbar(
                    child: SingleChildScrollView(
                      // padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                      physics: BouncingScrollPhysics(),
                      child: Center(
                        child: SizedBox(
                            width: 1170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),

                                Align(
                                  alignment: Alignment.center,
                                  child: Text('Sign Up', style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20
                                  )),
                                ),
                                const SizedBox(height: 10),

                                Align(
                                  alignment: Alignment.center,
                              child: Container(
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  //border: Border.all(width: 2, color: Theme),
                                ),
                              ),
                            ),

                                const SizedBox(height: 50),

                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text('Enter Full name', style: TextStyle(color: Theme.of(context).textTheme.headline2!.color, fontSize: 16)),
                                    )),

                                const SizedBox(height: 10),

                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20),
                                      child:  CustomTextField(
                                        hintText: 'Mr. John',
                                        isShowBorder: true,
                                        inputType: TextInputType.text,
                                        inputAction: TextInputAction.next,
                                        focusNode: _fullNameFocus,
                                        controller: _fullNameController,
                                        isIcon: true,
                                        isShowPrefixIcon: true,
                                        prefixIconUrl: Images.user_icon,
                                      ),
                                    )),

                                const SizedBox(height: 20),
                                /// Phone Number

                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text('Phone Number', style: TextStyle(color: Theme.of(context).textTheme.headline2!.color, fontSize: 16)),
                                    )),

                                const SizedBox(height: 10),

                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                                  child:   CustomTextField(
                                    maxLength: 12,
                                    hintText: 'ex: +57 xxxxxxxxxx',
                                    isShowBorder: true,
                                    inputType: TextInputType.number,
                                    inputAction: TextInputAction.next,
                                    focusNode: _phoneNumberFocus,
                                    controller: _phoneNumberController,
                                    isIcon: true,
                                    nextFocus: _passwordFocus,
                                  ),
                                ),

                                /// End Phone Number
                                const SizedBox(height: 20),

                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text('Password', style: TextStyle(color: Theme.of(context).textTheme.headline2!.color, fontSize: 16)),
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
                                const SizedBox(height: 15),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text('Confirm Password', style: TextStyle(color: Theme.of(context).textTheme.headline2!.color, fontSize: 16)),
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
                                        focusNode: _confirmPasswordFocus,
                                        controller: _confirmPasswordController,
                                        isIcon: true,
                                        isShowPrefixIcon: true,
                                        isShowSuffixIcon: true,
                                        prefixIconUrl: Images.lock_icon,

                                      ),
                                    )),

                                const SizedBox(height: 20),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 20),
                                    authProvider.registrationErrorMessage.length > 0
                                        ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                        : SizedBox.shrink(),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        authProvider.registrationErrorMessage ?? "",
                                        style: Theme.of(context).textTheme.headline2!.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                SizedBox(height: authProvider.registrationErrorMessage.length > 0? 10 : 0),

                                authProvider.isLoading?
                                Center(
                                    child: CircularProgressIndicator(
                                      valueColor: new AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor),
                                    )):

                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: CustomButton(btnTxt: 'Next',
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();

                                        String _fullName =
                                        _fullNameController!.text.trim();

                                        String _email =
                                        widget.email!;

                                        String _phone =
                                            '${_phoneNumberController!.text.trim()}';

                                        String _password =
                                        _passwordController!.text.trim();

                                        String _confirmPassword =
                                        _confirmPasswordController!.text.trim();

                                        if (_email.isEmpty) {
                                          showCustomSnackBar('Enter email address', context);
                                        }else if (EmailChecker.isNotValid(_email)) {
                                          showCustomSnackBar('Enter valid email', context);
                                        }
                                        else if (_fullName.isEmpty) {
                                          showCustomSnackBar(
                                              'Enter full name',
                                              context);
                                        }
                                        else if (_phone.length < 10) {
                                          showCustomSnackBar(
                                              'Enter valid phone number',
                                              context);
                                        }

                                        else if (_password.isEmpty) {
                                          showCustomSnackBar(
                                              'Enter password',
                                              context);
                                        } else if (_password.length < 6) {
                                          showCustomSnackBar(
                                              'Password should be more than 6 character',
                                              context);
                                        } else if (_confirmPassword.isEmpty) {
                                          showCustomSnackBar(
                                              'Enter confirm password field',
                                              context);
                                        } else if (_password != _confirmPassword) {
                                          showCustomSnackBar(
                                              'Password did not match',
                                              context);
                                        } else {
                                          SignUpModel signUpModel = SignUpModel(
                                            fullName: _fullName,
                                            email: _email,
                                            password: _password,
                                            phone: _phone,
                                          );
                                          authProvider.setSignUpModel(signUpModel);
                                          authProvider.registration(context ,signUpModel).then((status) async {
                                            if (status.isSuccess) {
                                              Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context).then((value) {
                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
                                                    DashboardScreen(pageIndex: 0)));
                                              });
                                            }
                                          });
                                        }
                                      }),
                                ),

                                const SizedBox(height: 30),

                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Already have an account?',
                                          style: TextStyle(color: Theme.of(context).textTheme.headline2!.color, fontSize: 16)),

                                      const SizedBox(width: 10),

                                      Text('Sign In',
                                          style: TextStyle(color: Theme.of(context).primaryColor,
                                              fontSize: 16, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),


                                const SizedBox(height: 30),

                              ],
                            )
                        ),
                      ),
                    ),
                  ),
                );
              })
      ),
    );
  }
}
