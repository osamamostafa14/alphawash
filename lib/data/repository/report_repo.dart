import 'package:alphawash/data/model/response/base/api_response.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:alphawash/data/datasource/remote/dio/dio_client.dart';
import 'package:alphawash/data/datasource/remote/exception/api_error_handler.dart';

class ReportRepo {
  final DioClient? dioClient;
  ReportRepo({@required this.dioClient});

  Future<ApiResponse> getTaskUpdatesList(String offset, String dateType, String startDate, String endDate, String type) async {
    try {
      final response = await dioClient!
          .get('${AppConstants.ALL_TASKS_REPORT_URI}?limit=10&offset=$offset&date_type=$dateType&start_date=$startDate&end_date=$endDate&type=$type');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}