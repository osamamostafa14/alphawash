import 'package:alphawash/data/model/response/pin_point_model.dart';

class TaskUpdatePaginator {
  int? _totalSize;
  int? _newTasksCount;
  int? _updatedTasksCount;
  int? _totalPinpointTasks;
  String? _limit;
  String? _offset;
  List<TaskUpdateModel>? _taskUpdates;
  List<PinPointsTaskModel>? _tasksWithoutUpdates;

  TaskUpdatePaginator(
      {
        int? totalSize,
        int? newTasksCount,
        int? updatedTasksCount,
        int? totalPinpointTasks,
        String? limit,
        String? offset,
        List<TaskUpdateModel>? taskUpdates,
        List<PinPointsTaskModel>? tasksWithoutUpdates,
      }) {
    this._totalSize = totalSize;
    this._newTasksCount = newTasksCount;
    this._updatedTasksCount = updatedTasksCount;
    this._totalPinpointTasks = totalPinpointTasks;
    this._limit = limit;
    this._offset = offset;
    this._taskUpdates = taskUpdates;
    this._tasksWithoutUpdates = tasksWithoutUpdates;
  }

  int? get totalSize => _totalSize;
  int? get newTasksCount => _newTasksCount;
  int? get updatedTasksCount => _updatedTasksCount;
  int? get totalPinpointTasks => _totalPinpointTasks;
  String? get limit => _limit;
  String? get offset => _offset;
  List<TaskUpdateModel>? get taskUpdates => _taskUpdates;
  List<PinPointsTaskModel>? get tasksWithoutUpdates => _tasksWithoutUpdates;

  TaskUpdatePaginator.fromJson(Map<String?, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'].toString();
    _newTasksCount = json['new_tasks_count'];
    _updatedTasksCount = json['updated_tasks_count'];
    _totalPinpointTasks = json['pinpoint_tasks_count'];
    _offset = json['offset'];

    if (json['task_updates'] != null) {
      _taskUpdates = [];
      json['task_updates'].forEach((v) {
        _taskUpdates!.add(TaskUpdateModel.fromJson(v));
      });
    }

    if (json['tasks_without_updates'] != null) {
      _tasksWithoutUpdates = [];
      json['tasks_without_updates'].forEach((v) {
        _tasksWithoutUpdates!.add(PinPointsTaskModel.fromJson(v));
      });
    }
  }

}

class TaskUpdateModel {
  int? _id;
  int? _pinPointTaskId;
  String? _type;
  int? _workerId;
  String? _createdAt;
  String? _updatedAt;
  PinPointsTaskModel? _pinpointTask;

  TaskUpdateModel({
    int? id,
    int? pinPointTaskId,
    String? type,
    int? workerId,
    String? createdAt,
    String? updatedAt,
    PinPointsTaskModel? pinpointTask,
  }) {
    this._id = id;
    this._pinPointTaskId = pinPointTaskId;
    this._type = type;
    this._workerId = workerId;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._pinpointTask = pinpointTask;
  }

  int? get id => _id;
  int? get pinPointTaskId => _pinPointTaskId;
  String? get type => _type;
  int? get workerId => _workerId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  PinPointsTaskModel? get pinpointTask => _pinpointTask;

  TaskUpdateModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _pinPointTaskId = json['pin_point_task_id'];
    _type = json['type'];
    _workerId = json['worker_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _pinpointTask = json['pinpoint_task'] != null ? PinPointsTaskModel.fromJson(json['pinpoint_task']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': _id,
      'pin_point_task_id': _pinPointTaskId,
      'type': _type,
      'worker_id': _workerId,
      'created_at': _createdAt,
      'updated_at': _updatedAt,
      'pinpoint_task': _pinpointTask?.toJson(),
    };
    return data;
  }
}
