import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/secure_%20storage/pin_lock_storage/pin_lock_storage.dart';

class LocalAuthProvider extends ChangeNotifier {
  final LocalAuthentication _authentication = LocalAuthentication();

  late final StreamSubscription<User?> _authSubscription;

  LocalAuthProvider(){
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(authStateChanged);
  }

  void authStateChanged(User? user){
    if(user!=null){
      loadPin();
    }
    else{
      _isPinSet = false;
      notifyListeners();
    }
  }

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _isPinSet = false;
  bool get isPinSet => _isPinSet;

  String _errorMsg = '';
  String get errorMsg => _errorMsg;

  Future<void> savePin(String pin) async {
    if (pin.isEmpty) {
      _errorMsg = 'PIN cannot be empty';
      return;
    }
    await PinStorage.savePin(pin);
    _isPinSet = true;
    notifyListeners();
  }

  Future<void> loadPin() async {
    _isPinSet = await PinStorage.hasPin();
    notifyListeners();
  }

  Future<void> verifyPin(String inputPin) async {
    final savedPin = await PinStorage.loadPin();
    if (savedPin == null) {
      _isAuthenticated = false;
      _errorMsg = 'Pin not set';
    }
    else if (savedPin == inputPin) {
      _isAuthenticated = true;
      _errorMsg = '';
    }
    else {
      _isAuthenticated = false;
      _errorMsg = 'Incorrect pin';
    }
    notifyListeners();
  }

  Future<void> deletePin() async {
    await PinStorage.deletePin();
    _isPinSet = false;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> authenticateUser() async {
    bool checkBioMetric = await _authentication.canCheckBiometrics;
    bool isSupported = await _authentication.isDeviceSupported();

    if (!checkBioMetric || !isSupported) {
      _isAuthenticated = false;
      _errorMsg = 'Device not supported';
      notifyListeners();
      return false;
    }

    bool didAuthenticate = await _authentication.authenticate(
      localizedReason: 'Please authenticate to access',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );

    if (didAuthenticate) {
      _isAuthenticated = true;
      _errorMsg = '';
    } else {
      _isAuthenticated = false;
      _errorMsg = 'Authentication failed';
    }

    notifyListeners();
    return didAuthenticate;
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
