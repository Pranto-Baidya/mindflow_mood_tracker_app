
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/api_service/api_service.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/database_service/db_helper.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/model/quote_model.dart';

class QuoteProvider extends ChangeNotifier{

  DBHelper dbHelper = DBHelper();

  List<QuoteModel> _allQuotes = [];
  List<QuoteModel> get allQuotes => _allQuotes;

  List<QuoteModel> _randomQuote = [];
  List<QuoteModel> get randomQuote => _randomQuote;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? get currentUid => FirebaseAuth.instance.currentUser?.uid;

  late final StreamSubscription<User?> _authSubscription;

  QuoteProvider(){
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(checkAuthState);
  }

  void checkAuthState(User? user){
    if(user!=null){
      getFavoriteQuotes();
    }
    else{
      _allQuotes = [];
    }
  }

  Future<void> getARandomQuote()async{
    try{
      _isLoading = true;
      notifyListeners();
      _randomQuote = await ApiService.fetchRandomQuote();
    }
    catch(_){
      _randomQuote = [];
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getFavoriteQuotes()async{
    if (currentUid == null) {
      _allQuotes = [];
      notifyListeners();
      return;
    }
    _allQuotes = await dbHelper.getAllQuotes(currentUid!);
    notifyListeners();
  }

  Future<void> addToFavorite(QuoteModel quote)async{
    await dbHelper.insertQuote(quote);
    await getFavoriteQuotes();
  }

  Future<void> removeFromFavorite(QuoteModel quote)async{
    await dbHelper.deleteQuote(quote);
    await getFavoriteQuotes();
  }

  Future<bool> hasAQuote()async{
    if(currentUid==null){
      return false;
    }
    return await dbHelper.hasQuote(currentUid!);
  }

  @override
  void dispose() {
   _authSubscription.cancel();
    super.dispose();
  }

}