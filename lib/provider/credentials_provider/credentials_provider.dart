
import 'package:flutter/cupertino.dart';

import '../../secure_ storage/credentials_storage/credentials_storage.dart';

class CredentialsProvider extends ChangeNotifier{

  final CredentialsStorage _storage = CredentialsStorage();

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  String? _email = '';
  String? get email => _email;

  String? _password = '';
  String? get password => _password;


  Future<void> loadCredentials()async{
    _rememberMe = await _storage.getRememberMe();
    if(_rememberMe){
      _email = await _storage.getEmail() ?? '';
      _password = await _storage.getPassword() ?? '';
    }
    notifyListeners();
  }

  Future<void> saveCredentials(bool remember, String email, String password) async {
    await _storage.saveRememberMe(remember);
    _rememberMe = remember;

    if (_rememberMe) {
      await _storage.saveEmail(email);
      await _storage.savePassword(password);
      _email = email;
      _password = password;
    } else {
      await _storage.clearCredentials();
      _email = '';
      _password = '';
    }
    notifyListeners();
  }


  void toggleCheckBox(){
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  Future<void> clearCredentials() async {
    await _storage.clearCredentials();
    _rememberMe = false;
    _email = '';
    _password = '';
    notifyListeners();
  }

}