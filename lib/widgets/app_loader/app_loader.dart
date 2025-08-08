
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_colors/app_colors.dart';


class AppLoader{

  static Widget lightThemeLoader(){
    return LoadingAnimationWidget.staggeredDotsWave(
        color: MoodTrackerColors.lightSurface,
        size: 30.sp
    );
  }

  static Widget darkThemeLoader(){
    return LoadingAnimationWidget.staggeredDotsWave(
        color: MoodTrackerColors.darkSurface,
        size: 30.sp
    );
  }

  static Widget lightThemeLoaderPrimary(){
    return LoadingAnimationWidget.staggeredDotsWave(
        color: MoodTrackerColors.lightPrimary,
        size: 50.sp
    );
  }

  static Widget darkThemeLoaderPrimary(){
    return LoadingAnimationWidget.staggeredDotsWave(
        color: MoodTrackerColors.darkPrimary,
        size: 50.sp
    );
  }

  static Widget lightThemeLoaderPrimarySmall(){
    return LoadingAnimationWidget.staggeredDotsWave(
        color: MoodTrackerColors.lightPrimary,
        size: 30.sp
    );
  }

  static Widget darkThemeLoaderPrimarySmall(){
    return LoadingAnimationWidget.staggeredDotsWave(
        color: MoodTrackerColors.darkPrimary,
        size: 30.sp
    );
  }

}