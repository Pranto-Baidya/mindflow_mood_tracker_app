
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/firestore_service/firestore_service.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/model/journal_model.dart';

class DataProvider extends ChangeNotifier{

  final FirestoreService _firestoreService = FirestoreService();

  List<JournalModel> _journals = [];

  List<JournalModel> get journals => _journals;

  List<JournalModel> _searchedContent = [];

  List<JournalModel> get searchedContent =>_searchedContent;

  List<JournalModel> _filteredJournals = [];

  List<JournalModel> get filteredJournals => _filteredJournals;

  String? _selectedMood;
  String? get selectedMood => _selectedMood;

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  TimeOfDay? _selectedTime;
  TimeOfDay? get selectedTime =>_selectedTime;

  String _errorMsg  = '';
  String get errorMsg => _errorMsg;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> searchContents(String query)async{
    if(query.isEmpty){
      _searchedContent = [];
    }
    else{
      _searchedContent = _journals.where((j)=>j.content.toLowerCase().contains(query.toLowerCase())).toList();
    }
    notifyListeners();
  }

  void applyFilters() {
    _filteredJournals = _journals.where((filter) {
      final matchesMood = _selectedMood == null || filter.mood == _selectedMood;

      final matchesDate = _selectedDate == null ||
          (filter.date.year == _selectedDate!.year && filter.date.month == _selectedDate!.month && filter.date.day == _selectedDate!.day);

      final matchesTime = _selectedTime == null ||
          (filter.time.hour == _selectedTime!.hour &&
              filter.time.minute == _selectedTime!.minute);

      return matchesMood && matchesDate && matchesTime;
    }).toList();

    notifyListeners();
  }

  void setMoodFilter(String? mood){
    _selectedMood = mood;
    applyFilters();
  }

  void setDateFilter(DateTime? date){
    _selectedDate = date;
    applyFilters();
  }

  void setTimeFilter(TimeOfDay? time){
    _selectedTime = time;
    applyFilters();
  }

  void getAllJournals(String uid) {
     _isLoading = true;
     notifyListeners();

     _firestoreService.getJournals(uid).listen((data) {
         _journals = data;
         _errorMsg = '';
         _isLoading = false;
         applyFilters();
         notifyListeners();
       },
       onError: (e) {
         _errorMsg = 'Failed to fetch journals: $e';
         _journals = [];
         _isLoading = false;
         notifyListeners();
       },
       onDone: () {
         _isLoading = false;
         notifyListeners();
       },
     );
   }

  Future<void> getRefreshedJournals(String uid)async{
    try{
      _isLoading = true;
      notifyListeners();

      _journals = await _firestoreService.getJournalsForRefresh(uid);
      _errorMsg = '';
    }
    catch(e){
      _errorMsg = e.toString();
      _journals = [];
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addJournal(JournalModel journal)async{
    try{
      _isLoading = true;
      notifyListeners();
      await _firestoreService.addJournal(journal);
    }
    catch(e){
      _errorMsg = e.toString();
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateJournal(JournalModel journal)async{
    try{
      _isLoading = true;
      notifyListeners();

      await _firestoreService.updateJournal(journal);
    }
    catch(e){
      _errorMsg = e.toString();
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteJournal(String id, String uid)async{
    try{
      _isLoading = true;
      notifyListeners();
      await _firestoreService.deleteJournal(id, uid);
    }
    catch(e){
      _errorMsg = e.toString();
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearFilters() {
    _selectedMood = null;
    _selectedDate = null;
    _selectedTime = null;
    filteredJournals.clear();
    notifyListeners();
  }

}