import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {light,dark,system}

class ThemeProvider extends ChangeNotifier{

  AppThemeMode _mode = AppThemeMode.light;
  AppThemeMode get mode => _mode;

  ThemeProvider(){
    _loadTheme();
  }

  ThemeMode get currentTheme{
    switch(_mode) {
      case AppThemeMode.light:
        return ThemeMode.light;

      case AppThemeMode.dark:
        return ThemeMode.dark;

      default : return ThemeMode.system;
    }
  }

  Future<void> _loadTheme()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final value = preferences.getString('isDarkMode');
    _mode = AppThemeMode.values.firstWhere((element)=>element.name == value);
    _applySystemUiOverlay();
    notifyListeners();
  }

  Future<void> setTheme(AppThemeMode newMode)async{
    _mode = newMode;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('isDarkMode', newMode.name);
    _applySystemUiOverlay();
    notifyListeners();
  }

  Future<void> _applySystemUiOverlay()async {
    bool isDark = _mode == AppThemeMode.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? Color(0xFF1C2526) : Color(0xFFF5F7FA),
        systemNavigationBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,
      ),
    );

  }
}
