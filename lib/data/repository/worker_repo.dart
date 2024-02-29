import 'dart:io';

import 'package:alphawash/data/model/response/base/api_response.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'package:alphawash/data/datasource/remote/dio/dio_client.dart';
import 'package:alphawash/data/datasource/remote/exception/api_error_handler.dart';
import 'package:alphawash/data/model/response/pin_point_model.dart';

class WorkerRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  WorkerRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getWorkersList() async {
    try {
      final response = await dioClient!.get(AppConstants.WORKERS_LIST_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOldTasks(int pinpointId) async {
    try {
      final response = await dioClient!
          .get('${AppConstants.GET_PINPOINT_TASK_URI}?pinpoint_id=$pinpointId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeWorker(int userId) async {
    try {
      final response = await dioClient!
          .post('${AppConstants.DELETE_WORKER_URI}?user_id=$userId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error here: ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> selectUserWaypoint(
      List<int> userIds, int waypointId) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.SELECT_USERS_URI}?user_ids=$userIds&waypoint_id=$waypointId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error here: ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getWorkerTasksList() async {
    try {
      final response = await dioClient!.get(AppConstants.GET_WORKER_TASKS_URI);
      print('ApiResponse Success: ${ApiResponse.withSuccess(response)}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(
          'ApiResponse Wrong: ${e.runtimeType} - ${ApiErrorHandler.getMessage(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getWorkerTasksReminder() async {
    try {
      final response = await dioClient!.get(AppConstants.TASK_REMINDER_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error here: ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> workerPermissions(
      int? areas,
      int? waypoints,
      int? addPinpointTask,
      int? showPinpointTasks,
      int? editPinpointTask,
      int? tasks,
      int? workerId) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.POST_PERMISSION_URI}?areas=$areas&waypoints=$waypoints&add_pinpoint_task=$addPinpointTask&show_pinpoint_tasks=$showPinpointTasks&edit_pinpoint_task=$editPinpointTask&tasks=$tasks&worker_id=$workerId ');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error here: ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  } Future<ApiResponse> getAdminTasksList(int pinpointId) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.GET_ADMIN_PINPOINT_TASKS_LIST_URI}?pinpoint_id=$pinpointId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
