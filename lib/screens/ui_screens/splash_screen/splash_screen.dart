

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/auth_screens/check_user/check_user.dart';
import 'package:provider/provider.dart';

import '../../../provider/theme_provider/theme_provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void didChangeDependencies() {
    Future.delayed(Duration(seconds: 3)).then((_){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckUser()));
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: isDark ? Brightness.light : Brightness.light,
          systemNavigationBarColor: context.watch<ThemeProvider>().currentTheme == ThemeMode.dark?Color(0xFF1C2526) : Color(0xFFF5F7FA)

      ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isDark?
          Lottie.asset('assets/emoji.json',fit: BoxFit.cover,width: 380.w,height: 380.h,)
          :Lottie.asset('assets/emoji_light.json',fit: BoxFit.cover,width: 380.w,height: 380.h,),
          Text('MindFlow',style: theme.textTheme.headlineLarge?.copyWith(color: theme.colorScheme.primary),),
          SizedBox(height: 15.h,),
          Text('Your Daily Dose of Emotional Awareness',style: theme.textTheme.titleMedium,),
        ],
      ),
    );
  }
}
