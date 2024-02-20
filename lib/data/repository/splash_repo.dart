import 'package:alphawash/data/datasource/remote/dio/dio_client.dart';
import 'package:alphawash/data/datasource/remote/exception/api_error_handler.dart';
import 'package:alphawash/data/model/response/base/api_response.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SplashRepo({ this.sharedPreferences,  this.dioClient});

  Future<ApiResponse> getConfig() async {
    try {
      final response = await dioClient!.get(AppConstants.CONFIG_URI);

      return ApiResponse.withSuccess(response);
    } catch (e) {

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> removeSharedData() {
    return sharedPreferences!.clear();
  }
}