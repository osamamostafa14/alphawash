
import 'package:alphawash/data/model/response/area_model.dart';

class UserAreaModel {
  int? _id;
  int? _userId;
  int? _areaId;
  AreaModel? _area;
  String? _createdAt;
  String? _updatedAt;

  UserAreaModel({
    int? id,
    int? userId,
    int? areaId,
    AreaModel? area,
    String? createdAt,
    String? updatedAt,
  }) {
    this._id = id;
    this._userId = userId;
    this._areaId = areaId;
    this._area = area;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get userId => _userId;
  int? get areaId => _areaId;
  AreaModel? get area=> _area;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  UserAreaModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _areaId = json['area_id'];

    if (json['area'] != null) {
      _area = AreaModel.fromJson(json['area']);
    }

    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': _id,
      'user_id': _userId,
      'area_id': _areaId,
      'created_at': _createdAt,
      'updated_at': _updatedAt,
    };
    return data;
  }
}

