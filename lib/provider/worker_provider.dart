import 'dart:convert';
import 'dart:io';
import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/data/model/response/response_model.dart';
import 'package:alphawash/data/model/response/worker_task_model.dart';
import 'package:async/async.dart';
import 'package:alphawash/data/model/response/base/api_response.dart';
import 'package:alphawash/data/model/response/signup_model.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/data/repository/worker_repo.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/datasource/remote/dio/dio_client.dart';
import '../data/datasource/remote/exception/api_error_handler.dart';

class WorkerProvider with ChangeNotifier {
  final WorkerRepo? workerRepo;
  final DioClient? dioClient;

  WorkerProvider({
    @required this.workerRepo,
    @required this.dioClient,
  });

  PinPointsTaskModel? _pinPointsTaskModel;
  PinPointsTaskModel? get pinPointsTaskModel => _pinPointsTaskModel;

  ///////// WORKERS
  List<UserInfoModel>? _workersList;

  List<UserInfoModel>? get workersList => _workersList;

  bool _workersListLoading = false;

  bool get workersListLoading => _workersListLoading;

  ///// END WORKERS

  File? _profileImageFile;

  File? get profileImageFile => _profileImageFile;

  File? _taskImageFile;

  File? get taskImageFile => _taskImageFile;
  List<ReminderModel> _reminder = [];
  List<ReminderModel> get reminder => _reminder;

  bool _reminderLoading = false;
  bool get reminderLoading => _reminderLoading;

  Future<void> getReminder(BuildContext context) async {
    _reminderLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await workerRepo!.getWorkerTasksReminder();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {

      _reminder = [];
      apiResponse.response!.data.forEach((item) {
        ReminderModel reminder = ReminderModel.fromJson(item);
        _reminder.add(reminder);
      });
      _reminderLoading = false;
      notifyListeners();
    } else {
      _reminderLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }

    notifyListeners();
  }

  Future<void> getWorkersList(BuildContext context) async {
    _workersListLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await workerRepo!.getWorkersList();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {

      _workersList = [];
      apiResponse.response!.data.forEach((item) {
        _workersList!.add(UserInfoModel.fromJson(item));
      });
      _workersListLoading = false;
    } else {
      _workersListLoading = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }

    notifyListeners();
  }

