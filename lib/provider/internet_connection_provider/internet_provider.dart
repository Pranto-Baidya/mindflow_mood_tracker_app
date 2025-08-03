
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class InternetProvider extends ChangeNotifier{

  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  InternetProvider(){
    _subscription = Connectivity().onConnectivityChanged.listen(updateConnection);
  }
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  Future<void> checkConnection()async{
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    await updateConnection(result);
  }

  Future<void> updateConnection(List<ConnectivityResult> result)async{
    bool isNowConnected = result.isNotEmpty && result.first!=ConnectivityResult.none;

    if(isNowConnected!=_isConnected){
      _isConnected = isNowConnected;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

}