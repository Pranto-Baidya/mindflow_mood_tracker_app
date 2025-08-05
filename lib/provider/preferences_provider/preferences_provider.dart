import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {

  String? _bio;
  String? get bio => _bio;

  Set<String> _customTags = {};
  Set<String> get customTags => _customTags;

  List<String> _historyList = [];
  List<String> get historyList => _historyList;

  bool _isAuthEnabled = false;

  bool get isAuthEnabled => _isAuthEnabled;

  User? get user => FirebaseAuth.instance.currentUser;

  late final StreamSubscription<User?> _authSubscription;

  PreferencesProvider() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(authStateChanged);
  }

  void authStateChanged(User? user) {
    if (user != null) {
      loadUserBio();
      loadTags();
      loadLocalAuth();
      loadSearchHistory();
    } else {
      _customTags = {};
      _bio = null;
      _isAuthEnabled = false;
      _historyList = [];
      notifyListeners();
    }
  }

  String get _bioKey => '${user!.uid}_bio';
  String get _tagKey => '${user!.uid}_tags';
  String get _authKey => '${user!.uid}_auth';
  String get _historyKey => '${user!.uid}_history';

  Future<void> saveUserBio(String bio) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (user != null) {
      await preferences.setString(_bioKey, bio);
      _bio = bio;
      notifyListeners();
    }
  }

  Future<void> loadUserBio() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (user != null) {
      String? data = preferences.getString(_bioKey);
      _bio = data;
      notifyListeners();
    }
  }

  Future<void> clearUserBio() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (user != null) {
      await preferences.remove(_bioKey);
      _bio = null;
      notifyListeners();
    }
  }

  Future<void> saveCustomTag(Set<String> tags) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (user != null) {
      await preferences.setStringList(_tagKey, tags.toList());
    }
  }

  Future<void> loadTags() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (user != null) {
      List<String>? tags = preferences.getStringList(_tagKey);
      if (tags != null) {
        _customTags = tags.toSet();
        notifyListeners();
      }
    }
  }

  Future<void> removeCustomTag(String tag)async{
    if(user!=null) {
      if (_customTags.contains(tag)) {
        _customTags.remove(tag);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setStringList(_tagKey, _customTags.toList());
        notifyListeners();
      }
    }

  }


  Future<void> toggleLocalAuth(bool enable)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(user!=null){
    await preferences.setBool(_authKey, enable);
    _isAuthEnabled = enable;
    notifyListeners();
    }
  }

  Future<void> loadLocalAuth()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(user!=null) {
      bool auth = preferences.getBool(_authKey) ?? false;
      _isAuthEnabled = auth;
      notifyListeners();
    }
  }

  Future<void> deleteLocalAuth()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(user!=null) {
      await preferences.remove(_authKey);
      _isAuthEnabled = false;
      notifyListeners();
    }
  }

  Future<void> saveSearchedHistory(String query)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(user!=null) {
      _historyList = preferences.getStringList(_historyKey) ?? [];
      _historyList.add(query);
      await preferences.setStringList(_historyKey, _historyList);
      notifyListeners();
    }
  }

  Future<void> loadSearchHistory()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(user!=null) {
      List<String> allHistory = preferences.getStringList(_historyKey) ?? [];
      _historyList = allHistory;
      notifyListeners();
    }
  }

  Future<void> removeSpecificHistory(int index)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(user!=null) {
      List<String> history = preferences.getStringList(_historyKey) ?? [];
      history.removeAt(index);
      _historyList = history;
      await preferences.setStringList(_historyKey, _historyList);
      notifyListeners();
    }
  }

  Future<void> clearAllHistory()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(user!=null){
      await preferences.remove(_historyKey);
      _historyList = [];
      await preferences.setStringList(_historyKey, _historyList);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
