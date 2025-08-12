
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingProvider extends ChangeNotifier{

  bool _save = false;
  bool get save => _save;

  OnBoardingProvider(){
    loadUserOnBoarding();
  }

  Future<void> saveUserOnBoarding(bool value)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('save', value);
    _save = value;
    notifyListeners();
  }

  Future<void> loadUserOnBoarding()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool value = preferences.getBool('save') ?? false;
    _save = value;
    notifyListeners();
  }
}