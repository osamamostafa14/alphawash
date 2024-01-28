import 'dart:convert';

import 'package:alphawash/data/datasource/remote/dio/dio_client.dart';
import 'package:alphawash/data/datasource/remote/exception/api_error_handler.dart';
import 'package:alphawash/data/model/response/admin_task_model.dart';
import 'package:alphawash/data/model/response/base/api_response.dart';
import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  LocationRepo({this.dioClient, this.sharedPreferences});

  Future<ApiResponse> storeNewArea(String name, String description,
      String latitude, String longitude) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.STORE_NEW_AREA_URI}?name=$name&latitude=$latitude&longitude=$longitude&description=$description');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateArea(int areaId, String name, String description,
      String latitude, String longitude) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.UPDATE_AREA_URI}?area_id=$areaId&name=$name&latitude=$latitude&longitude=$longitude&description=$description');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeArea(int areaId) async {
    try {
      final response = await dioClient!
          .post('${AppConstants.REMOVE_AREA_URI}?area_id=$areaId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAreasList() async {
    try {
      final response = await dioClient!.get(AppConstants.AREAS_LIST_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateUserAreas(List<int> areaIds, int userId) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.UPDATE_USER_AREAS_URI}?area_ids=$areaIds&user_id=$userId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getWorkerAreasList(int userId) async {
    try {
      final response = await dioClient!
          .get('${AppConstants.WORKER_AREAS_LIST_URI}?user_id=$userId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getWayPointsList() async {
    try {
      final response =
          await dioClient!.get('${AppConstants.WAYPOINTS_LIST_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getWorkerWayPointsList() async {
    try {
      final response =
          await dioClient!.get('${AppConstants.GET_WORKER_WAYPOINTS_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> storeWayPointInfo(WaypointModel waypoint) async {
    try {
      final response = await dioClient!
          .post(AppConstants.STORE_POINT_URI, data: waypoint.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error: ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateWayPointInfo(WaypointModel waypoint) async {
    try {
      final response = await dioClient!
          .post(AppConstants.UPDATE_POINT_URI, data: waypoint.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error: ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteWayPointInfo(int waypointId) async {
    try {
      final response = await dioClient!
          .post('${AppConstants.DELETE_POINT_URI}?waypoint_id=$waypointId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error: ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> storeTaskInfo(int workerId, int waypointId,
      DateTime taskDate, String taskDetails) async {
    try {
      final formattedTaskDate = taskDate.toIso8601String();
      final response = await dioClient!.post(
          '${AppConstants.STORE_TASK_URI}?worker_id=$workerId&waypoint_id=$waypointId&task_date=$formattedTaskDate&task_details=$taskDetails');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error: $e');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getTasksList(String offset) async {
    try {
      final response = await dioClient!
          .get('${AppConstants.GET_TASK_URI}?limit=10&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}
