import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/data/model/response/user_info_model.dart';
import 'package:alphawash/data/model/response/waypoint_model.dart';

class PinPointModel {
  int? _id;
  int? _areaId;
  int? _wayPointId;
  String? _latitude;
  String? _longitude;
  AreaModel? _area;
  WaypointModel? _waypoint;
  PinPointsTaskModel? _lastTask;
  String? _description;
  String? _createdAt;
  String? _updatedAt;

  PinPointModel({
    int? id,
    int? areaId,
    int? wayPointId,
    String? latitude,
    String? longitude,
    AreaModel? area,
    WaypointModel? waypoint,
    PinPointsTaskModel? lastTask,
    String? description,
    String? createdAt,
    String? updatedAt,
  }) {
    this._id = id;
    this._areaId = areaId;
    this._wayPointId = wayPointId;
    this._latitude = latitude;
    this._longitude = longitude;
    this._area = area;
    this._waypoint = waypoint;
    this._description = description;
    this._lastTask = lastTask;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get areaId => _areaId;
  int? get wayPointId => _wayPointId;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  AreaModel? get area => _area;
  WaypointModel? get waypoint => _waypoint;
  PinPointsTaskModel? get lastTask => _lastTask;
  String? get description => _description;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  PinPointModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _areaId = json['area_id'];
    _wayPointId = json['waypoint_id'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _area = json['area'] != null ? AreaModel.fromJson(json['area']) : null;
    _waypoint = json['waypoint'] != null
        ? WaypointModel.fromJson(json['waypoint'])
        : null;
    _lastTask = json['last_task'] != null
        ? PinPointsTaskModel.fromJson(json['last_task'])
        : null;
    _description = json['description'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': _id,
      'area_id': _areaId,
      'waypoint_id': _wayPointId,
      'latitude': _latitude,
      'longitude': _longitude,
      'area': _area != null ? _area!.toJson() : null,
      'waypoint': _waypoint != null ? _waypoint!.toJson() : null,
      'last_task': _lastTask != null ? _lastTask!.toJson() : null,
      'description': _description,
      'created_at': _createdAt,
      'updated_at': _updatedAt,
    };
    return data;
  }
}

class PinPointsTaskModel {
  int? _id;
  String? _details;
  String? _image;
  int? _userId;
  int? _pinpointId;
  UserInfoModel?  _user;

  PinPointsTaskModel({
    int? id,
    String? details,
    String? image,
    int? userId,
    int? pinpointId,
    UserInfoModel? user,
  }) {
    this._id = id;
    this._details = details;
    this._image = image;
    this._userId = userId;
    this._pinpointId = pinpointId;
    this._user = user;
  }

  int? get id => _id;
  String? get details => _details;
  String? get image => _image;
  int? get userId => _userId;
  int? get pinpointId => _pinpointId;
  UserInfoModel? get user => _user;

  PinPointsTaskModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _details = json['details'];
    _image = json['image'];
    _userId = json['user_id'];
    _pinpointId = json['pinpoint_id'];
    _user = json['user'] != null ? UserInfoModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': _id,
      'details': _details,
      'image': _image,
      'user_id': _userId,
      'pinpoint_id': _pinpointId,
    };
    return data;
  }
}

