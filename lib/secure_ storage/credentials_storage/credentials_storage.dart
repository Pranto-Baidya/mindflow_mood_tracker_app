
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialsStorage{

  final _storage = FlutterSecureStorage();

  static const String _emailKey = 'email';
  static const String _passKey = 'password';
  static const String _remember = 'remember';


  Future saveEmail(String email)async{
    await _storage.write(key: _emailKey, value: email);
  }

  Future<String?> getEmail()async{
    String? email = await _storage.read(key: _emailKey);
    return email;
  }

  Future savePassword(String password)async{
    await _storage.write(key: _passKey, value: password);
  }

  Future<String?> getPassword()async{
    String? password = await _storage.read(key: _passKey);
    return password;
  }

  Future saveRememberMe(bool rememberMe)async{
    await _storage.write(key: _remember, value: rememberMe.toString());
  }

  Future<bool> getRememberMe()async {
    String? rememberMe = await _storage.read(key: _remember);
    return rememberMe == 'true';
  }

  Future clearCredentials()async{
    await _storage.deleteAll();
  }

}