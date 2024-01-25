import 'package:alphawash/data/model/response/base/api_response.dart';
import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/data/model/response/task_report_model.dart';
import 'package:alphawash/data/repository/report_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReportProvider with ChangeNotifier {
  final ReportRepo? reportRepo;
  ReportProvider({this.reportRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _bottomIsLoading = false;
  bool get bottomIsLoading => _bottomIsLoading;

  List<TaskUpdateModel>? _taskUpdatesList;
  List<TaskUpdateModel>? get taskUpdatesList => _taskUpdatesList;

  List<PinPointsTaskModel> _tasksWithoutUpdates = [];
  List<PinPointsTaskModel> get tasksWithoutUpdates => _tasksWithoutUpdates;

  String? _taskUpdatesOffset;
  String? get taskUpdatesOffset => _taskUpdatesOffset;

  int? _totalSize;
  int? get totalSize => _totalSize;

  int? _totalPinpointTasks;
  int? get totalPinpointTasks => _totalPinpointTasks;


  int? _newTasksCount;
  int? get newTasksCount => _newTasksCount;

  int? _updatedTasksCount;
  int? get updatedTasksCount => _updatedTasksCount;

  List<String> _tasksOffsetList = [];

  void getTaskUpdates(BuildContext? context, String offset, String dateType, String startDate, String endDate, String type) async {
    if (offset == '1') {
      _isLoading = true;
    }

    if (!_tasksOffsetList.contains(offset)) {
      _tasksOffsetList.add(offset);
      ApiResponse apiResponse = await reportRepo!.getTaskUpdatesList(offset, dateType, startDate, endDate, type);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _bottomIsLoading = false;
        if (offset == '1') {
          _taskUpdatesList = [];
        }
        _tasksWithoutUpdates = [];
        _totalSize = TaskUpdatePaginator.fromJson(apiResponse.response!.data).totalSize;
        _totalPinpointTasks = TaskUpdatePaginator.fromJson(apiResponse.response!.data).totalPinpointTasks;
        _taskUpdatesList!.addAll(TaskUpdatePaginator.fromJson(apiResponse.response!.data).taskUpdates!);
        _tasksWithoutUpdates.addAll(TaskUpdatePaginator.fromJson(apiResponse.response!.data).tasksWithoutUpdates!);
        _taskUpdatesOffset = TaskUpdatePaginator.fromJson(apiResponse.response!.data).offset;
        _newTasksCount = TaskUpdatePaginator.fromJson(apiResponse.response!.data).newTasksCount;
        _updatedTasksCount = TaskUpdatePaginator.fromJson(apiResponse.response!.data).updatedTasksCount;
        _isLoading = false;
      } else {
        _bottomIsLoading = false;
        _isLoading = false;
        ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      if (_isLoading) {
        _bottomIsLoading = false;
        _isLoading = false;
      }
    }
    notifyListeners();
  }


  void showBottomTasksLoader() {
    _bottomIsLoading = true;
    notifyListeners();
  }

  void clearOffset() {
    _tasksOffsetList.clear();
    _taskUpdatesList = [];
    notifyListeners();
  }

  String _selectedFilterType = 'all';
  String get selectedFilterType => _selectedFilterType;

  String _updatesType = 'all';
  String get updatesType => _updatesType;

  void setSelectedFilterType(String type) {
    _selectedFilterType = type;
    notifyListeners();
  }

  void setTaskUpdatesType(String type) {
    _updatesType = type;
    notifyListeners();
  }

  bool _showFilter = false;
  bool get showFilter => _showFilter;

  void setFilterVisibility() {
    _showFilter == false? _showFilter = true: _showFilter = false;
    notifyListeners();
  }
}