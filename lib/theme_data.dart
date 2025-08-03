// Light Theme
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_colors/app_colors.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: MoodTrackerColors.lightPrimary,
    secondary: MoodTrackerColors.lightSecondary,
    surface: MoodTrackerColors.lightSurface,
    background: MoodTrackerColors.lightBackground,
    error: MoodTrackerColors.lightError,
    onPrimary: Colors.white,
    onSecondary: MoodTrackerColors.lightTextPrimary,
    onSurface: MoodTrackerColors.lightTextPrimary,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: MoodTrackerColors.lightBackground,
  textTheme: TextTheme(
    labelSmall: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontSize: 11.sp),
    labelMedium: TextStyle(color: MoodTrackerColors.lightTextSecondary, fontSize: 12.sp),
    labelLarge: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontSize: 14.sp),
    titleSmall: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontSize: 14.sp),
    titleMedium: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontSize: 16.sp),
    titleLarge: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontSize: 22.sp),
    displaySmall: TextStyle(
      color: MoodTrackerColors.lightTextPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 36.sp,
    ),
    displayMedium: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontSize: 45.sp),
    displayLarge: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontSize: 57.sp),
    headlineSmall: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontSize: 12.sp),
    bodyMedium: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontSize: 14.sp),
    bodyLarge: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontSize: 16.sp),
  ),
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(color: MoodTrackerColors.lightTextPrimary, width: 2.w),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: MoodTrackerColors.lightSurface,
    iconColor: MoodTrackerColors.lightTextPrimary,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: MoodTrackerColors.lightPrimary),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: MoodTrackerColors.lightSurface,
    selectedItemColor: MoodTrackerColors.lightPrimary,
    unselectedItemColor: MoodTrackerColors.lightTextSecondary,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: MoodTrackerColors.lightSurface,
    iconColor: MoodTrackerColors.lightTextPrimary,
    textStyle: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontSize: 14.sp),
  ),
  iconTheme: IconThemeData(color: MoodTrackerColors.lightTextPrimary),
  cardColor: MoodTrackerColors.lightSurface,
  dialogTheme: DialogThemeData(
    titleTextStyle: TextStyle(color: MoodTrackerColors.lightTextPrimary, fontSize: 28.sp),
    contentTextStyle: TextStyle(color: MoodTrackerColors.lightTextPrimary),
    backgroundColor: MoodTrackerColors.lightBackground,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: MoodTrackerColors.lightSurface,
    indicatorColor: MoodTrackerColors.lightPrimary,
  ),
  searchBarTheme: SearchBarThemeData(
    backgroundColor: WidgetStatePropertyAll(MoodTrackerColors.lightSurface),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: MoodTrackerColors.lightSurface,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(width: 2.w, color: MoodTrackerColors.lightPrimary),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none
      ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(width: 2.w, color: MoodTrackerColors.lightError),
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: MoodTrackerColors.lightBackground,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: MoodTrackerColors.lightSurface,
    foregroundColor: MoodTrackerColors.lightTextPrimary,
    scrolledUnderElevation: 0,
  ),
);

// Dark Theme
ThemeData darkTheme = ThemeData(
  //brightness: Brightness.dark,
 colorScheme: ColorScheme.dark(
    primary: MoodTrackerColors.darkPrimary,
    secondary: MoodTrackerColors.darkSecondary,
    surface: MoodTrackerColors.darkSurface,
    error: MoodTrackerColors.darkError,
    onPrimary: MoodTrackerColors.darkTextPrimary,
    onSecondary: MoodTrackerColors.darkTextPrimary,
    onSurface: MoodTrackerColors.darkTextPrimary,
    onError: MoodTrackerColors.darkTextPrimary,
  ),
  scaffoldBackgroundColor: MoodTrackerColors.darkBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: MoodTrackerColors.darkBackground,
    foregroundColor: MoodTrackerColors.darkTextPrimary,
    scrolledUnderElevation: 0,
  ),
  textTheme: TextTheme(
    labelSmall: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontSize: 11.sp),
    labelMedium: TextStyle(color: MoodTrackerColors.darkTextSecondary, fontSize: 12.sp),
    labelLarge: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontSize: 14.sp),
    titleSmall: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontSize: 14.sp),
    titleMedium: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontSize: 16.sp),
    titleLarge: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontSize: 22.sp),
    displaySmall: TextStyle(
      color: MoodTrackerColors.darkTextPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 36.sp,
    ),
    displayMedium: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontSize: 45.sp),
    displayLarge: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontSize: 57.sp),
    headlineSmall: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontSize: 12.sp),
    bodyMedium: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontSize: 14.sp),
    bodyLarge: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontSize: 16.sp),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: MoodTrackerColors.darkBackground,
  ),
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(color: MoodTrackerColors.darkTextPrimary, width: 2.w),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: MoodTrackerColors.darkSurface,
    iconColor: MoodTrackerColors.darkTextPrimary,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: MoodTrackerColors.darkPrimary),
  popupMenuTheme: PopupMenuThemeData(
    color: MoodTrackerColors.darkSurface,
    iconColor: MoodTrackerColors.darkTextPrimary,
    textStyle: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontSize: 14.sp),
  ),
  iconTheme: IconThemeData(color: MoodTrackerColors.darkTextPrimary),
  cardColor: MoodTrackerColors.darkSurface,
  dialogTheme: DialogThemeData(
    titleTextStyle: TextStyle(color: MoodTrackerColors.darkTextPrimary, fontSize: 28.sp),
    contentTextStyle: TextStyle(color: MoodTrackerColors.darkTextPrimary),
    backgroundColor: MoodTrackerColors.darkSurface,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: MoodTrackerColors.darkSurface,
    selectedItemColor: MoodTrackerColors.darkPrimary,
    unselectedItemColor: MoodTrackerColors.darkTextSecondary,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: MoodTrackerColors.darkSurface,
    indicatorColor: MoodTrackerColors.darkPrimary,
  ),
  searchBarTheme: SearchBarThemeData(
    backgroundColor: WidgetStatePropertyAll(MoodTrackerColors.darkSurface),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: MoodTrackerColors.darkSurface,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(width: 2.w, color: MoodTrackerColors.darkPrimary),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide.none
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(width: 2.w, color: MoodTrackerColors.lightError),
    ),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(MoodTrackerColors.darkSurface),
    ),
  ),
);