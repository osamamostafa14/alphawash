import 'package:alphawash/data/model/response/pin_point_model.dart';
import 'package:alphawash/data/model/response/waypoint_model.dart';

// class WorkerTaskModel {
//   int? _id;
//   int? _workerId;
//   int? _waypointId;
//   String? _taskDetails;
//   String? _status;
//   DateTime? _taskDate;
//   List<PinPointModel>? _pinPoints;
//   WaypointModel? _wayPoint;
//   String? _createdAt;
//   String? _updatedAt;
//
//   WorkerTaskModel({
//     int? id,
//     int? workerId,
//     int? waypointId,
//     String? taskDetails,
//     String? status,
//     DateTime? taskDate,
//     List<PinPointModel>? pinPoints,
//     WaypointModel? wayPoint,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     this._id = id;
//     this._workerId = workerId;
//     this._waypointId = waypointId;
//     this._taskDetails = taskDetails;
//     this._status = status;
//     this._taskDate = taskDate;
//     this._pinPoints = pinPoints;
//     this._wayPoint = wayPoint;
//     this._createdAt = createdAt;
//     this._updatedAt = updatedAt;
//   }
//
//   int? get id => _id;
//   int? get workerId => _workerId;
//   int? get waypointId => _waypointId;
//   String? get taskDetails => _taskDetails;
//   String? get status => _status;
//   DateTime? get taskDate => _taskDate;
//   List<PinPointModel>? get pinPoints => _pinPoints;
//   WaypointModel? get wayPoint => _wayPoint;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//
//   WorkerTaskModel.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _waypointId = json['waypoint_id'];
//     _workerId = json['area_id'];
//     _taskDetails = json['task_details'];
//     _status = json['status'];
//
//     _taskDate = DateTime.tryParse(json['task_date'] ?? '');
//
//     if (json['pin_points'] != null) {
//       _pinPoints = [];
//       json['pin_points'].forEach((v) {
//         _pinPoints!.add(PinPointModel.fromJson(v));
//       });
//     }
//
//     _wayPoint = json['waypoint'] != null
//         ? WaypointModel.fromJson(json['waypoint'])
//         : null;
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {
//       'id': _id,
//       'worker_id': _workerId,
//       'waypoint_id': _waypointId,
//       'waypoint': _wayPoint != null ? _wayPoint!.toJson() : null,
//       'pin_points': _pinPoints != null
//           ? _pinPoints!.map((item) => item.toJson()).toList()
//           : null,
//       'created_at': _createdAt,
//       'updated_at': _updatedAt,
//       'task_details': _taskDetails,
//       'task_date': _taskDate?.toIso8601String(),
//     };
//     return data;
//   }
// }

class ReminderModel {
  int? _id;
  int? _userId;
  int? _pinpointId;
  int? _isWeeklyTask;
  String? _details;
  String? _dayOfTask;
  ReminderModel({
    int? id,
    int? userId,
    int? pinpointId,
    int? isWeeklyTask,
    String? details,
    String? dayOfTask,
  }) {
    this._id = id;
    this._userId = userId;
    this._pinpointId = pinpointId;
    this._isWeeklyTask = isWeeklyTask;
    this._details = details;
    this._dayOfTask = dayOfTask;
  }

  int? get id => _id;
  int? get userId => _userId;
  int? get pinpointId => _pinpointId;
  int? get isWeeklyTask => _isWeeklyTask;
  String? get details => _details;
  String? get dayOfTask => _dayOfTask;

  ReminderModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _pinpointId = json['pinpoint_id'];
    _isWeeklyTask = json['is_weekly_task'];
    _details = json['details'];
    _dayOfTask = json['day_of_task'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': _id,
      'user_id':_userId,
      'pinpoint_id':_pinpointId,
      'is_weekly_task':_isWeeklyTask,
      'details':_details,
      'day_of_task':_dayOfTask ,
    };
    return data;
  }
}
