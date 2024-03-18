import 'package:alphawash/data/model/response/user_area_model.dart';

class UserInfoModel {
  int? id;
  String? fullName;
  String? email;
  String? address;
  String? bio;
  String? image;
  int? isPhoneVerified;
  String? emailVerifiedAt;
  String? providerName;
  String? createdAt;
  String? updatedAt;
  String? emailVerificationToken;
  String? phone;
  String? cmFirebaseToken;
  int? updateVersion;
  int? status;
  String? userType;
  WorkerPermissionsModel? workerPermissions;
  List<UserAreaModel>? userAreas;
  List<UserWaypointModel>? userWaypoints;

  UserInfoModel({
    this.id,
    this.fullName,
    this.email,
    this.address,
    this.bio,
    this.image,
    this.isPhoneVerified,
    this.emailVerifiedAt,
    this.providerName,
    this.createdAt,
    this.updatedAt,
    this.emailVerificationToken,
    this.phone,
    this.cmFirebaseToken,
    this.updateVersion,
    this.status,
    this.userType,
    this.userAreas,
    this.userWaypoints,
    this.workerPermissions,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    address = json['address'];
    bio = json['bio'];
    image = json['image'];
    isPhoneVerified = json['is_phone_verified'];
    emailVerifiedAt = json['email_verified_at'];
    providerName = json['provider_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emailVerificationToken = json['email_verification_token'];
    phone = json['phone'];
    cmFirebaseToken = json['cm_firebase_token'];
    updateVersion = json['update_version'];
    status = json['status'];
    userType = json['user_type'];
    if (json['user_areas'] != null) {
      userAreas = [];
      json['user_areas'].forEach((v) {
        userAreas!.add(UserAreaModel.fromJson(v));
      });
    }
    workerPermissions = json['permissions'] != null
        ? WorkerPermissionsModel.fromJson(json['permissions'])
        : null;

    // if (json['permissions'] != null) {
    //   workerPermissions = [];
    //   json['permissions'].forEach((v) {
    //     workerPermissions!.add(WorkerPermissionsModel.fromJson(v));
    //   });
    // }
    if (json['user_waypoints'] != null) {
      userWaypoints = [];
      json['user_waypoints'].forEach((v) {
        userWaypoints!.add(UserWaypointModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'fullName': fullName,
      'email': email,
      'address': address,
      'bio': bio,
      'image': image,
      'is_phone_verified': isPhoneVerified,
      'email_verified_at': emailVerifiedAt,
      'provider_name': providerName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'email_verification_token': emailVerificationToken,
      'phone': phone,
      'cm_firebase_token': cmFirebaseToken,
      'update_version': updateVersion,
      'status': status,
      'user_type': userType,
      'permissions':
          workerPermissions != null ? workerPermissions!.toJson() : null,

      // 'permissions': workerPermissions,
    };
    return data;
  }
}

class UserWaypointModel {
  int? id;
  int? userId;
  int? waypointId;

  UserWaypointModel({
    this.id,
    this.userId,
    this.waypointId,
  });

  UserWaypointModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    waypointId = json['waypoint_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'user_id': userId,
      'waypoint_id': waypointId,
    };
    return data;
  }
}

class WorkerPermissionsModel {
  int? _id;
  int? _area;
  int? _waypoints;
  int? _addPinpoints;
  int? _showPinpoints;
  int? _editPinpoints;
  int? _tasks;

  WorkerPermissionsModel({
    int? id,
    int? area,
    int? waypoints,
    int? addPinpoints,
    int? showPinpoints,
    int? editPinpoints,
    int? tasks,
  }) {
    this._id = id;
    this._area = area;
    this._waypoints = waypoints;
    this._addPinpoints = addPinpoints;
    this._showPinpoints = showPinpoints;
    this._editPinpoints = editPinpoints;
    this._tasks = tasks;
  }

  int? get id => _id;

  int? get area => _area;
  int? get waypoints => _waypoints;
  int? get addPinpoints => _addPinpoints;
  int? get showPinpoints => _showPinpoints;
  int? get editPinpoints => _editPinpoints;
  int? get tasks => _tasks;

  set area(int? value) {
    _area = value;
  }

  set waypoints(int? value) {
    _waypoints = value;
  }

  set addPinpoints(int? value) {
    _addPinpoints = value;
  }

  set showPinpoints(int? value) {
    _showPinpoints = value;
  }

  set editPinpoints(int? value) {
    _editPinpoints = value;
  }

  set tasks(int? value) {
    _tasks = value;
  }

  WorkerPermissionsModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _area = json['areas'];
    _waypoints = json['waypoints'];
    _addPinpoints = json['add_pinpoint_task'];
    _showPinpoints = json['show_pinpoint_tasks'];
    _editPinpoints = json['edit_pinpoint_task'];
    _tasks = json['tasks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': _id,
      'areas': _area,
      'waypoints': _waypoints,
      'add_pinpoint_tasks': _addPinpoints,
      'show_pinpoint_tasks': _showPinpoints,
      'edit_pinpoint_tasks': _editPinpoints,
      'tasks': _tasks,
    };
    return data;
  }
}
