

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinStorage{

  static final _storage = FlutterSecureStorage();

  static String get _pinKey => FirebaseAuth.instance.currentUser?.uid ?? '';

  static Future savePin(String pin)async{
    await _storage.write(key: _pinKey, value: pin);
  }

  static Future<String?> loadPin()async{
    return await _storage.read(key: _pinKey);
  }

  static Future<bool> hasPin()async{
    if (_pinKey.isEmpty) return false;
    return await _storage.read(key: _pinKey)!=null;
  }

  static Future deletePin()async{
    await _storage.delete(key: _pinKey);
  }
}