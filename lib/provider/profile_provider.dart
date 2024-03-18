import 'dart:convert';
import 'dart:io';
import 'package:alphawash/data/model/response/base/api_response.dart';
import 'package:alphawash/data/model/response/response_model.dart';
import 'package:alphawash/data/model/response/signup_model.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/data/repository/profile_repo.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo? profileRepo;
  ProfileProvider({@required this.profileRepo});

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  bool _loading = false;
  bool get loading => _loading;

  File? _profileImageFile;
  File? get profileImageFile => _profileImageFile;

  bool _imagesLoading = false;
  bool get imagesLoading => _imagesLoading;

  Future<ResponseModel> getUserInfo(BuildContext context) async {
    ResponseModel _responseModel;
    ApiResponse apiResponse = await profileRepo!.getUserInfo();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('my_defined_user_id', _userInfoModel!.id!);
      _responseModel = ResponseModel(true, 'successful');
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      _responseModel = ResponseModel(false, _errorMessage);
      //  ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _responseModel;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> updateUserInfo(
      UserInfoModel updateUserModel, String password, String token) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    http.StreamedResponse response =
        await profileRepo!.updateProfile(updateUserModel, password, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _userInfoModel = updateUserModel;
      if (message == 'Email taken') {
        _responseModel = ResponseModel(false, message);
      } else
        _responseModel = ResponseModel(true, message);
      print(message);
    } else {
      _responseModel = ResponseModel(
          false, '${response.statusCode} ${response.reasonPhrase}');
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return _responseModel;
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setProfileImage(File image) {
    _profileImageFile = image;
    notifyListeners();
  }

  Future<http.StreamedResponse> updatePersonalInfo(
      String token, SignUpModel signUpdModel) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.UPDATE_PERSONAL_INFO_URI}'));
    request.headers
        .addAll(<String, String>{'Authorization': 'Bearer ${token}'});
    if (_profileImageFile != null) {
      print('step 2');
      print(
          '----------------${_profileImageFile!.readAsBytes().asStream()}/${_profileImageFile!.lengthSync()}/${_profileImageFile!.path.split('/').last}');
      request.files.add(http.MultipartFile(
          'profile_image',
          new http.ByteStream(
              DelegatingStream.typed(_profileImageFile!.openRead())),
          _profileImageFile!.lengthSync(),
          filename: _profileImageFile!.path.split('/').last));
    }

    Map<String, String> _fields = Map();
    {
      _fields.addAll(<String, String>{
        '_method': 'post',
        'full_name': signUpdModel.fullName!,
        'email': signUpdModel.email!,
        'phone': signUpdModel.phone!,
        'password': signUpdModel.password!.toString(),
      });
    }
    request.fields.addAll(_fields);

    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> updateWorkerBio(
      String token, String bio) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.UPDATE_WORKER_BIO_URI}'));
    request.headers
        .addAll(<String, String>{'Authorization': 'Bearer ${token}'});
    if (_profileImageFile != null) {
      print('step 2');
      print(
          '----------------${_profileImageFile!.readAsBytes().asStream()}/${_profileImageFile!.lengthSync()}/${_profileImageFile!.path.split('/').last}');
      request.files.add(http.MultipartFile(
          'profile_image',
          new http.ByteStream(
              DelegatingStream.typed(_profileImageFile!.openRead())),
          _profileImageFile!.lengthSync(),
          filename: _profileImageFile!.path.split('/').last));
    }

    Map<String, String> _fields = Map();
    {
      _fields.addAll(<String, String>{
        '_method': 'post',
        'bio': bio,
      });
    }
    request.fields.addAll(_fields);

    http.StreamedResponse response = await request.send();
    return response;
  }

  void resetImagesLoading() {
    _imagesLoading = false;
    notifyListeners();
  }
}
