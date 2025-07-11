import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alphawash/data/model/response/signup_model.dart';
import 'package:provider/provider.dart';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:alphawash/provider/splash_provider.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:alphawash/utill/color_resources.dart';
import 'package:alphawash/utill/dimensions.dart';
import 'package:alphawash/utill/images.dart';
import 'package:alphawash/view/base/custom_button.dart';
import 'package:alphawash/view/base/custom_snackbar.dart';
import 'package:alphawash/view/base/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FocusNode _fullNameFocus = FocusNode();
  //FocusNode _emailFocus = FocusNode();
  FocusNode _phoneNumberFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _confirmPasswordFocus = FocusNode();

  TextEditingController? _fullNameController;
  // TextEditingController? _emailController;
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
    //_emailController = TextEditingController();
    _phoneCodeController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel !=
        null) {
      _fullNameController!.text =
          Provider.of<ProfileProvider>(context, listen: false)
              .userInfoModel!
              .fullName!;
      //  _emailController!.text = Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.email!;
      _phoneNumberController!.text =
          Provider.of<ProfileProvider>(context, listen: false)
              .userInfoModel!
              .phone!;
    }

    _phoneCodeController!.text = '+1';
  }

  @override
  void dispose() {
    // _emailController!.dispose();
    _fullNameController!.dispose();
    _phoneNumberController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  void _choose() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        Provider.of<ProfileProvider>(context, listen: false)
            .setProfileImage(file!);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.2,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black87),
        ),
      ),
      body: SafeArea(child:
          Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
        return Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              // padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                    width: 1170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        // Profile Image
                        Container(
                          height: 80,
                          margin: EdgeInsets.symmetric(
                              vertical: Dimensions.PADDING_SIZE_LARGE),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorResources.OFF_WHITE,
                            border: Border.all(
                                color: ColorResources.COLOR_GREY_CHATEAU,
                                width: 3),
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: _choose,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: file != null
                                      ? Image.file(file!,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill)
                                      : data != null
                                          ? Image.network(data!.path,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.fill)
                                          : profileProvider
                                                      .userInfoModel!.image !=
                                                  null
                                              ? FadeInImage.assetNetwork(
                                                  placeholder:
                                                      Images.profile_icon,
                                                  image:
                                                      '${Provider.of<SplashProvider>(
                                                    context,
                                                  ).baseUrls!.userImageUrl}/${profileProvider.userInfoModel!.image}',
                                                  height: 80,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  height: 80,
                                                  width: 80,
                                                  child: Icon(Icons.person,
                                                      size: 30,
                                                      color: Colors.black54)),
                                ),
                                Positioned(
                                  bottom: 15,
                                  right: -10,
                                  child: InkWell(
                                      onTap: _choose,
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorResources.BORDER_COLOR,
                                          border: Border.all(
                                              width: 2,
                                              color: ColorResources
                                                  .COLOR_GREY_CHATEAU),
                                        ),
                                        child: Icon(Icons.edit, size: 13),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text('Enter Full name',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .color,
                                      fontSize: 16)),
                            )),

                        const SizedBox(height: 10),

                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: CustomTextField(
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
                              child: Text('Phone Number',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .color,
                                      fontSize: 16)),
                            )),

                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 0),
                          child: CustomTextField(
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
                              child: Text('Password',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .color,
                                      fontSize: 16)),
                            )),
                        const SizedBox(height: 10),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: CustomTextField(
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
                              child: Text('Confirm Password',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .color,
                                      fontSize: 16)),
                            )),
                        const SizedBox(height: 10),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: CustomTextField(
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

                        const SizedBox(height: 30),

                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: CustomButton(
                              btnTxt: 'Update',
                              onTap: () async {
                                FocusScope.of(context).unfocus();

                                String _fullName =
                                    _fullNameController!.text.trim();
                                String _phone =
                                    '${_phoneNumberController!.text.trim()}';
                                String _password =
                                    _passwordController!.text.trim();
                                String _confirmPassword =
                                    _confirmPasswordController!.text.trim();
                                if (_fullName.isEmpty) {
                                  showCustomSnackBar(
                                      'Enter full name', context);
                                } else if (_phone.length < 10) {
                                  showCustomSnackBar(
                                      'Enter valid phone number', context);
                                } else if (_password.length < 6 &&
                                    _password.length != 0) {
                                  showCustomSnackBar(
                                      'Password should be more than 6 character',
                                      context);
                                } else if (_password != _confirmPassword &&
                                    _password.length != 0) {
                                  showCustomSnackBar(
                                      'Password did not match', context);
                                } else {
                                  SignUpModel signUpModel = SignUpModel(
                                    fullName: _fullName,
                                    // email: _email,
                                    password: _password,
                                    phone: _phone,
                                  );

                                  var box = Hive.box('myBox');
                                  String token = box.get(AppConstants.TOKEN);
                                  profileProvider
                                      .updatePersonalInfo(token, signUpModel)
                                      .then((value) {
                                    if (value.statusCode == 200) {
                                      profileProvider.getUserInfo(context);
                                      showCustomSnackBar(
                                          'Profile Updated!', context,
                                          isError: false);
                                    } else {
                                      showCustomSnackBar(
                                          'Something went wrong!', context,
                                          isError: false);
                                    }
                                  });
                                }
                              }),
                        ),

                        const SizedBox(height: 30),
                      ],
                    )),
              ),
            ),
          ),
        );
      })),
    );
  }
}
