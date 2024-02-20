import 'package:alphawash/data/model/response/onboarding_model.dart';
import 'package:alphawash/data/repository/onboarding_repo.dart';
import 'package:flutter/material.dart';

class OnBoardingProvider with ChangeNotifier {
  final OnBoardingRepo? onboardingRepo;

  OnBoardingProvider({@required this.onboardingRepo});

  List<OnBoardingModel> _onBoardingList = [];

  List<OnBoardingModel> get onBoardingList => _onBoardingList;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  changeSelectIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

}