  Future<http.StreamedResponse> updateWorkerInfo(
      String token, SignUpModel signUpdModel, int userId) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.UPDATE_WORKER_DETAILS_URI}'));
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
        'user_id': userId.toString(),
        'full_name': signUpdModel.fullName!,
        //'email' : signUpdModel.email!,
        'phone': signUpdModel.phone!,
        'password': signUpdModel.password!.toString(),
      });
    }
    request.fields.addAll(_fields);

    http.StreamedResponse response = await request.send();

    return response;
  }

  bool _storeWorkerLoading = false;

  bool get storeWorkerLoading => _storeWorkerLoading;

  Future<http.StreamedResponse> addNewWorker(
      String token, SignUpModel signUpdModel) async {
    _storeWorkerLoading = true;
    notifyListeners();
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.BASE_URL}${AppConstants.ADD_WORKER_URI}'));
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
    if (response.statusCode == 200) {
      _storeWorkerLoading = false;
      notifyListeners();
    } else if (response.statusCode == 403) {
      _storeWorkerLoading = false;
      notifyListeners();
    }

    return response;
  }

  void setProfileImage(File image) {
    _profileImageFile = image;
    notifyListeners();
  }

  Future<ResponseModel> removeWorker(int userId) async {
    _workersListLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await workerRepo!.removeWorker(userId);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _workersListLoading = false;
      notifyListeners();
      responseModel = ResponseModel(true, 'successful');
    } else {
      _workersListLoading = false;
      notifyListeners();
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    notifyListeners();
    return responseModel;
  }

  List<int> _selectedUserIds = [];
  List<int> get selectedUserIds => _selectedUserIds;

  int? _currentWaypointId;
  int? get currentWaypointId => _currentWaypointId;

  void setCurrentWaypointId(int waypointId) {
    _currentWaypointId = waypointId;
    notifyListeners();
  }

  void toggleSelected(int? userId, int? waypointId) {
    if (userId != null && waypointId != null) {
      setCurrentWaypointId(waypointId);
      print(waypointId);
      if (_selectedUserIds.contains(userId)) {
        _selectedUserIds.remove(userId);
      } else {
        _selectedUserIds.add(userId);
      }
      notifyListeners();
    }
  }

  void initSelectedUsersList(int? userId, int? waypointId) {
    setCurrentWaypointId(waypointId!);
    _selectedUserIds.add(userId!);
    notifyListeners();
  }

  void resetSelectedUsersList() {
    _selectedUserIds = [];
    notifyListeners();
  }

  bool isUserSelected(int? userId, int? waypointId) {
    return userId != null &&
        _currentWaypointId != null &&
        waypointId != null &&
        _currentWaypointId == waypointId &&
        _selectedUserIds.contains(userId);
  }

  bool _sendUserSelectLoading = false;
  bool get sendUserSelectLoading => _sendUserSelectLoading;

  Future<ResponseModel> SendselectUserWaypoint() async {
    _sendUserSelectLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await workerRepo!
        .selectUserWaypoint(_selectedUserIds, _currentWaypointId!);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _sendUserSelectLoading = false;
      notifyListeners();
      responseModel = ResponseModel(true, 'successful');
    } else {
      _sendUserSelectLoading = false;
      notifyListeners();
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    notifyListeners();
    return responseModel;
  }

  void setSelectedUserIds(List<int> selectedUserIds) {
    _selectedUserIds = selectedUserIds;
    notifyListeners();
  }

  void setTaskImage(File image) {
    _taskImageFile = image;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<http.StreamedResponse> addPinPointTask(
      String token, int userId, int pinpointId, String details) async {
    _isLoading = true;
    notifyListeners();

    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.ADD_PINPOINT_TASK_URI}'));
    request.headers.addAll(<String, String>{
      'Authorization': 'Bearer $token',
    });

    if (_taskImageFile != null) {
      var stream = http.ByteStream(Stream.castFrom(_taskImageFile!.openRead()));
      var length = await _taskImageFile!.length();

      request.files.add(http.MultipartFile(
        'image',
        stream,
        length,
        filename: _taskImageFile!.path.split('/').last,
      ));
    }

    Map<String, String> _fields = {
      '_method': 'post',
      'user_id': userId.toString(),
      'pinpoint_id': pinpointId.toString(),
      'details': details,
    };
    request.fields.addAll(_fields);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Success');
    } else {
      print('Not good. Reason: ${response.reasonPhrase}');
    }

    _isLoading = false;
    notifyListeners();

    return response;
  }

  Future<http.StreamedResponse> updatePinPointTask(
      String token, int taskId, String details) async {
    _isLoading = true;
    notifyListeners();

    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.UPDATE_PINPOINT_TASK_URI}'));
    request.headers.addAll(<String, String>{
      'Authorization': 'Bearer $token',
    });

    if (_taskImageFile != null) {
      var stream = http.ByteStream(Stream.castFrom(_taskImageFile!.openRead()));
      var length = await _taskImageFile!.length();

      request.files.add(http.MultipartFile(
        'image',
        stream,
        length,
        filename: _taskImageFile!.path.split('/').last,
      ));
    }

    Map<String, String> _fields = {
      '_method': 'post',
      'task_id': taskId.toString(),
      'details': details,
    };
    request.fields.addAll(_fields);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Success');
    } else {
      print('failed. Reason: ${response.reasonPhrase}');
    }

    _isLoading = false;
    notifyListeners();

    return response;
  }

  bool _workerOldTasksListLoading = false;
  bool get workerOldTasksListLoading => _workerOldTasksListLoading;

  List<PinPointsTaskModel> _tasks = [];
  List<PinPointsTaskModel> get tasks => _tasks;

  Future<void> getOldTasks(BuildContext context, int pinpointId) async {
    print('pinpointId=> ${pinpointId}');
    _workerOldTasksListLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await workerRepo!.getOldTasks(pinpointId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _workerOldTasksListLoading = false;
      notifyListeners();
      _tasks = [];
      apiResponse.response!.data.forEach((item) {
        PinPointsTaskModel task = PinPointsTaskModel.fromJson(item);
        _tasks.add(task);
      });
    } else {
      _workerOldTasksListLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
    notifyListeners();
  }

  void getPinPointFirstTask() {
    notifyListeners();
  }

  int _selectedWorkerId = -1;
  int get selectedWorkerId => _selectedWorkerId;

  String get selectedWorkerName {
    try {
      UserInfoModel? selectedWorker = workersList
          ?.firstWhere((workerList) => workerList.id == selectedWorkerId);
      return selectedWorker?.fullName ?? '';
    } catch (e) {
      return '';
    }
  }

  void setSelectedWorkerId(int id) {
    _selectedWorkerId = id;
    notifyListeners();
  }

  List<PinPointsTaskModel> _workerTasks = [];
  List<WorkerTaskModel> get workerTasks => _workerTasks;

  bool _workerTasksListLoading = false;
  bool get workerTasksListLoading => _workerTasksListLoading;

  Future<void> getWorkerTasksList(BuildContext context) async {
    try {
      _workerTasksListLoading = true;
      notifyListeners();

      ApiResponse apiResponse = await workerRepo!.getWorkerTasksList();

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _workerTasksListLoading = false;
        _workerTasks = (apiResponse.response!.data as List)
            .map((item) => WorkerTaskModel.fromJson(item))
            .toList();
      } else {
        _workerTasksListLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apiResponse.error.toString())),
        );
      }
    } catch (error) {
      _workerTasksListLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $error")),
      );
    } finally {
      notifyListeners();
    }
  }

  Future<ResponseModel> workerPermissions(
      int? areas,
      int? waypoints,
      int? addPinpointTask,
      int? showPinpointTasks,
      int? editPinpointTask,
      int? tasks,
      int? workerId) async {
    _workerPermissionsLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await workerRepo!.workerPermissions(
      areas,
      waypoints,
      addPinpointTask,
      showPinpointTasks,
      editPinpointTask,
      tasks,
      workerId,
    );

    _workerPermissionsLoading = false;
    notifyListeners();

    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, 'successful');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  WorkerPermissionsModel? _workerPermission;
  WorkerPermissionsModel? get workerPermission => _workerPermission;

  bool _workerPermissionsLoading = false;
  bool get workerPermissionsLoading => _workerPermissionsLoading;

  void initWorkerPermissions(WorkerPermissionsModel permissions) {
    _workerPermission = permissions;
  }

  void updateWorkerPermissions(int value, String type) {
    if (type == "area") {
      _workerPermission!.area = value;
    } else if (type == "waypoints") {
      _workerPermission!.waypoints = value;
    } else if (type == "add_pinpoint_task") {
      _workerPermission!.addPinpoints = value;
    } else if (type == "show_pinpoint_tasks") {
      _workerPermission!.showPinpoints = value;
    } else if (type == "edit_pinpoint_task") {
      _workerPermission!.editPinpoints = value;
    } else if (type == "tasks") {
      _workerPermission!.tasks = value;
    }
    notifyListeners();
  }
  bool _workerOldAdminTasksListLoading = false;
  bool get workerOldAdminTasksListLoading => _workerOldAdminTasksListLoading;

  List<PinPointsTaskModel> _adminTasks = [];
  List<PinPointsTaskModel> get adminTasks => _adminTasks;

  Future<void> getAdminTasksList(BuildContext context, int pinpointId) async {
    print('pinpointId=> ${pinpointId}');
    _workerOldAdminTasksListLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await workerRepo!.getAdminTasksList(pinpointId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _workerOldAdminTasksListLoading = false;
      notifyListeners();
      _adminTasks = [];
      apiResponse.response!.data.forEach((item) {
        PinPointsTaskModel task = PinPointsTaskModel.fromJson(item);
        _adminTasks.add(task);
      });
    } else {
      _workerOldAdminTasksListLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
    notifyListeners();
  }
}
