import 'package:alphawash/data/datasource/remote/dio/dio_client.dart';
import 'package:alphawash/data/datasource/remote/exception/api_error_handler.dart';
import 'package:alphawash/data/model/response/base/api_response.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:flutter/material.dart';

class WorkerAreaRepo {
  final DioClient? dioClient;
  WorkerAreaRepo({@required this.dioClient});

  Future<ApiResponse> getAreasList() async {
    try {
      final response = await dioClient!.get(AppConstants.WORKER_AREAS_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
