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

class BioScreen extends StatefulWidget {
  @override
  _BioScreenState createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {

  FocusNode _bioFocus = FocusNode();

  TextEditingController? _bioController;

  GlobalKey<FormState>? _formKeyLogin;

  File? file;
  PickedFile? data;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _bioController = TextEditingController();

    _bioController!.text = Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.bio != null?
    Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.bio! : '';
  }

  @override
  void dispose() {
    // _emailController!.dispose();
    _bioController!.dispose();
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
        Provider.of<ProfileProvider>(context, listen: false).setProfileImage(file!);
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
        title: const Text('Bio', style: TextStyle(color: Colors.black87)),
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
      body: SafeArea(
          child:
          Consumer<ProfileProvider>(
              builder: (context, profileProvider, child){
                return  Center(
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

                                // Profile Image
                                Container(
                                  height: 80,
                                  margin: EdgeInsets.symmetric(
                                      vertical: Dimensions
                                          .PADDING_SIZE_LARGE),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: ColorResources.OFF_WHITE,
                                    border: Border.all(
                                        color: ColorResources
                                            .COLOR_GREY_CHATEAU,
                                        width: 3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: InkWell(
                                    onTap:
                                    _choose,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(50),
                                          child: file != null
                                              ? Image.file(file!,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.fill)
                                              : data != null
                                              ? Image.network(
                                              data!.path,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.fill)
                                              :
                                          profileProvider.userInfoModel!.image!=null?
                                          FadeInImage.assetNetwork(
                                            placeholder: Images.profile_icon,
                                            image: '${Provider.of<SplashProvider>(context,).baseUrls!.userImageUrl}/${profileProvider.userInfoModel!.image}',
                                            height: 80, width: 80, fit: BoxFit.cover,
                                          ): Container(
                                              height: 80,
                                              width: 80,
                                              child: Icon(Icons.person, size: 30, color: Colors.black54)),
                                        ),
                                        Positioned(
                                          bottom: 15,
                                          right: -10,
                                          child: InkWell(
                                              onTap: _choose,
                                              child: Container(
                                                alignment:
                                                Alignment.center,
                                                padding:
                                                EdgeInsets.all(2),
                                                decoration:
                                                BoxDecoration(
                                                  shape:
                                                  BoxShape.circle,
                                                  color: ColorResources
                                                      .BORDER_COLOR,
                                                  border: Border.all(
                                                      width: 2,
                                                      color: ColorResources
                                                          .COLOR_GREY_CHATEAU),
                                                ),
                                                child: Icon(Icons.edit,
                                                    size: 13),
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
                                      child: Text('Bio', style: TextStyle(color: Theme.of(context).textTheme.headline2!.color, fontSize: 16)),
                                    )),

                                const SizedBox(height: 10),

                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20),
                                      child:  CustomTextField(
                                        hintText: 'Write your bio here',
                                        isShowBorder: true,
                                        inputType: TextInputType.text,
                                        inputAction: TextInputAction.next,
                                        focusNode: _bioFocus,
                                        controller: _bioController,
                                        maxLines: 4,
                                      ),
                                    )),

                                const SizedBox(height: 30),

                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: CustomButton(btnTxt: 'Update',
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();

                                        String _bio =
                                        _bioController!.text.trim();

                                        if (_bio.isEmpty) {
                                          showCustomSnackBar(
                                              'Enter bio',
                                              context);
                                        }
                                        else {
                                          var box = Hive.box('myBox');
                                          String token = box.get(AppConstants.TOKEN);
                                          profileProvider.updateWorkerBio(token, _bio).then((value) {
                                            if(value.statusCode == 200){
                                              profileProvider.getUserInfo(context);
                                              showCustomSnackBar('Profile Updated!', context, isError:false);
                                            }else{
                                              showCustomSnackBar('Something went wrong!', context, isError:false);
                                            }
                                          });
                                        }
                                      }),
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


