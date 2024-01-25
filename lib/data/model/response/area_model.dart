
class AreaModel {
  int? _id;
  String? _name;
  String? _description;
  String? _latitude;
  String? _longitude;

  AreaModel({
    int? id,
    String? name,
    String? description,
    String? latitude,
    String? longitude,
  }) {
    this._id = id;
    this._name = name;
    this._description = description;
    this._latitude = latitude;
    this._longitude = longitude;
  }

  int? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get latitude => _latitude;
  String? get longitude => _longitude;

  AreaModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': _id,
      'name': _name,
      'description': _description,
      'latitude': _latitude,
      'longitude': _longitude,
    };
    return data;
  }
}
