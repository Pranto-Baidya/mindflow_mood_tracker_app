import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/firebase_options.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/auth_provider/auth_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/credentials_provider/credentials_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/data_provider/data_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/internet_connection_provider/internet_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/local_auth_provider/local_auth_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/preferences_provider/preferences_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/theme_provider/theme_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/auth_screens/check_user/check_user.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/ui_screens/home/all_mood_journal_screen.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/ui_screens/splash_screen/splash_screen.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/theme_data.dart';
import 'package:provider/provider.dart';

import 'local_notification/notification_service.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await NotificationService.init();
  await NotificationService.requestPermission();
  await NotificationService.scheduleDailyReminder();
  runApp(
     MultiProvider(
         providers: [
           ChangeNotifierProvider(create: (_)=>AuthProvider()),
           ChangeNotifierProvider(create: (_)=>DataProvider()),
           ChangeNotifierProvider(create: (_)=>InternetProvider()),
           ChangeNotifierProvider(create: (_)=>ThemeProvider()),
           ChangeNotifierProvider(create: (_)=>CredentialsProvider()),
           ChangeNotifierProvider(create: (_)=>PreferencesProvider()),
           ChangeNotifierProvider(create: (_)=>LocalAuthProvider())
         ],
       child:  const MyApp(),
     )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375,812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,_){
       return Consumer<ThemeProvider>(
         builder: (context, theme, _) {
           return MaterialApp(
           debugShowCheckedModeBanner: false,
           theme: lightTheme,
           darkTheme: darkTheme,
           themeMode: theme.currentTheme,
           home: SplashScreen(),
           );
         }
       );
      },
    );
  }
}



