import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/data/model/response/pin_point_model.dart';

class WaypointModel {
  int? _id;
  int? _areaId;
  AreaModel? _area;
  String? _name;
  List<PinPointModel>? _pinPoints;
  String? _createdAt;
  String? _updatedAt;
  String? _day;

  WaypointModel({
    int? id,
    int? areaId,
    AreaModel? area,
    String? name,
    List<PinPointModel>? pinPoints,
    String? createdAt,
    String? updatedAt,
    String? day,
  }) {
    this._id = id;
    this._areaId = areaId;
    this._area = area;
    this._day = day;
    this._name = name;
    this._pinPoints = pinPoints;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get areaId => _areaId;
  AreaModel? get area => _area;
  String? get name => _name;
  List<PinPointModel>? get pinPoints => _pinPoints;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get day => _day;

  WaypointModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _areaId = json['area_id'];
    _area = json['area'] != null ? AreaModel.fromJson(json['area']) : null;
    _name = json['name'];

    if (json['pin_points'] != null) {
      _pinPoints = [];
      json['pin_points'].forEach((v) {
        _pinPoints!.add(PinPointModel.fromJson(v));
      });
    }

    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _day = json['day_of_task'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': _id,
      'area_id': _areaId,
      'area': _area != null ? _area!.toJson() : null,
      'name': _name,
      'pin_points': _pinPoints != null
          ? _pinPoints!.map((item) => item.toJson()).toList()
          : null,
      'created_at': _createdAt,
      'updated_at': _updatedAt,
      'day_of_task': _day,
    };
    return data;
  }
}

class WorkerWaypointModel {
  int? _id;
  int? _areaId;
  List<PinPointModel>? _pinPoints;
  String? _createdAt;
  String? _updatedAt;
  int? _userId;
  WaypointModel? _wayPoint;

  WorkerWaypointModel({
    int? id,
    int? userId,
    int? areaId,
    List<PinPointModel>? pinPoints,
    WaypointModel? wayPoint,
    String? createdAt,
    String? updatedAt,
  }) {
    this._id = id;
    this._userId = userId;
    this._areaId = areaId;
    this._pinPoints = pinPoints;
    this._wayPoint = wayPoint;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get userId => _userId;
  int? get areaId => _areaId;
  List<PinPointModel>? get pinPoints => _pinPoints;
  WaypointModel? get wayPoint => _wayPoint;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  WorkerWaypointModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _areaId = json['area_id'];

    if (json['pin_points'] != null) {
      _pinPoints = [];
      json['pin_points'].forEach((v) {
        _pinPoints!.add(PinPointModel.fromJson(v));
      });
    }
    // if (json['waypoint'] != null) {
    //   _wayPoint = [];
    //   json['waypoint'].forEach((v) {
    //     _wayPoint!.add(WaypointModel.fromJson(v));
    //   });
    // }
    _wayPoint = json['waypoint'] != null
        ? WaypointModel.fromJson(json['waypoint'])
        : null;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': _id,
      'area_id': _areaId,
      'waypoint': _wayPoint != null ? _wayPoint!.toJson() : null,

      // 'waypoint': _wayPoint != null
      //     ? _wayPoint!.map((item) => item.toJson()).toList()
      //     : null,
      'pin_points': _pinPoints != null
          ? _pinPoints!.map((item) => item.toJson()).toList()
          : null,
      'created_at': _createdAt,
      'updated_at': _updatedAt,
    };
    return data;
  }
}
