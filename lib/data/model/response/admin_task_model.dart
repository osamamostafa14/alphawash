import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/data/model/response/waypoint_model.dart';

class AdminTaskModel {
  int? _waypointId;
  int? _workerId;
  String? _taskDetails;
  DateTime? _requiredDateTime;
  WaypointModel? _waypoint;
  UserInfoModel? _worker;

  AdminTaskModel({
    int? waypointId,
    int? workerId,
    WaypointModel? waypoint,
    UserInfoModel? worker,
    String? taskDetails,
    DateTime? requiredDateTime,
  }) {
    this._waypointId = waypointId;
    this._workerId = workerId;
    this._taskDetails = taskDetails;
    this._waypoint = waypoint;
    this._worker = worker;
    this._requiredDateTime = requiredDateTime;
  }
  WaypointModel? get waypoint => _waypoint;
  UserInfoModel? get worker => _worker;

  int? get waypointId => _waypointId;
  int? get workerId => _workerId;
  String? get taskDetails => _taskDetails;
  DateTime? get requiredDateTime => _requiredDateTime;

  AdminTaskModel.fromJson(Map<String, dynamic> json) {
    _waypoint = json['waypoint'] != null
        ? WaypointModel.fromJson(json['waypoint'])
        : null;
    _worker =
        json['worker'] != null ? UserInfoModel.fromJson(json['worker']) : null;
    _waypointId = json['waypoint_id'];
    _workerId = json['worker_id'];
    _taskDetails = json['task_details'];
    _requiredDateTime = DateTime.tryParse(json['task_date'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'worker': _worker != null ? _worker!.toJson() : null,
      'waypoint': _waypoint != null ? _waypoint!.toJson() : null,
      'task_details': _taskDetails,
      'waypoint_id': _waypointId,
      'worker_id': _workerId,
      'task_date': _requiredDateTime?.toIso8601String(),
    };
    return data;
  }
}

class TaskPaginator {
  int? _totalSize;
  String? _limit;
  String? _offset;
  List<PinPointsTaskModel>? _tasks;

  TaskPaginator(
      {int? totalSize,
      String? limit,
      String? offset,
      List<PinPointsTaskModel>? tasks}) {
    this._totalSize = totalSize;
    this._limit = limit;
    this._offset = offset;
    this._tasks = tasks;
  }

  int? get totalSize => _totalSize;
  String? get limit => _limit;
  String? get offset => _offset;
  List<PinPointsTaskModel>? get tasks => _tasks;

  TaskPaginator.fromJson(Map<String?, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'].toString();
    _offset = json['offset'];

    if (json['tasks'] != null) {
      _tasks = [];
      json['tasks'].forEach((v) {
        _tasks!.add(PinPointsTaskModel.fromJson(v));
      });
    }
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;

    return data;
  }
}
