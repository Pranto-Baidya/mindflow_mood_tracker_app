
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier{

   Locale? _locale;
   Locale? get locale => _locale;

   LocaleProvider(){
     loadLocale();
   }

   Future<void> setLocale(Locale locale)async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     await preferences.setString('locale', locale.languageCode);
     _locale = locale;
     notifyListeners();
   }

   Future<void> loadLocale()async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     String? langCode = preferences.getString('locale');
     if(langCode!=null){
       _locale = Locale(langCode);
       notifyListeners();
     }
   }
}