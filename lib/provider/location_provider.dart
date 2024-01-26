import 'dart:async';
import 'dart:convert';
import 'package:alphawash/data/model/response/admin_task_model.dart';
import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/data/model/response/base/api_response.dart';
import 'package:alphawash/data/model/response/response_model.dart';
import 'package:alphawash/data/model/response/user_area_model.dart';
import 'package:alphawash/data/model/response/waypoint_model.dart';
import 'package:alphawash/data/repository/location_repo.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:alphawash/view/base/border_button.dart';
import 'package:alphawash/view/screens/users/admin_tasks/admin_add_task_screen.dart';
import 'package:alphawash/view/screens/waypoints/pinpoint_info_bottom_sheet.dart';
import 'package:alphawash/view/screens/waypoints/waypoints_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../data/model/response/pin_point_model.dart';
import '../data/model/response/user_info_model.dart';

class LocationProvider with ChangeNotifier {
  final SharedPreferences? sharedPreferences;
  final LocationRepo? locationRepo;

  LocationProvider({@required this.sharedPreferences, this.locationRepo}) {
    _workerLocations =
        FirebaseFirestore.instance.collection('worker_locations_tracking');
  }
  bool _loading = false;
  bool get loading => _loading;

  Position _position = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
      altitudeAccuracy: 1,
      headingAccuracy: 1);

  Position? get position => _position;

  Placemark _address = Placemark();

  Placemark? get address => _address;

  double? _currentLatitude;

  double? get currentLatitude => _currentLatitude;

  double? _currentLongitude;

  double? get currentLongitude => _currentLongitude;

  GoogleMapController? _googleMapController;

  GoogleMapController? get googleMapController => _googleMapController;

  String? _searchedLocation;

  String? get searchedLocation => _searchedLocation;

  bool _hasSearchedLocation = false;

  bool get hasSearchedLocation => _hasSearchedLocation;

  String? _currentAddress;

  String? get currentAddress => _currentAddress;

  List<LatLng>? _coordinateList;

  List<LatLng>? get coordinateList => _coordinateList;

  double _latitude = 0.0;

  double get latitude => _latitude;

  double _longitude = 0.0;

  double get longitude => _longitude;

  String? _locality;

  String? get locality => _locality;

  String? _administrativeArea;

  String? get administrativeArea => _administrativeArea;

  String? _postalCode;

  String? get postalCode => _postalCode;

  String? _addressName;

  String? get addressName => _addressName;

  String? _sessionToken;

  String? get sessionToken => _sessionToken;

  List<dynamic> _placeList = [];

  List<dynamic> get placeList => _placeList;

  /// MARKERS
  Marker? _origin;

  Marker? get origin => _origin;

  Marker? _destination;

  Marker? get destination => _destination;

  ///END DIRECTIONS

  bool _mapVisible = true;

  bool get mapVisible => _mapVisible;

  List<int> _userAreasIds = [];

  List<int> get userAreasIds => _userAreasIds;

  var box = Hive.box('myBox');
  UserInfoModel? _selectUser;

  UserInfoModel? get selectWorker => _selectUser;
  AreaModel? _searchedArea;

  AreaModel? get searchedArea => _searchedArea;
  PinPointModel? _putPinpoint;

  PinPointModel? get putPinpoint => _putPinpoint;

  List<LatLng> _tappedPoints = [];
  List<LatLng> get tappedPoints => _tappedPoints;

  bool _satelliteMode = false;
  bool get satelliteMode => _satelliteMode;

  bool _areaChanged = false;
  bool get areaChanged => _areaChanged;



  void setSatelliteMode() {
    _satelliteMode == false ? _satelliteMode = true : _satelliteMode = false;
    notifyListeners();
  }

  void resetTapped() {
    _tappedPoints = [];
    notifyListeners();
  }

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  void resetWaypointInfo() {
    _markers = {};
    _searchedArea = null;
    notifyListeners();
  }

  // void addMarkerOnly(BuildContext context, LatLng location) {
  //   _tappedPoints.add(location);
  //   print('tappedPoints=> ${_tappedPoints}');
  //   final markerId = MarkerId(location.toString());
  //   final newMarker = Marker(
  //       markerId: markerId,
  //       position: location,
  //       infoWindow: InfoWindow(title: ''),
  //       icon: BitmapDescriptor.defaultMarker);
  //   _markers.add(newMarker);
  //   notifyListeners();
  // }

  void addMarker(BuildContext context, LatLng location, bool updateMode, [PinPointModel? pinpoint]) {
    MarkerId markerId = pinpoint!=null? MarkerId(pinpoint.id.toString()): MarkerId(location.toString());
    final newMarker = Marker(
        markerId: markerId,
        position: location,
        infoWindow: InfoWindow(title: ''),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          print(_tappedPoints);
          if(updateMode == false){
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Are you sure?',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 15)),
                  content: const Text('Do you want to remove this pin?',
                      style: TextStyle(fontSize: 13)),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BorderButton(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            btnTxt: 'No',
                            borderColor: Colors.black26,
                          ),
                          const SizedBox(width: 10),
                          BorderButton(
                            onTap: () {
                              _markers.removeWhere(
                                      (marker) => marker.markerId == markerId);
                              notifyListeners();
                              Navigator.pop(context);
                            },
                            btnTxt: 'Yes',
                            borderColor: Colors.black26,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          }else{
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (con) {

                return PinpointInfoBottomSheet(
                  pinPointModel: pinpoint!,

                );
              },
            );
          }

        });

    _markers.add(newMarker);
    notifyListeners();
  }

  void removeMarker(String id){
    MarkerId markerId = MarkerId(id.toString());

    _markers.removeWhere(
            (marker) => marker.markerId == markerId);
    notifyListeners();
  }

  // Future<void> initAddPinPoints(
  //     BuildContext context, WaypointModel waypoint) async {
  //   // for edit waypoint screen
  //   _markers = {};
  //   waypoint.pinPoints!.forEach((element) {
  //     addMarkerOnly(
  //         context,
  //         LatLng(double.parse(element.latitude!),
  //             double.parse(element.longitude!)));
  //   });
  //   notifyListeners();
  // }

  Future<void> initPinPoints(
      BuildContext context, WaypointModel waypoint, bool updateMode) async {
    // for edit waypoint screen
    _markers = {};
    waypoint.pinPoints!.forEach((pinPoint) {
      addMarker(
          context,
          LatLng(double.parse(pinPoint.latitude!),
              double.parse(pinPoint.longitude!)),
      updateMode,
          pinPoint
      );
    });
    notifyListeners();
  }

  Future<void> initNewPinPoints(
      BuildContext context, bool updateMode) async {
    // for edit waypoint screen

    Set<Marker> _oldMarkers = _markers;
    _markers = {};
    _oldMarkers.forEach((marker) {
      addMarker(
          context,
          LatLng(marker.position.latitude,
              marker.position.longitude),
          updateMode,
      );
    });
    notifyListeners();
  }


  void deleteMarkerOnly(BuildContext context, MarkerId markerId) {
    _markers.removeWhere((marker) => marker.markerId == markerId);
    notifyListeners();
  }

  void addMarkerOnly(BuildContext context, LatLng location) {
    //_tappedPoints = [];
    _tappedPoints.add(location);
    print('tappedPoints=> ${_tappedPoints}');
    final markerId = MarkerId(location.toString());
    final newMarker = Marker(
      markerId: markerId,
      position: location,
      infoWindow: InfoWindow(title: ''),
      icon: BitmapDescriptor.defaultMarker,
    );

    _markers.add(newMarker);
    notifyListeners();
  }

  // void addMarkerTest(BuildContext context, LatLng location) {
  //   // //_tappedPoints = [];
  //   // _tappedPoints.add(location);
  //   // print('tappedPoints=> ${_tappedPoints}');
  //
  //   final markerId = MarkerId(location.toString());
  //   final newMarker = Marker(
  //       markerId: markerId,
  //       position: location,
  //       infoWindow: InfoWindow(title: ''),
  //       icon: BitmapDescriptor.defaultMarker,
  //       onTap: () {
  //         // print(_tappedPoints);print(putPinpoint!.id);
  //         showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: Text('Are you sure?',
  //                   style: TextStyle(
  //                       color: Theme.of(context).primaryColor, fontSize: 15)),
  //               content: const Text('Do you want to remove this pin?',
  //                   style: TextStyle(fontSize: 13)),
  //               actions: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(bottom: 10),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       BorderButton(
  //                         onTap: () {
  //                           Navigator.pop(context);
  //                         },
  //                         btnTxt: 'No',
  //                         borderColor: Colors.black26,
  //                       ),
  //                       const SizedBox(width: 2),
  //                       BorderButton(
  //                         onTap: () {
  //                           Navigator.pop(context);
  //                         },
  //                         btnTxt: 'No',
  //                         borderColor: Colors.black26,
  //                       ),
  //                       const SizedBox(width: 2),
  //                       BorderButton(
  //                         onTap: () {
  //                           Navigator.pop(context);
  //                         },
  //                         btnTxt: 'Yes',
  //                         borderColor: Colors.black26,
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             );
  //           },
  //         );
  //       });
  //
  //   _markers.add(newMarker);
  //   notifyListeners();
  // }

  void setMapVisibility(bool value) {
    _mapVisible = value;
    notifyListeners();
  }

  void setSearchedArea(AreaModel area) {
    _searchedArea = area;
    notifyListeners();
  }


  void updateUserAreasIds(int value) {
    if (_userAreasIds.contains(value)) {
      _userAreasIds.remove(value);
    } else {
      _userAreasIds.add(value);
    }
    notifyListeners();
  }

  Future<void> getCurrentLocation2() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _currentLatitude = position.latitude;
    _currentLongitude = position.longitude;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
      _address = placemarks.first;
      _currentAddress =
          '${_address.name} ${_address.administrativeArea} ${_address.locality}';
      notifyListeners();
    } catch (e) {
      _currentAddress = 'Address details not clear';
      notifyListeners();
    }

    print(
        'current latLng=> lat: ${_currentLatitude} --  lng: ${_currentLongitude}');
    notifyListeners();
  }

  Future<void> updateCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _currentLatitude = position.latitude;
    _currentLongitude = position.longitude;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
      _address = placemarks.first;
      _currentAddress =
          '${_address.name} ${_address.administrativeArea} ${_address.locality}';
      notifyListeners();
    } catch (e) {
      _currentAddress = 'Address details not clear';
      notifyListeners();
    }

    print(
        'current latLng=> lat: ${_currentLatitude} --  lng: ${_currentLongitude}');
    notifyListeners();
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = AppConstants.API_KEY;

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken&components=country:co';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      _placeList = json.decode(response.body)['predictions'];
      print('_placeList');
      print(_placeList);
    } else {
      throw Exception('Failed to load predictions');
    }
    notifyListeners();
  }

  void dragableAddress() async {
    try {
      _loading = true;
      notifyListeners();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
      _address = placemarks.first;
      _loading = false;
      _hasSearchedLocation = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      notifyListeners();
    }
  }

  // update Position
  void updatePosition(CameraPosition position) async {
    _position = Position(
        latitude: position.target.latitude,
        longitude: position.target.longitude,
        timestamp: DateTime.now(),
        heading: 1,
        accuracy: 1,
        altitude: 1,
        speedAccuracy: 1,
        speed: 1,
        altitudeAccuracy: 1,
        headingAccuracy: 1);
  }

  // for get current location
  void getCurrentLocation({GoogleMapController? mapController}) async {
    // print('get location');
    _loading = true;
    notifyListeners();

    Position newLocalData = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _position = newLocalData;
    _currentLatitude = position!.latitude;
    _currentLongitude = position!.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(
        newLocalData.latitude, newLocalData.longitude);
    _address = placemarks.first;
    //print('get location 2 ${_address}');

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(newLocalData.latitude, newLocalData.longitude),
          zoom: 17)));
    }
    try {} on PlatformException catch (e) {
      print("Permission Denied");
      if (e.code == 'PERMISSION_DENIED') {
        print("Permission Denied");
      }
    }
    _loading = false;
    notifyListeners();
  }

  updateSearchLocation(BuildContext context, String location, double latitude,
      double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    _address = placemarks.first;
    _searchedLocation = location;
    _latitude = latitude;
    _longitude = longitude;
    _addressName = location;
    _hasSearchedLocation = true;
    print('address name=> ${_address.name}');
    notifyListeners();
  }

  void getSearchedLocation({GoogleMapController? mapController}) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(_latitude, _longitude);

    _address = placemarks.first;

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(_latitude, _longitude), zoom: 11)));
    }

    // try {
    //
    // } on PlatformException catch (e) {
    //   print("Permission Denied");
    //   if (e.code == 'PERMISSION_DENIED') {
    //     print("Permission Denied");
    //   }
    // }
    notifyListeners();
  }

  void getWaypointLocation(
      {GoogleMapController? mapController,
      double? latitude,
      double? longitude}) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude!, longitude!);

    _address = placemarks.first;

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 17)));
    }

    notifyListeners();
  }

  void getSavedLocation(GoogleMapController? mapController, double latitude,
      double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    _address = placemarks.first;

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 11)));
    }

    notifyListeners();
  }

  void setController(GoogleMapController controller) {
    _googleMapController = controller;
    notifyListeners();
  }

  void setOriginMarker(LatLng pos) {
    _origin = Marker(
      markerId: const MarkerId('origin'),
      infoWindow: const InfoWindow(title: 'My Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: pos,
    );
    notifyListeners();
  }

  void addCoordinate(LatLng coordinate, String address) {
    _coordinateList!.add(coordinate);
    notifyListeners();
  }

  // void getSavedLocation({GoogleMapController? mapController}) async {
  //   _loading = true;
  //   notifyListeners();
  //   try {
  //     double _latitude = box.get('latitude');
  //     double _longitude = box.get('longitude');
  //
  //     if (mapController != null) {
  //       mapController.animateCamera(CameraUpdate.newCameraPosition(
  //           CameraPosition(target: LatLng(_latitude, _longitude), zoom: 17)));
  //       // _position = newLocalData;
  //
  //       List<Placemark> placemarks = await placemarkFromCoordinates(_latitude, _longitude);
  //       _address = placemarks.first;
  //     }
  //   } on PlatformException catch (e) {
  //     if (e.code == 'PERMISSION_DENIED') {
  //       debugPrint("Permission Denied");
  //     }
  //   }
  //   _loading = false;
  //   notifyListeners();
  // }

  bool _storeAreaLoading = false;

  bool get storeAreaLoading => _storeAreaLoading;

  bool _areasListLoading = false;

  bool get areasListLoading => _areasListLoading;

  List<AreaModel>? _areasList;

  List<AreaModel>? get areasList => _areasList;

  List<UserAreaModel>? _workerAreasList;

  List<UserAreaModel>? get workerAreasList => _workerAreasList;

  AreaModel? _selectedArea;

  AreaModel? get selectedArea => _selectedArea;

  String? _areaName;

  String? get areaName => _areaName;

  bool _userAreasLoading = false;

  bool get userAreasLoading => _userAreasLoading;

  Future<ResponseModel> storeNewArea(String name, String description,
      String latitude, String longitude) async {
    _storeAreaLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await locationRepo!
        .storeNewArea(name, description, latitude, longitude);
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
    _storeAreaLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateArea(int areaId, String name, String description,
      String latitude, String longitude) async {
    _storeAreaLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await locationRepo!
        .updateArea(areaId, name, description, latitude, longitude);
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
    _storeAreaLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> removeArea(int areaId) async {
    _storeAreaLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await locationRepo!.removeArea(areaId);
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
    _storeAreaLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> getAreasList(BuildContext context) async {
    if(_areasList == null){
      _areasListLoading = true;
    }
    _areaChanged = true;
    notifyListeners();
    ApiResponse apiResponse = await locationRepo!.getAreasList();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _areasListLoading = false;
      _areasList = [];
      apiResponse.response!.data.forEach((item) {
        _areasList!.add(AreaModel.fromJson(item));
      });
    } else {
      _areasListLoading = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
    notifyListeners();
  }

  void resetSearch() {
    _searchedLocation = null;
    notifyListeners();
  }

  void setSelectedArea(AreaModel area) {
    _selectedArea = area;
    notifyListeners();
  }

  void setAreaName(String name) {
    _areaName = name;
    notifyListeners();
  }

  Future<ResponseModel> updateUserAreas(List<int> areaIds, int userId) async {
    _userAreasLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await locationRepo!.updateUserAreas(areaIds, userId);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _userAreasLoading = false;
      notifyListeners();
      responseModel = ResponseModel(true, 'successful');
    } else {
      _userAreasLoading = false;
      notifyListeners();
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _userAreasLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> getWorkerAreasList(BuildContext context, int userId) async {
    _userAreasLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await locationRepo!.getWorkerAreasList(userId);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _userAreasLoading = false;
      _workerAreasList = [];
      _userAreasIds = [];
      apiResponse.response!.data.forEach((item) {
        UserAreaModel _area = UserAreaModel.fromJson(item);
        _userAreasIds.add(_area.areaId!);
        _workerAreasList!.add(_area);
      });
    } else {
      _userAreasLoading = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }

    notifyListeners();
  }

  /// waypoints
  List<WaypointModel> _waypoints = [];
  List<WaypointModel> get waypoints => _waypoints;


  bool _waypointsListLoading = false;
  bool get waypointsListLoading => _waypointsListLoading;

  Future<void> getWaypointsList(BuildContext context) async {
    _waypointsListLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await locationRepo!.getWayPointsList();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _waypointsListLoading = false;
      notifyListeners();
      _waypoints = [];
      apiResponse.response!.data.forEach((item) {
        WaypointModel wayPoint = WaypointModel.fromJson(item);
        _waypoints.add(wayPoint);
      });
    } else {
      _waypointsListLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }

    notifyListeners();
  }

  List<WorkerWaypointModel> _workerWaypoints = [];

  List<WorkerWaypointModel> get workerWaypoints => _workerWaypoints;
  bool _workerWaypointsListLoading = false;

  bool get workerWaypointsListLoading => _workerWaypointsListLoading;

  Future<void> getWorkerWaypointsList(BuildContext context) async {
    _workerWaypointsListLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await locationRepo!.getWorkerWayPointsList();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _workerWaypointsListLoading = false;
      notifyListeners();
      _workerWaypoints = [];
      apiResponse.response!.data.forEach((item) {
        WorkerWaypointModel workerWayPoint = WorkerWaypointModel.fromJson(item);
        _workerWaypoints.add(workerWayPoint);
      });
    } else {
      _workerWaypointsListLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
    notifyListeners();
  }

  bool _storeWaypointLoading = false;

  bool get storeWaypointLoading => _storeWaypointLoading;
  bool _deleteWaypointLoading = false;

  bool get deleteWaypointLoading => _deleteWaypointLoading;
  Future<ResponseModel> storeWayPointInfo(WaypointModel waypoint) async {
    _storeWaypointLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await locationRepo!.storeWayPointInfo(waypoint);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _storeWaypointLoading = false;
      notifyListeners();
      responseModel = ResponseModel(true, 'successful');
    } else {
      _storeWaypointLoading = false;
      notifyListeners();
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _storeWaypointLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateWayPointInfo(WaypointModel waypoint) async {
    _storeWaypointLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await locationRepo!.updateWayPointInfo(waypoint);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _storeWaypointLoading = false;
      notifyListeners();
      responseModel = ResponseModel(true, 'successful');
    } else {
      _storeWaypointLoading = false;
      notifyListeners();
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _storeWaypointLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> deleteWayPointInfo(int waypointId) async {
    _deleteWaypointLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await locationRepo!.deleteWayPointInfo(waypointId);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _deleteWaypointLoading = false;
      notifyListeners();
      responseModel = ResponseModel(true, 'successful');
    } else {
      _deleteWaypointLoading = false;
      notifyListeners();
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _deleteWaypointLoading = false;
    notifyListeners();
    return responseModel;
  }

  bool _storeTaskLoading = false;

  bool get storeTaskLoading => _storeTaskLoading;
  bool _getTaskLoading = false;

  bool get getTaskLoading => _getTaskLoading;

  List<AdminTaskModel> _task = [];

  List<AdminTaskModel> get task => _task;

  Future<ResponseModel> storeTask(int workerId, int waypointId,
      DateTime taskDate, String taskDetails) async {
    _storeTaskLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await locationRepo!
        .storeTaskInfo(workerId, waypointId, taskDate, taskDetails);

    ResponseModel responseModel;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _storeTaskLoading = false;
      notifyListeners();
      responseModel = ResponseModel(true, 'successful');
    } else {
      _storeTaskLoading = false;
      notifyListeners();
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }

    _storeTaskLoading = false;
    notifyListeners();

    return responseModel;
  }

  bool _tasksListIsLoading = false;

  bool get tasksListIsLoading => _tasksListIsLoading;

  bool _bottomTasksListLoading = false;

  bool get bottomTasksListLoading => _bottomTasksListLoading;

  List<AdminTaskModel>? _tasksList;

  List<AdminTaskModel>? get tasksList => _tasksList;

  String? _tasksOffset;

  String? get tasksOffset => _tasksOffset;

  int? _totalTasksSize;

  int? get totalTasksSize => _totalTasksSize;

  List<String> _tasksOffsetList = [];

  void getTasksList(BuildContext? context, String offset) async {
    if (offset == '1') {
      _tasksListIsLoading = true;
    }

    if (!_tasksOffsetList.contains(offset)) {
      _tasksOffsetList.add(offset);
      ApiResponse apiResponse = await locationRepo!.getTasksList(offset);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _bottomTasksListLoading = false;
        if (offset == '1') {
          _tasksList = [];
        }
        _totalTasksSize =
            TaskPaginator.fromJson(apiResponse.response!.data).totalSize;
        _tasksList!
            .addAll(TaskPaginator.fromJson(apiResponse.response!.data).tasks!);
        _tasksOffset =
            TaskPaginator.fromJson(apiResponse.response!.data).offset;
        _tasksListIsLoading = false;
      } else {
        _bottomTasksListLoading = false;
        _tasksListIsLoading = false;
        ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      if (_tasksListIsLoading) {
        _bottomTasksListLoading = false;
        _tasksListIsLoading = false;
      }
    }
    notifyListeners();
  }

  void showBottomTasksLoader() {
    _bottomTasksListLoading = true;
    notifyListeners();
  }

  void clearOffset() {
    _tasksOffsetList.clear();
    _tasksList = [];
    notifyListeners();
  }

  int _selectedWaypointId = -1;

  int get selectedWaypointId => _selectedWaypointId;

  String get selectedWaypointName {
    WaypointModel? selectedWaypoint;
    for (var waypoint in waypoints) {
      if (waypoint.id == selectedWaypointId) {
        selectedWaypoint = waypoint;
        break;
      }
    }
    return selectedWaypoint?.name ?? '';
  }

  void setSelectedWaypointId(int id) {
    _selectedWaypointId = id;
    notifyListeners();
  }
// live tracking location :
//
//
// final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
// ///send message
// Future<void> sendMessage(String receiverId, String message) async {
//   final String currentUserId = _firebaseAuth.currentUser!.uid;
//   final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
//   final Timestamp timestamp = Timestamp.now();
//   LiveLocationModel newMessage = LiveLocationModel(
//       senderId: currentUserId,
//       senderEmail: currentUserEmail,
//       receiverId: receiverId,
//       message: message,
//       timestamp: timestamp);
//   List<String> ids = [currentUserId, receiverId];
//   ids.sort();
//   String chatRoomId = ids.join("_");
//   await _firestore
//       .collection('live_location')
//       .doc(chatRoomId)
//       .collection('messages')
//       .add(newMessage.toMap());
// }
//
// ///get message
// Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
//   List<String> ids = [userId, otherUserId];
//   ids.sort();
//   String chatRoomId = ids.join("_");
//   return _firestore
//       .collection('live_location')
//       .doc(chatRoomId)
//       .collection('messages')
//       .orderBy('timestamp', descending: false)
//       .snapshots();
// }

//   late LatLng _workerLocation;
//
//   // LiveLocationProvider() {
//   //   _workerLocation = LatLng(0, 0);
//   //   _startLocationUpdate();
//   // }
//
//   LatLng get workerLocation => _workerLocation;
//
//   set workerLocation(LatLng location) {
//     _workerLocation = location;
//     notifyListeners();
//   }
//
//   _startLocationUpdate() {
//     Timer.periodic(Duration(seconds: 10), (timer) {
//       // Simulate new location data (replace with your actual logic to get the updated location)
//       double newLat = _workerLocation.latitude + 0.001;
//       double newLng = _workerLocation.longitude + 0.001;
//       LatLng newLatLng = LatLng(newLat, newLng);
//
//       workerLocation = newLatLng;
//
//       print('Worker Latitude: $newLat, Longitude: $newLng');
//     });
//   }
// }

  String _selectedDay = 'Select the day';
  String get selectedDay => _selectedDay;

  void updateSelectedDay(String day) {
    _selectedDay = day;
    notifyListeners();
  }

  void updateAreaChangedValue(bool value) {
    _areaChanged = value;
    _selectedDay = 'Select the day';
    notifyListeners();
  }


  late StreamSubscription<Position> _positionStreamSubscription;
  CollectionReference<Map<String, dynamic>>? _workerLocations;

  void startLocationUpdate(String userId, String userName) {
    _positionStreamSubscription = Geolocator.getPositionStream().listen(
      (Position position) {
        _updateOnFirestore(
          userId,
          userName,
          position.latitude,
          position.longitude,
        );
      },
    );
  }

  void _updateOnFirestore(
    String userId,
    String userName,
    double latitude,
    double longitude,
  ) {
    _workerLocations?.doc(userId).set({
      'name': userName,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      print('--------------------------------------');

      print('Worker location updated in Firestore');
      print('--------------------------------------');
    }).catchError((error) {
      print('--------------------------------------');

      print('Error updating worker location: $error');
      print('--------------------------------------');
    });
  }

  void dispose() {
    _positionStreamSubscription.cancel();
  }



  bool _showFilteredWaypoints = false;
  bool get showFilteredWaypoints => _showFilteredWaypoints;

  void changeFilteredWaypoints(bool value) {
    _showFilteredWaypoints = value;
    notifyListeners();
  }
}
