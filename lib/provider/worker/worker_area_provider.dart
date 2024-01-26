import 'package:alphawash/data/model/response/area_model.dart';
import 'package:alphawash/data/model/response/base/api_response.dart';
import 'package:alphawash/data/repository/worker/worker_area_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WorkerAreaProvider with ChangeNotifier {
  final WorkerAreaRepo? workerAreaRepo;
  WorkerAreaProvider({@required this.workerAreaRepo});

  bool _areasListLoading = false;
  bool get areasListLoading => _areasListLoading;

  List<AreaModel>? _areasList;
  List<AreaModel>? get areasList => _areasList;

  Future<void> getAreasList(BuildContext context) async {
    _areasListLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await workerAreaRepo!.getAreasList();

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _areasListLoading = false;
      _areasList = [];
      apiResponse.response!.data.forEach((item) {
        _areasList!.add(AreaModel.fromJson(item));
      });
    } else {
      _areasListLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
    notifyListeners();
  }
}




