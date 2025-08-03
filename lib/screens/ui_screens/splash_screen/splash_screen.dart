

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/auth_screens/check_user/check_user.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/status_bar_color/status%20bar%20color.dart';


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
    StatusBarColor.apply(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 80.h,),
          isDark?
          Lottie.asset('assets/emoji.json',fit: BoxFit.cover,width: 400,height: 400,)
          :Lottie.asset('assets/emoji_light.json',fit: BoxFit.cover,width: 400,height: 400,),
          Text('MindFlow',style: theme.textTheme.headlineLarge?.copyWith(color: theme.colorScheme.primary),),
          SizedBox(height: 15.h,),
          Text('Your Daily Dose of Emotional Awareness',style: theme.textTheme.titleMedium,),
        ],
      ),
    );
  }
}
