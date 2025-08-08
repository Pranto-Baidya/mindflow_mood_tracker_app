import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/firebase_options.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/auth_provider/auth_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/credentials_provider/credentials_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/data_provider/data_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/internet_connection_provider/internet_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/local_auth_provider/local_auth_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/locale_provider/locale_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/preferences_provider/preferences_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/theme_provider/theme_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/auth_screens/check_user/check_user.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/ui_screens/home/all_mood_journal_screen.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/ui_screens/splash_screen/splash_screen.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/theme_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'l10n/app_localizations.dart';
import 'notification_service/local_notification.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initNotification();
  await NotificationService.requestPermission();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
     MultiProvider(
         providers: [
           ChangeNotifierProvider(create: (_)=>AuthProvider()),
           ChangeNotifierProvider(create: (_)=>DataProvider()),
           ChangeNotifierProvider(create: (_)=>InternetProvider()),
           ChangeNotifierProvider(create: (_)=>ThemeProvider()),
           ChangeNotifierProvider(create: (_)=>CredentialsProvider()),
           ChangeNotifierProvider(create: (_)=>PreferencesProvider()),
           ChangeNotifierProvider(create: (_)=>LocalAuthProvider()),
           ChangeNotifierProvider(create: (_)=>LocaleProvider())
         ],
       child:  const MyApp(),
     )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    return ScreenUtilInit(
      designSize: Size(375,812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,_){
       return Consumer<ThemeProvider>(
         builder: (context, theme, _) {
           return MaterialApp(
           debugShowCheckedModeBanner: false,
           locale: locale,
           supportedLocales: [
             Locale('en'),
             Locale('bn')
           ],
           localizationsDelegates: [
             AppLocalizations.delegate,
             GlobalMaterialLocalizations.delegate,
             GlobalWidgetsLocalizations.delegate,
             GlobalCupertinoLocalizations.delegate,
           ],
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



