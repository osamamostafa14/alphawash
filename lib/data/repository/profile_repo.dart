import 'package:alphawash/data/datasource/remote/dio/dio_client.dart';
import 'package:alphawash/data/datasource/remote/exception/api_error_handler.dart';
import 'package:alphawash/data/model/response/base/api_response.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo{
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  ProfileRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await dioClient!.get(AppConstants.CUSTOMER_INFO_URI);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<http.StreamedResponse> updateProfile(UserInfoModel userInfoModel, String password, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.UPDATE_PROFILE_URI}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

    Map<String, String> _fields = Map();
    if(password.isEmpty) {
      _fields.addAll(<String, String>{
        '_method': 'put', 'full_name': userInfoModel.fullName!,
        'email': userInfoModel.email!, 'phone': userInfoModel.phone!
      });
    }else {
      _fields.addAll(<String, String>{
        '_method': 'put', 'full_name': userInfoModel.fullName!, 'password': password,
        'email': userInfoModel.email!, 'phone': userInfoModel.phone!
      });
    }
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }
}
